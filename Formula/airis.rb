class Airis < Formula
  desc "Docker-first monorepo workspace manager for rapid prototyping"
  homepage "https://github.com/agiletec-inc/airis-workspace"
  url "https://github.com/agiletec-inc/airis-workspace/releases/download/v0.1.6/airis-0.1.6-aarch64-apple-darwin.tar.gz"
  sha256 "4ea2b214562ec60295a65debc278b74b9b4c0d673cce676d2370b20da16b7b68"
  version "0.1.6"

  def install
    bin.install "airis"
  end

  test do
    system "#{bin}/airis", "--version"
  end
end
