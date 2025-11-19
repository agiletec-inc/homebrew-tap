class AirisWorkspace < Formula
  desc "Docker-first monorepo workspace manager for rapid prototyping"
  homepage "https://github.com/agiletec-inc/airis-workspace"
  license "MIT"
  url "https://github.com/agiletec-inc/airis-workspace/releases/download/v1.7.3/airis-1.7.3-aarch64-apple-darwin.tar.gz"
  sha256 "e05709cc30d1f85ba433c57680be6681600f31644788adc1d9365affa8afdc5b"
  version "1.7.3"

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
