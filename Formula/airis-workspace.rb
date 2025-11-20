class AirisWorkspace < Formula
  desc "Docker-first monorepo workspace manager for rapid prototyping"
  homepage "https://github.com/agiletec-inc/airis-workspace"
  license "MIT"
  url "https://github.com/agiletec-inc/airis-workspace/releases/download/v1.12.2/airis-1.12.2-aarch64-apple-darwin.tar.gz"
  sha256 "c70ceae395dcfd9ba8cf64c8255948f87c78dade6cd849ad95054debad3b4f41"
  version "1.12.2"

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
