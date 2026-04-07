class Txt < Formula
  desc "Terminal text editor"
  homepage "https://github.com/ErikHellman/txt"
  version "0.2.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ErikHellman/txt/releases/download/v0.2.1/txt-v0.2.1-aarch64-apple-darwin.tar.gz"
      sha256 "dcf912100ad381439b12116e50fe9f8a6931a72b52714df2ee9d2471b0437d35"
    end

    on_intel do
      url "https://github.com/ErikHellman/txt/releases/download/v0.2.1/txt-v0.2.1-x86_64-apple-darwin.tar.gz"
      sha256 "4fffb0974ece23ffd18f46e160ae4023ad599994dd678a68c2f2cee354b6c06f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ErikHellman/txt/releases/download/v0.2.1/txt-v0.2.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "b508b0de8737d0b1bf89fbdd97c2801dc3142f1430e560843aeb27096c56d6a0"
    end

    on_intel do
      url "https://github.com/ErikHellman/txt/releases/download/v0.2.1/txt-v0.2.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "409dcf67b1983365e142743ef05096b805371dc4fc867e5808f35858e4d16092"
    end
  end

  def install
    bin.install "txt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/txt --version")
  end
end
