class AirisWorkspace < Formula
  desc "Docker-first monorepo workspace manager for rapid prototyping"
  homepage "https://github.com/agiletec-inc/airis-workspace"
  license "MIT"
  url "https://github.com/agiletec-inc/airis-workspace/releases/download/v1.12.3/airis-1.12.3-aarch64-apple-darwin.tar.gz"
  sha256 "6c4dc2f31af8af372ee335cf9dab69747365dbb92688fbace9b236d0e35eeee5"
  version "1.12.3"

  # Docker backend is required - this is a Docker-first tool
  on_arm do
    depends_on cask: "orbstack"
  end

  on_intel do
    depends_on cask: "docker"
  end

  def install
    bin.install "airis"
  end

  def caveats
    <<~EOS
      Make sure your Docker backend is running before using airis:
        - Apple Silicon: OrbStack (installed as dependency)
        - Intel Mac: Docker Desktop (installed as dependency)
    EOS
  end

  test do
    system "#{bin}/airis", "--version"
  end
end
