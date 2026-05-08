#!/usr/bin/env python3
"""Check every formula in this tap for a newer upstream release and open a PR per bump.

Per-formula algorithm:
  1. Parse `version`, `homepage` (-> owner/repo), and the four (url, sha256) pairs.
  2. Query the latest GitHub release tag via `gh release view`.
  3. If the tag is newer, build new URLs by substituting the version into the existing
     URL templates (preserves musl/gnu/etc. without hardcoding).
  4. Download each new tarball, compute sha256.
  5. Rewrite the formula in place, branch off as `bump/<name>-<version>`,
     commit, push, and open a PR via `gh pr create`.

The script is intentionally tolerant: a failure on one formula is logged and the next
formula is still attempted. Designed to run from a GitHub Actions workflow with
GITHUB_TOKEN exported as GH_TOKEN, but also runs locally with `--dry-run`.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import subprocess
import sys
import urllib.request
from dataclasses import dataclass
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
FORMULA_DIR = REPO_ROOT / "Formula"

VERSION_RE = re.compile(r'^(\s*version\s+")([^"]+)(")', re.MULTILINE)
HOMEPAGE_RE = re.compile(r'^\s*homepage\s+"https?://github\.com/([^/]+)/([^/"]+)"', re.MULTILINE)
URL_SHA_RE = re.compile(
    r'(^\s*url\s+")(?P<url>[^"]+)("\s*\n\s*sha256\s+")(?P<sha>[0-9a-f]{64})(")',
    re.MULTILINE,
)


@dataclass
class FormulaInfo:
    path: Path
    name: str
    version: str
    owner: str
    repo: str
    url_sha_pairs: list[tuple[str, str]]


def log(msg: str) -> None:
    print(msg, file=sys.stderr, flush=True)


def parse_formula(path: Path) -> FormulaInfo | None:
    text = path.read_text()

    version_match = VERSION_RE.search(text)
    if not version_match:
        log(f"[{path.name}] no `version` line found, skipping")
        return None

    homepage_match = HOMEPAGE_RE.search(text)
    if not homepage_match:
        log(f"[{path.name}] homepage is not a github.com URL, skipping")
        return None

    pairs = [(m.group("url"), m.group("sha")) for m in URL_SHA_RE.finditer(text)]
    if len(pairs) != 4:
        log(f"[{path.name}] expected 4 url/sha256 pairs, found {len(pairs)}, skipping")
        return None

    return FormulaInfo(
        path=path,
        name=path.stem,
        version=version_match.group(2),
        owner=homepage_match.group(1),
        repo=homepage_match.group(2).removesuffix(".git"),
        url_sha_pairs=pairs,
    )


def latest_release_tag(owner: str, repo: str) -> str | None:
    try:
        result = subprocess.run(
            ["gh", "release", "view", "--repo", f"{owner}/{repo}",
             "--json", "tagName", "--jq", ".tagName"],
            check=True, capture_output=True, text=True,
        )
    except subprocess.CalledProcessError as exc:
        log(f"[{owner}/{repo}] gh release view failed: {exc.stderr.strip()}")
        return None
    tag = result.stdout.strip()
    return tag or None


def is_newer(latest: str, current: str) -> bool:
    def parts(v: str) -> list[int]:
        return [int(p) for p in re.split(r"[.\-+]", v) if p.isdigit()]
    try:
        return parts(latest) > parts(current)
    except ValueError:
        return latest != current


def build_new_url(old_url: str, old_version: str, new_version: str) -> str:
    new_url = old_url.replace(f"v{old_version}", f"v{new_version}")
    new_url = new_url.replace(f"-{old_version}-", f"-{new_version}-")
    new_url = new_url.replace(f"/{old_version}/", f"/{new_version}/")
    return new_url


def fetch_sha256(url: str) -> str:
    req = urllib.request.Request(url, headers={"User-Agent": "homebrew-tap-updater"})
    sha = hashlib.sha256()
    with urllib.request.urlopen(req, timeout=120) as resp:
        if resp.status != 200:
            raise RuntimeError(f"HTTP {resp.status} for {url}")
        for chunk in iter(lambda: resp.read(1024 * 64), b""):
            sha.update(chunk)
    return sha.hexdigest()


def rewrite_formula(text: str, old_version: str, new_version: str,
                    new_pairs: list[tuple[str, str]]) -> str:
    new_text = VERSION_RE.sub(lambda m: f'{m.group(1)}{new_version}{m.group(3)}', text, count=1)

    iterator = iter(new_pairs)

    def replace_pair(m: re.Match[str]) -> str:
        new_url, new_sha = next(iterator)
        return f'{m.group(1)}{new_url}{m.group(3)}{new_sha}{m.group(5)}'

    new_text = URL_SHA_RE.sub(replace_pair, new_text)
    return new_text


def run(cmd: list[str], **kwargs) -> subprocess.CompletedProcess:
    return subprocess.run(cmd, check=True, capture_output=True, text=True, **kwargs)


def remote_branch_exists(branch: str) -> bool:
    result = subprocess.run(
        ["git", "ls-remote", "--exit-code", "--heads", "origin", branch],
        capture_output=True, text=True,
    )
    return result.returncode == 0


def open_pr_for_bump(formula: FormulaInfo, new_version: str, dry_run: bool) -> None:
    branch = f"bump/{formula.name}-{new_version}"
    title = f"Updated {formula.name.upper()} to {new_version}"
    body = (
        f"Automated bump of `{formula.name}` from {formula.version} to {new_version}.\n\n"
        f"Upstream release: https://github.com/{formula.owner}/{formula.repo}/releases/tag/v{new_version}\n"
    )

    if dry_run:
        log(f"[{formula.name}] DRY RUN: would create branch {branch} and PR titled '{title}'")
        return

    run(["git", "checkout", "-B", branch])
    run(["git", "add", str(formula.path.relative_to(REPO_ROOT))])
    run(["git", "commit", "-m", title])
    run(["git", "push", "--set-upstream", "origin", branch])
    run(["gh", "pr", "create", "--title", title, "--body", body, "--base", "main", "--head", branch])
    run(["git", "checkout", "-"])  # return to previous branch


def process_formula(path: Path, dry_run: bool) -> bool:
    info = parse_formula(path)
    if info is None:
        return False

    latest_tag = latest_release_tag(info.owner, info.repo)
    if latest_tag is None:
        return False
    latest_version = latest_tag.removeprefix("v")

    if not is_newer(latest_version, info.version):
        log(f"[{info.name}] up to date at {info.version}")
        return False

    branch = f"bump/{info.name}-{latest_version}"
    if not dry_run and remote_branch_exists(branch):
        log(f"[{info.name}] branch {branch} already exists on origin, skipping")
        return False

    log(f"[{info.name}] bumping {info.version} -> {latest_version}")

    new_pairs: list[tuple[str, str]] = []
    for old_url, _old_sha in info.url_sha_pairs:
        new_url = build_new_url(old_url, info.version, latest_version)
        if latest_version not in new_url:
            log(f"[{info.name}] could not substitute version into URL: {old_url}")
            return False
        try:
            new_sha = fetch_sha256(new_url)
        except Exception as exc:
            log(f"[{info.name}] failed to download {new_url}: {exc}")
            return False
        log(f"[{info.name}]   {new_url} -> {new_sha}")
        new_pairs.append((new_url, new_sha))

    original = path.read_text()
    updated = rewrite_formula(original, info.version, latest_version, new_pairs)
    if updated == original:
        log(f"[{info.name}] rewrite produced no changes (regex mismatch?), skipping")
        return False

    if dry_run:
        log(f"[{info.name}] DRY RUN: would rewrite {path.name} and open PR for branch {branch}")
        return True

    path.write_text(updated)
    open_pr_for_bump(info, latest_version, dry_run=False)
    return True


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dry-run", action="store_true",
                        help="Print what would be changed without writing files or pushing")
    args = parser.parse_args()

    if not FORMULA_DIR.is_dir():
        log(f"no Formula/ directory at {FORMULA_DIR}")
        return 1

    formulae = sorted(FORMULA_DIR.glob("*.rb"))
    if not formulae:
        log("no formulae found")
        return 0

    bumped = 0
    for path in formulae:
        try:
            if process_formula(path, dry_run=args.dry_run):
                bumped += 1
        except subprocess.CalledProcessError as exc:
            log(f"[{path.name}] git/gh command failed: {exc.stderr or exc}")
        except Exception as exc:
            log(f"[{path.name}] unexpected error: {exc}")

    log(f"done, {bumped} formula(e) bumped")
    return 0


if __name__ == "__main__":
    sys.exit(main())
