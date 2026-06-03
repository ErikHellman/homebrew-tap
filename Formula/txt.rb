class Txt < Formula
  desc "Terminal text editor"
  homepage "https://github.com/ErikHellman/txt"
  version "0.7.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ErikHellman/txt/releases/download/v0.7.2/txt-v0.7.2-aarch64-apple-darwin.tar.gz"
      sha256 "797e06b01fa1ea04da425376db46454154de22d70b0dc346077abc1aad6327bf"
    end

    on_intel do
      url "https://github.com/ErikHellman/txt/releases/download/v0.7.2/txt-v0.7.2-x86_64-apple-darwin.tar.gz"
      sha256 "c491387d9c08e694cff5999a272d20b54295df53913f4af1bc172f1f9c5987b1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ErikHellman/txt/releases/download/v0.7.2/txt-v0.7.2-aarch64-unknown-linux-musl.tar.gz"
      sha256 "03e8657289b9bd1a03ab267ded7b239f9b81e4d8121c64f7513f632a04df42b8"
    end

    on_intel do
      url "https://github.com/ErikHellman/txt/releases/download/v0.7.2/txt-v0.7.2-x86_64-unknown-linux-musl.tar.gz"
      sha256 "aed7bc894b3838bed9613919c335926c2550d931abe54fcf4e67279ca3d74737"
    end
  end

  def install
    bin.install "txt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/txt --version")
  end
end
