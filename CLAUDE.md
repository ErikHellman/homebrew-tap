# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

This is a personal [Homebrew tap](https://docs.brew.sh/Taps) (`Hellsoft/tap`). It hosts formulae that point at GitHub release tarballs of prebuilt binaries — there is no source code to compile here. End users install via:

```sh
brew install hellsoft/tap/<formula>
```

## Layout

- `Formula/<name>.rb` — one Ruby formula per tool. Currently only `txt.rb` ([ErikHellman/txt](https://github.com/ErikHellman/txt)).
- Each formula declares four `url`/`sha256` pairs: macOS arm/intel and Linux arm/intel, all sourced from the upstream project's GitHub Releases.

## The recurring task: bumping a formula version

This is what almost every change to this repo does. Workflow for `Formula/<name>.rb`:

1. Update `version "X.Y.Z"`.
2. Update all four `url` lines to point at the new release tag (the URL pattern is `https://github.com/<owner>/<repo>/releases/download/v<version>/<name>-v<version>-<target-triple>.tar.gz`).
3. Replace all four `sha256` values with the checksums from the new release. Get them via `gh release view v<version> --repo <owner>/<repo>` (this repo's local settings already allow `gh release:*` and `curl`), or by downloading each tarball and running `shasum -a 256`.
4. Commit with a message like `Updated TXT to <version>` to match existing history.

Do not edit `def install` or the `test do` block during a routine version bump unless the upstream binary name or `--version` output has changed.

## Verifying a formula locally

From the repo root:

```sh
brew install --build-from-source ./Formula/<name>.rb   # installs from this working copy
brew test ./Formula/<name>.rb                          # runs the `test do` block
brew audit --strict --online ./Formula/<name>.rb       # lint; --online checks URLs and SHAs
brew uninstall <name>                                  # clean up after testing
```

`brew audit --online` is the fastest way to confirm all four URLs resolve and the SHAs match before committing.

## Adding a new formula

Drop a new `Formula/<name>.rb` next to `txt.rb` using it as a template. Keep the same shape: `on_macos`/`on_linux` × `on_arm`/`on_intel`, prebuilt tarball URLs, `bin.install`, and a `test do` block that asserts `--version` output. Don't introduce build-from-source recipes unless explicitly requested — this tap is for binary distribution.
