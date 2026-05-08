class Txt < Formula
  desc "Terminal text editor"
  homepage "https://github.com/ErikHellman/txt"
  version "0.3.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ErikHellman/txt/releases/download/v0.3.0/txt-v0.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "fb109f7325e5ef3376ee0d7578285c84383e559264f54a8071b47f8f52c7036e"
    end

    on_intel do
      url "https://github.com/ErikHellman/txt/releases/download/v0.3.0/txt-v0.3.0-x86_64-apple-darwin.tar.gz"
      sha256 "3d05876efe48175f67ff03e82cdf936d575cb7d3f39e5e85150b8528b80703e4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ErikHellman/txt/releases/download/v0.3.0/txt-v0.3.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "ef422b6bff3909f961dfb9a6f1553f2149b88bf3ed0c069190f2f3c4ce27459a"
    end

    on_intel do
      url "https://github.com/ErikHellman/txt/releases/download/v0.3.0/txt-v0.3.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "b5a1cec7a3c5ed8b3eb93e1de4741e19c89b3718e4e2d926d2125f30d74860b8"
    end
  end

  def install
    bin.install "txt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/txt --version")
  end
end
