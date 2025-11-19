class Airis < Formula
  desc "Docker-first monorepo workspace manager for rapid prototyping"
  homepage "https://github.com/agiletec-inc/airis-workspace"
  url "https://github.com/agiletec-inc/airis-workspace/releases/download/v0.2.0/airis-0.2.0-aarch64-apple-darwin.tar.gz"
  sha256 "3b9e188ee7d98c47875afd7cb63fc1ddeb212424ca12cfb84418df4c143b1598"
  version "0.2.0"

  def install
    bin.install "airis"
  end

  test do
    system "#{bin}/airis", "--version"
  end
end
