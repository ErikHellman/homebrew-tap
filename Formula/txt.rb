class Txt < Formula
  desc "Terminal text editor"
  homepage "https://github.com/ErikHellman/txt"
  version "0.7.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ErikHellman/txt/releases/download/v0.7.1/txt-v0.7.1-aarch64-apple-darwin.tar.gz"
      sha256 "3352f99a60142da99537512a94bd690c06cb4576b24eb9846c9ecc9610d9f2f0"
    end

    on_intel do
      url "https://github.com/ErikHellman/txt/releases/download/v0.7.1/txt-v0.7.1-x86_64-apple-darwin.tar.gz"
      sha256 "df3ec4a0a7af8457e698ce7fd1568492702124b78587c6c26a126bcd9473bf3c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ErikHellman/txt/releases/download/v0.7.1/txt-v0.7.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "5c122bcf0e2a0f3ec925c98c9fbda059b2de8b5a37f59669d14ba54b08198db5"
    end

    on_intel do
      url "https://github.com/ErikHellman/txt/releases/download/v0.7.1/txt-v0.7.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "67a5caa9cc2b3798492cabbd60043eb083517c36e4a2e375bfac7c99ed9e7370"
    end
  end

  def install
    bin.install "txt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/txt --version")
  end
end
