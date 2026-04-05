class Txt < Formula
  desc "Terminal text editor"
  homepage "https://github.com/ErikHellman/txt"
  version "0.1.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ErikHellman/txt/releases/download/v0.1.2/txt-v0.1.2-aarch64-apple-darwin.tar.gz"
      sha256 "c021a7cc88c33845fab4e6eb509aafb3ccd734a827a16fe7533ed4c0959469f6"
    end

    on_intel do
      url "https://github.com/ErikHellman/txt/releases/download/v0.1.2/txt-v0.1.2-x86_64-apple-darwin.tar.gz"
      sha256 "a6904a94b5ef35f3e3f8d9b3d4ca4c1057b5241aa8e87f78b68c1a35769bc535"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ErikHellman/txt/releases/download/v0.1.2/txt-v0.1.2-aarch64-unknown-linux-musl.tar.gz"
      sha256 "f5d33d27c9701e7d2b0530749e82389b9ad90b4a76b1ed0a7f634c20f6459e1c"
    end

    on_intel do
      url "https://github.com/ErikHellman/txt/releases/download/v0.1.2/txt-v0.1.2-x86_64-unknown-linux-musl.tar.gz"
      sha256 "976838e03763c8c5639c76958c912b73d68dc699236396f5743e58aa61a2e869"
    end
  end

  def install
    bin.install "txt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/txt --version")
  end
end
