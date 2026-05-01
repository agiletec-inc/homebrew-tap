class AirisWorkspace < Formula
  desc "Docker-first monorepo workspace manager for rapid prototyping"
  homepage "https://github.com/agiletec-inc/airis-workspace"
  version "3.6.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/agiletec-inc/airis-workspace/releases/download/v3.6.5/airis-workspace-aarch64-apple-darwin.tar.xz"
      sha256 "1343ca2d9e02c8787c23dc220d4e02d1e27812893c1f12a8ca08af39bdfb7bf4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/agiletec-inc/airis-workspace/releases/download/v3.6.5/airis-workspace-x86_64-apple-darwin.tar.xz"
      sha256 "e14f37070e819c0e2b023e29120df525fe1545d40522f0513ab439e40deb36de"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/agiletec-inc/airis-workspace/releases/download/v3.6.5/airis-workspace-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f40cd501116683be90b30c4c2047ce77e6a28cbb8bb94437f7e2912b3e15f010"
    end
    if Hardware::CPU.intel?
      url "https://github.com/agiletec-inc/airis-workspace/releases/download/v3.6.5/airis-workspace-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "042d0c145cae8baa3257c6eea8d4f268645addf116a3eb7efd8c04d47b592284"
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
