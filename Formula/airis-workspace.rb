class AirisWorkspace < Formula
  desc "Docker-first monorepo workspace manager for rapid prototyping"
  homepage "https://github.com/agiletec-inc/airis-workspace"
  version "3.19.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/agiletec-inc/airis-workspace/releases/download/v3.19.6/airis-workspace-aarch64-apple-darwin.tar.xz"
      sha256 "aaf756e3ded62ee0668e3754a77630feda43f882cc5fd4abab02f455807e6bdf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/agiletec-inc/airis-workspace/releases/download/v3.19.6/airis-workspace-x86_64-apple-darwin.tar.xz"
      sha256 "01e57cb47efc8be45e46ac39a252e2a9f5c088e2eb65f6dfbfab513070e0bd37"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/agiletec-inc/airis-workspace/releases/download/v3.19.6/airis-workspace-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "eeb03f14e3331c016c1be4b0901ddb1babc11b7f8e5f9ec941adde673fff93c4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/agiletec-inc/airis-workspace/releases/download/v3.19.6/airis-workspace-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "30fad65aa96e8650b88b63c94295654ac96e49df37061298b7860b44d506a230"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "airis" if OS.mac? && Hardware::CPU.arm?
    bin.install "airis" if OS.mac? && Hardware::CPU.intel?
    bin.install "airis" if OS.linux? && Hardware::CPU.arm?
    bin.install "airis" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
