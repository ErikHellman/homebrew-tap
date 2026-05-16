class Txt < Formula
  desc "Terminal text editor"
  homepage "https://github.com/ErikHellman/txt"
  version "0.7.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ErikHellman/txt/releases/download/v0.7.0/txt-v0.7.0-aarch64-apple-darwin.tar.gz"
      sha256 "50e2d774dc276c755959d7975523bf60728ab25fa5c11e0c3e213d85f2937aa1"
    end

    on_intel do
      url "https://github.com/ErikHellman/txt/releases/download/v0.7.0/txt-v0.7.0-x86_64-apple-darwin.tar.gz"
      sha256 "3275628b9574d5ae66c19f3cad8e1f34e891e21b8f06719ac24e11289136de6a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ErikHellman/txt/releases/download/v0.7.0/txt-v0.7.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "c34ec90efecebcd71f0e50865661cd1c2e95f4549d6a57e62223d5dab263d716"
    end

    on_intel do
      url "https://github.com/ErikHellman/txt/releases/download/v0.7.0/txt-v0.7.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "c48ad6de14cf9ab66e4bf997ec865411a3aad2a66d234fa4ff99fa7467c9b390"
    end
  end

  def install
    bin.install "txt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/txt --version")
  end
end
