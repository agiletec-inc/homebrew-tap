class AirisWorkspace < Formula
  desc "Docker-first monorepo workspace manager for rapid prototyping"
  homepage "https://github.com/agiletec-inc/airis-workspace"
  license "MIT"
  url "https://github.com/agiletec-inc/airis-workspace/releases/download/v1.7.1/airis-1.7.1-aarch64-apple-darwin.tar.gz"
  sha256 "260f4db9caae9a4762034f45e175e69303c02f4a8a1692d945f5c1cd925503ba"
  version "1.7.1"

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
