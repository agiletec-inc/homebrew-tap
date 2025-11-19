class AirisWorkspace < Formula
  desc "Docker-first monorepo workspace manager for rapid prototyping"
  homepage "https://github.com/agiletec-inc/airis-workspace"
  license "MIT"
  url "https://github.com/agiletec-inc/airis-workspace/releases/download/v1.7.2/airis-1.7.2-aarch64-apple-darwin.tar.gz"
  sha256 "215330a148121a9c7f6723513f055fdea66fbdbe33158764fd0edc031c64a826"
  version "1.7.2"

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
