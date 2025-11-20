class AirisWorkspace < Formula
  desc "Docker-first monorepo workspace manager for rapid prototyping"
  homepage "https://github.com/agiletec-inc/airis-workspace"
  license "MIT"
  url "https://github.com/agiletec-inc/airis-workspace/releases/download/v1.11.0/airis-1.11.0-aarch64-apple-darwin.tar.gz"
  sha256 "29d7ab1bab677868d151aa566497613ad24e884560bfcd2f327d06f8becbb64b"
  version "1.11.0"

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
