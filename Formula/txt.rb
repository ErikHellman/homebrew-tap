class Txt < Formula
  desc "Terminal text editor"
  homepage "https://github.com/ErikHellman/txt"
  version "0.4.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ErikHellman/txt/releases/download/v0.4.1/txt-v0.4.1-aarch64-apple-darwin.tar.gz"
      sha256 "de5a7be152ac20d9718e534536998258052a585764ecc127ce5881d9a9c40fd0"
    end

    on_intel do
      url "https://github.com/ErikHellman/txt/releases/download/v0.4.1/txt-v0.4.1-x86_64-apple-darwin.tar.gz"
      sha256 "b548d9d3fa98f68f72837494c7ad1fd3e12c0d712088942be106eff51da67d79"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ErikHellman/txt/releases/download/v0.4.1/txt-v0.4.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "d2ce6d6d59a4e407866d61ad503a47ce2b08275c359529037962d0f8d0a19ce3"
    end

    on_intel do
      url "https://github.com/ErikHellman/txt/releases/download/v0.4.1/txt-v0.4.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "41eef7bc6784de1242fb839eac11572d5d387a1850114ba5c9e6f2417205fea2"
    end
  end

  def install
    bin.install "txt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/txt --version")
  end
end
