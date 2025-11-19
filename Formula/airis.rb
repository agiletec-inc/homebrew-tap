class Airis < Formula
  desc "Docker-first monorepo workspace manager for rapid prototyping"
  homepage "https://github.com/agiletec-inc/airis-workspace"
  url "https://github.com/agiletec-inc/airis-workspace/releases/download/v1.5.0/airis-1.5.0-aarch64-apple-darwin.tar.gz"
  sha256 "2d325ccb0c1b1d56b7ec0593e6a0c2bade32feedb27c4c13df325300dd17f0eb"
  version "1.5.0"

  def install
    bin.install "airis"
  end

  test do
    system "#{bin}/airis", "--version"
  end
end
