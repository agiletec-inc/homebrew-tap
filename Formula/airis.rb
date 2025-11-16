class Airis < Formula
  desc "Docker-first monorepo workspace manager for rapid prototyping"
  homepage "https://github.com/agiletec-inc/airis-workspace"
  url "https://github.com/agiletec-inc/airis-workspace/releases/download/v0.1.7/airis-0.1.7-aarch64-apple-darwin.tar.gz"
  sha256 "9bf13ef6a6016ef82e8d26986c1e2d5d3f85b5747a320cab56222a495b94fe67"
  version "0.1.7"

  def install
    bin.install "airis"
  end

  test do
    system "#{bin}/airis", "--version"
  end
end
