class AirisMcpGateway < Formula
  desc "Unified MCP server management with 90% token reduction for Claude Code & Cursor"
  homepage "https://github.com/agiletec-inc/airis-mcp-gateway"
  url "https://github.com/agiletec-inc/airis-mcp-gateway/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "6b6b4a690a0f5e86aaff7d77b971c54a39b6f852763775fb693840ae3602765f"
  license "MIT"

  # OrbStack for Apple Silicon (recommended Docker runtime)
  on_arm do
    depends_on cask: "orbstack"
  end

  def install
    # Install project files for docker compose
    libexec.install Dir["*"]

    # Create CLI wrapper
    (bin/"airis-gateway").write <<~EOS
      #!/bin/bash
      set -e
      GATEWAY_DIR="#{libexec}"
      cd "$GATEWAY_DIR"

      case "$1" in
        install)
          echo "🚀 Installing AIRIS MCP Gateway..."
          if [[ ! -f .env ]] && [[ -f .env.example ]]; then
            cp .env.example .env
            echo "✅ .env created"
          fi
          docker compose up -d
          echo "✅ Gateway running"
          echo ""
          echo "Register with your IDE:"
          python3 scripts/install_all_editors.py 2>/dev/null || echo "Run manually: python3 $GATEWAY_DIR/scripts/install_all_editors.py"
          ;;
        start|up)
          docker compose up -d
          ;;
        stop|down)
          docker compose down
          ;;
        restart)
          docker compose restart
          ;;
        logs)
          docker compose logs -f "${@:2}"
          ;;
        status|ps)
          docker compose ps
          ;;
        update)
          git -C "$GATEWAY_DIR" pull --rebase
          docker compose up -d --build
          ;;
        version)
          echo "AIRIS MCP Gateway v#{version}"
          ;;
        *)
          echo "AIRIS MCP Gateway - Unified MCP server management"
          echo ""
          echo "Usage: airis-gateway <command>"
          echo ""
          echo "Commands:"
          echo "  install     Setup and start Gateway"
          echo "  start, up   Start services"
          echo "  stop, down  Stop services"
          echo "  restart     Restart services"
          echo "  logs        View logs"
          echo "  status, ps  Show service status"
          echo "  update      Update and rebuild"
          echo "  version     Show version"
          ;;
      esac
    EOS
    chmod 0755, bin/"airis-gateway"

    bin.install_symlink "airis-gateway" => "airis-mcp"
  end

  def caveats
    <<~EOS
      AIRIS MCP Gateway installed!

      Prerequisites:
        - Docker runtime (OrbStack recommended for Apple Silicon)

      Quick Start:
        airis-gateway install   # Setup and start
        airis-gateway logs      # View logs

      Access URLs:
        Gateway:     http://localhost:9390
        Settings UI: http://localhost:5273
        API:         http://localhost:9400
    EOS
  end

  test do
    assert_match "AIRIS MCP Gateway", shell_output("#{bin}/airis-gateway version")
  end
end
