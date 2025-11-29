class AirisMcpGateway < Formula
  desc "Unified MCP server management with 90% token reduction via lazy loading"
  homepage "https://github.com/agiletec-inc/airis-mcp-gateway"
  url "https://github.com/agiletec-inc/airis-mcp-gateway/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "6b6b4a690a0f5e86aaff7d77b971c54a39b6f852763775fb693840ae3602765f"
  license "MIT"

  depends_on "docker"
  depends_on "python@3.11"

  def install
    # Install entire project structure
    prefix.install Dir["*"]

    # Create wrapper script
    (bin/"airis-gateway").write <<~EOS
      #!/bin/bash
      cd "#{prefix}" && just "$@"
    EOS

    chmod 0755, bin/"airis-gateway"
  end

  def post_install
    ohai "Setting up AIRIS MCP Gateway..."

    # Create data directory
    (var/"airis-mcp-gateway").mkpath

    # Auto-import existing IDE configs
    system "python3", prefix/"scripts/import_existing_configs.py" rescue nil
  end

  def caveats
    <<~EOS
      AIRIS MCP Gateway has been installed!

      📋 Quick Start:
        1. Ensure Docker is running
        2. Run: cd #{prefix} && just init
        3. Restart your editors (Claude Code, Cursor, Zed, etc.)

      🔧 Commands:
        just init       # Full installation (build + start + register editors)
        just up         # Start services
        just down       # Stop services
        just logs       # View logs
        just dev-next settings   # Start UI dev server

      📚 Documentation:
        #{prefix}/CLAUDE.md          # Full guide
        #{prefix}/PROJECT_INDEX.md   # Repository structure

      🌐 Access URLs:
        Gateway:     http://localhost:9390
        Settings UI: http://ui.gateway.localhost:5273
        API:         http://api.gateway.localhost:9400
    EOS
  end

  test do
    system "test", "-f", prefix/"justfile"
    system "test", "-f", prefix/"docker-compose.yml"
  end
end
