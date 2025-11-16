class Airis < Formula
  desc "Docker-first monorepo workspace manager for rapid prototyping"
  homepage "https://github.com/agiletec-inc/airis-workspace"
  url "https://github.com/agiletec-inc/airis-workspace/releases/download/v0.1.5/airis-0.1.5-aarch64-apple-darwin.tar.gz"
  sha256 "f6a449a0fadd8c31252f085c360d5667c1a51b5e263e484c865acc64ed7ae4a6"
  version "0.1.5"

  def install
    bin.install "airis"
  end

  test do
    system "#{bin}/airis", "--version"
  end
end
