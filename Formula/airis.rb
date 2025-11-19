class Airis < Formula
  desc "Docker-first monorepo workspace manager for rapid prototyping"
  homepage "https://github.com/agiletec-inc/airis-workspace"
  url "https://github.com/agiletec-inc/airis-workspace/releases/download/v1.4.0/airis-1.4.0-aarch64-apple-darwin.tar.gz"
  sha256 "a6d6df747ff1c09396c514d0b3e7e8649e9c6011948d4f9116f761da54af53ea"
  version "1.4.0"

  def install
    bin.install "airis"
  end

  test do
    system "#{bin}/airis", "--version"
  end
end
