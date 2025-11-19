class Airis < Formula
  desc "Docker-first monorepo workspace manager for rapid prototyping"
  homepage "https://github.com/agiletec-inc/airis-workspace"
  license "MIT"
  url "https://github.com/agiletec-inc/airis-workspace/releases/download/v1.7.0/airis-1.7.0-aarch64-apple-darwin.tar.gz"
  sha256 "de06ed9417ef84c59e53cb863e2e574805c8195ed9743f50b2d7d2e25e449931"
  version "1.7.0"

  def install
    bin.install "airis"
  end

  def caveats
    <<~EOS
      airis requires a Docker backend to run.

      Install one of the following:
        - Apple Silicon: brew install --cask orbstack
        - Intel Mac: brew install --cask docker

      Then start the Docker backend before using airis.
    EOS
  end

  test do
    system "#{bin}/airis", "--version"
  end
end
