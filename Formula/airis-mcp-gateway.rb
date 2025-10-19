class AirisMcpGateway < Formula
  desc "Unified MCP server management for Claude Code, Cursor, Zed, and more"
  homepage "https://github.com/agiletec-inc/airis-mcp-gateway"
  url "https://github.com/agiletec-inc/airis-mcp-gateway/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "fe3e22fb5d9ba4b9a17d116d2f9fc683582cc4e3728666312a3728b3232757d0"
  license "MIT"

  depends_on "node" => :build
  depends_on "pnpm" => :build
  depends_on "docker"

  def install
    # Install npm dependencies
    system "pnpm", "install", "--frozen-lockfile"

    # Build CLI package
    cd "packages/cli" do
      system "pnpm", "build"
    end

    # Install CLI globally
    prefix.install Dir["*"]

    # Create symlink for CLI
    bin.install_symlink prefix/"packages/cli/bin/airis-gateway.js" => "airis-gateway"
    bin.install_symlink prefix/"packages/cli/bin/airis-gateway.js" => "airis-mcp"
  end

  def caveats
    <<~EOS
      AIRIS MCP Gateway has been installed!

      Quick Start:
        1. Ensure Docker is running
        2. Run: airis-gateway install
        3. Restart your editors (Claude Code, Cursor, Zed, etc.)

      Access URLs:
        Gateway:     http://localhost:9090
        Settings UI: http://localhost:5173
        API Docs:    http://localhost:8001/docs

      Documentation: https://github.com/agiletec-inc/airis-mcp-gateway
    EOS
  end

  test do
    system "#{bin}/airis-gateway", "--version"
  end
end
