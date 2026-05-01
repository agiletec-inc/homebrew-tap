class AirisWorkspace < Formula
  desc "Docker-first monorepo workspace manager for rapid prototyping"
  homepage "https://github.com/agiletec-inc/airis-workspace"
  version "3.6.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/agiletec-inc/airis-workspace/releases/download/v3.6.7/airis-workspace-aarch64-apple-darwin.tar.xz"
      sha256 "eddb6f0bd8a810d0b1ab82abcb1735ee95f6669b52a7ee8d2f797b9af2e1f4eb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/agiletec-inc/airis-workspace/releases/download/v3.6.7/airis-workspace-x86_64-apple-darwin.tar.xz"
      sha256 "de60d46b32074555bb4866b28a5dcc2c582a7e1ea9b39d4008e1955246381d50"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/agiletec-inc/airis-workspace/releases/download/v3.6.7/airis-workspace-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4ab97bf55539472643d1e4ec325d933b90c9ee32b8f7c19ab4445544105871ad"
    end
    if Hardware::CPU.intel?
      url "https://github.com/agiletec-inc/airis-workspace/releases/download/v3.6.7/airis-workspace-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8e7a9dc8f5ccb57212b9122751e5653bbcc84053c882dae7871c7238b6809048"
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
