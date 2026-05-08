class Txt < Formula
  desc "Terminal text editor"
  homepage "https://github.com/ErikHellman/txt"
  version "0.3.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ErikHellman/txt/releases/download/v0.3.1/txt-v0.3.1-aarch64-apple-darwin.tar.gz"
      sha256 "aeab3ba4cd099ecd8011430e3320b22d8ac9c2343ed77ddd3350e35f3ab1252e"
    end

    on_intel do
      url "https://github.com/ErikHellman/txt/releases/download/v0.3.1/txt-v0.3.1-x86_64-apple-darwin.tar.gz"
      sha256 "03c088c0c14cc8d03d19705bc65a79a0d4e742d1474802da1d18be64f783e778"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ErikHellman/txt/releases/download/v0.3.1/txt-v0.3.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "099ec877b8a1038baf038b3bc7c59ca8cf9c6c6f64c12471695c2e682dcf1ea1"
    end

    on_intel do
      url "https://github.com/ErikHellman/txt/releases/download/v0.3.1/txt-v0.3.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "33faa2e7a39379e2ba0cf1482ec5643ca5211f101ea08823e7bc460ec4e15c68"
    end
  end

  def install
    bin.install "txt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/txt --version")
  end
end
