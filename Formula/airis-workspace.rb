class AirisWorkspace < Formula
  desc "Docker-first monorepo workspace manager for rapid prototyping"
  homepage "https://github.com/agiletec-inc/airis-workspace"
  license "MIT"
  url "https://github.com/agiletec-inc/airis-workspace/releases/download/v1.8.1/airis-1.8.1-aarch64-apple-darwin.tar.gz"
  sha256 "1be360b27775e0f4642c3ac4c7401f34db32dba26c2712436d82981dcc7647be"
  version "1.8.1"

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
