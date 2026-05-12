class Txt < Formula
  desc "Terminal text editor"
  homepage "https://github.com/ErikHellman/txt"
  version "0.5.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/ErikHellman/txt/releases/download/v0.5.0/txt-v0.5.0-aarch64-apple-darwin.tar.gz"
      sha256 "1ccbad56031054a9ca8ec0147955b94287b6104598a32f3b39562b7f504ecfe9"
    end

    on_intel do
      url "https://github.com/ErikHellman/txt/releases/download/v0.5.0/txt-v0.5.0-x86_64-apple-darwin.tar.gz"
      sha256 "ce3f92504e91752864e582b2d827ea9aab2eca21cf46416cc559fcab8cd0997a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ErikHellman/txt/releases/download/v0.5.0/txt-v0.5.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "94d3cb1069303f9689313a1cd543bb4257b31e8544268fcaaf02cdd7641bd46c"
    end

    on_intel do
      url "https://github.com/ErikHellman/txt/releases/download/v0.5.0/txt-v0.5.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "c5ecf31711433aa3e6a0f0845c1da5fafc1791d6e229e538edcd7ed4058aacd2"
    end
  end

  def install
    bin.install "txt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/txt --version")
  end
end
