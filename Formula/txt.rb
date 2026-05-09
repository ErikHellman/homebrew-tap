class Txt < Formula
  desc "Terminal text editor"
  homepage "https://github.com/ErikHellman/txt"
  version "0.4.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ErikHellman/txt/releases/download/v0.4.0/txt-v0.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "959b6cea6d1e94912ea9ae4fe3feb59ad1b3d2fe356ce870cbefbef557147611"
    end

    on_intel do
      url "https://github.com/ErikHellman/txt/releases/download/v0.4.0/txt-v0.4.0-x86_64-apple-darwin.tar.gz"
      sha256 "0d031a2ed5515a476052dff356e80df71dd5d7b865a5c23df940f775a6b0257a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ErikHellman/txt/releases/download/v0.4.0/txt-v0.4.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "05fb73cfcd35b922482bbb49093cb0a49e363f365e4be27753545f77efb045df"
    end

    on_intel do
      url "https://github.com/ErikHellman/txt/releases/download/v0.4.0/txt-v0.4.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "09981bce7b2b12aa9bdcd5390e4a95640d7b8e3d5d84291596be2355a9faec51"
    end
  end

  def install
    bin.install "txt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/txt --version")
  end
end
