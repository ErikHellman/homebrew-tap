class Txt < Formula
  desc "Terminal text editor"
  homepage "https://github.com/ErikHellman/txt"
  version "0.4.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ErikHellman/txt/releases/download/v0.4.2/txt-v0.4.2-aarch64-apple-darwin.tar.gz"
      sha256 "3dabdecddfc958290ad0515bac63a3914ade4aa0cc6ed465d09d731debf1747f"
    end

    on_intel do
      url "https://github.com/ErikHellman/txt/releases/download/v0.4.2/txt-v0.4.2-x86_64-apple-darwin.tar.gz"
      sha256 "bf7ea745971e6a07e12018de1e187cd2fb8d49ac550298d2cb17f862fddcf431"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ErikHellman/txt/releases/download/v0.4.2/txt-v0.4.2-aarch64-unknown-linux-musl.tar.gz"
      sha256 "06f8d9911273455a696537ff1e22a449f722583daf3c2563d0e4ad9b3b78edca"
    end

    on_intel do
      url "https://github.com/ErikHellman/txt/releases/download/v0.4.2/txt-v0.4.2-x86_64-unknown-linux-musl.tar.gz"
      sha256 "6cf39b679bd22307b2dc81d614bc60bc3112f4b83aa8fb63bde031e1f6c53f29"
    end
  end

  def install
    bin.install "txt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/txt --version")
  end
end
