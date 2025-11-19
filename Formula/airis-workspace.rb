class AirisWorkspace < Formula
  desc "Docker-first monorepo workspace manager for rapid prototyping"
  homepage "https://github.com/agiletec-inc/airis-workspace"
  license "MIT"
  url "https://github.com/agiletec-inc/airis-workspace/releases/download/v1.6.0/airis-1.6.0-aarch64-apple-darwin.tar.gz"
  sha256 "40a45311c3b42da34e7904e11080ace982d1be91bcf652b74781122c3143f6db"
  version "1.6.0"

  # Docker backend is required - airis is a Docker-first tool
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
      Airis is a Docker-first monorepo workspace manager.

      Make sure your Docker backend is running before using airis:
        - Apple Silicon: OrbStack (installed as dependency)
        - Intel Mac: Docker Desktop (installed as dependency)

      Get started:
        mkdir my-project && cd my-project
        airis init
        airis up
    EOS
  end

  test do
    system "#{bin}/airis", "--version"
  end
end
