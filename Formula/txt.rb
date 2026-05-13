class Txt < Formula
  desc "Terminal text editor"
  homepage "https://github.com/ErikHellman/txt"
  version "0.6.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ErikHellman/txt/releases/download/v0.6.0/txt-v0.6.0-aarch64-apple-darwin.tar.gz"
      sha256 "aa10e0099362d314922b238ba76c584b6411e629540c95dfeb3b6766cfc07e28"
    end

    on_intel do
      url "https://github.com/ErikHellman/txt/releases/download/v0.6.0/txt-v0.6.0-x86_64-apple-darwin.tar.gz"
      sha256 "302c3c5fe6ee0c1dcb4ccc294acb1e3d0d66941aa994d68ca5bb3e3d40915fb1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ErikHellman/txt/releases/download/v0.6.0/txt-v0.6.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "98f60e40867e1e0bb133b93d5d437edd5edfb3c05a10d16e478841cccb58d19e"
    end

    on_intel do
      url "https://github.com/ErikHellman/txt/releases/download/v0.6.0/txt-v0.6.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "09799f72b05dc669c7d1fccbe5b57b2238884a5555e47a64fa1609c3f966d1cc"
    end
  end

  def install
    bin.install "txt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/txt --version")
  end
end
