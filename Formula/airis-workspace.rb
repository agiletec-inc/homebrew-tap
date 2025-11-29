class AirisWorkspace < Formula
  desc "Docker-first monorepo workspace manager for rapid prototyping"
  homepage "https://github.com/agiletec-inc/airis-workspace"
  license "MIT"
  url "https://github.com/agiletec-inc/airis-workspace/releases/download/v1.32.0/airis-1.32.0-aarch64-apple-darwin.tar.gz"
  sha256 "b364602591ef9cc69c3beeb423233ada79a3fa80bb5c72cf82bd5e9848a9202a"
  version "1.32.0"

  # OrbStack for Apple Silicon (recommended Docker runtime)
  on_arm do
    depends_on cask: "orbstack"
  end
  # Intel Mac: User installs Docker manually

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
