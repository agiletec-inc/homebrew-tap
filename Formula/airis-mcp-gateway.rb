class AirisMcpGateway < Formula
  desc "Unified MCP server management with 90% token reduction for Claude Code & Cursor"
  homepage "https://github.com/agiletec-inc/airis-mcp-gateway"
  url "https://github.com/agiletec-inc/airis-mcp-gateway/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "6b6b4a690a0f5e86aaff7d77b971c54a39b6f852763775fb693840ae3602765f"
  license "MIT"

  depends_on "node@20"
  depends_on "pnpm"

  def install
    # Install and build using pnpm (required for workspace)
    system "pnpm", "install", "--frozen-lockfile"
    system "pnpm", "--filter", "@agiletec/airis-mcp-gateway", "build"

    # Deploy CLI with production dependencies
    cli_dir = buildpath/"packages/cli"
    cd cli_dir do
      system "pnpm", "deploy", "--prod", libexec
    end

    # Create wrapper script
    (bin/"airis-gateway").write <<~EOS
      #!/bin/bash
      exec "#{Formula["node@20"].opt_bin}/node" "#{libexec}/bin/airis-gateway.js" "$@"
    EOS

    bin.install_symlink "airis-gateway" => "airis-mcp"
  end

  # brew services - calls CLI start command
  service do
    run [opt_bin/"airis-gateway", "start"]
    keep_alive false
    log_path var/"log/airis-mcp-gateway.log"
    error_log_path var/"log/airis-mcp-gateway.log"
  end

  def post_install
    (var/"log").mkpath
  end

  def caveats
    <<~EOS
      AIRIS MCP Gateway installed!

      Quick Start:
        airis-gateway install   # Setup, start Docker, register IDEs

      Commands:
        airis-gateway install   # Full installation (auto-starts Docker)
        airis-gateway start     # Start services
        airis-gateway stop      # Stop services
        airis-gateway status    # Show status
        airis-gateway logs -f   # View logs
        airis-gateway update    # Update to latest

      Auto-start on login is enabled automatically during install.
      Or manually: brew services start airis-mcp-gateway

      Access URLs:
        Gateway:     http://gateway.localhost:9390
        Settings UI: http://ui.gateway.localhost:5273
        API:         http://api.gateway.localhost:9400
    EOS
  end

  test do
    assert_match "airis-gateway", shell_output("#{bin}/airis-gateway --version")
  end
end
