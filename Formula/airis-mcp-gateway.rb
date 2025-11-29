class AirisMcpGateway < Formula
  desc "Unified MCP server management with 90% token reduction for Claude Code & Cursor"
  homepage "https://github.com/agiletec-inc/airis-mcp-gateway"
  url "https://github.com/agiletec-inc/airis-mcp-gateway/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "6b6b4a690a0f5e86aaff7d77b971c54a39b6f852763775fb693840ae3602765f"
  license "MIT"

  def install
    # Install project files for docker compose
    libexec.install Dir["*"]

    # Create CLI wrapper with smart Docker auto-start
    (bin/"airis-gateway").write <<~EOS
      #!/bin/bash
      set -e
      GATEWAY_DIR="#{libexec}"

      # Function: Ensure Docker is running (auto-start on macOS)
      ensure_docker() {
        if docker info >/dev/null 2>&1; then
          return 0
        fi

        echo "🐳 Starting Docker..."

        # Try OrbStack first (faster)
        if open -a OrbStack 2>/dev/null; then
          echo "   Starting OrbStack..."
        elif open -a Docker 2>/dev/null; then
          echo "   Starting Docker Desktop..."
        else
          echo "❌ Docker not found. Install Docker Desktop or OrbStack."
          exit 1
        fi

        # Wait for Docker to be ready (max 60s)
        for i in {1..60}; do
          if docker info >/dev/null 2>&1; then
            echo "✅ Docker is ready"
            return 0
          fi
          sleep 1
        done

        echo "❌ Docker failed to start within 60 seconds"
        exit 1
      }

      cd "$GATEWAY_DIR"

      case "$1" in
        install)
          echo "🚀 Installing AIRIS MCP Gateway..."

          # Setup root .env
          if [[ ! -f .env ]] && [[ -f .env.example ]]; then
            cp .env.example .env
            echo "✅ .env created"
          fi

          # Create required .env files for services
          for dir in tools/measurement tests apps/settings apps/api servers/mindbase servers/airis-mcp-gateway-control; do
            if [[ -d "$dir" ]] && [[ ! -f "$dir/.env" ]]; then
              if [[ -f "$dir/.env.example" ]]; then
                cp "$dir/.env.example" "$dir/.env"
              else
                touch "$dir/.env"
              fi
            fi
          done
          echo "✅ Service .env files created"

          # Start Docker and containers
          ensure_docker
          docker compose up -d

          # Wait for health
          echo "⏳ Waiting for Gateway..."
          for i in {1..30}; do
            if curl -sf http://api.gateway.localhost:9400/health >/dev/null 2>&1; then
              echo "✅ Gateway is healthy"
              break
            fi
            sleep 1
          done

          # Register with IDEs
          echo "📝 Registering with IDEs..."
          python3 scripts/install_all_editors.py 2>/dev/null || true

          # Register with Claude Code
          if command -v claude >/dev/null 2>&1; then
            claude mcp add --transport http airis-mcp-gateway http://api.gateway.localhost:9400/api/v1/mcp 2>/dev/null || true
            echo "✅ Registered with Claude Code"
          fi

          # Enable auto-start on login
          if command -v brew >/dev/null 2>&1; then
            brew services start airis-mcp-gateway 2>/dev/null || true
            echo "✅ Auto-start enabled (brew services)"
          fi

          echo ""
          echo "✅ Installation complete!"
          echo ""
          echo "🔗 Gateway: http://gateway.localhost:9390"
          echo "🎨 Settings: http://ui.gateway.localhost:5273"
          ;;

        start|up)
          ensure_docker
          docker compose up -d
          echo "✅ Gateway started"
          echo "🔗 http://gateway.localhost:9390"
          ;;

        stop|down)
          docker compose down
          echo "✅ Gateway stopped"
          ;;

        restart)
          ensure_docker
          docker compose restart
          ;;

        logs)
          docker compose logs -f "${@:2}"
          ;;

        status|ps)
          docker compose ps
          ;;

        update)
          echo "🔄 Updating AIRIS MCP Gateway..."
          brew upgrade agiletec-inc/tap/airis-mcp-gateway
          ensure_docker
          docker compose up -d --build
          echo "✅ Updated"
          ;;

        --version|version|-v)
          echo "airis-gateway v#{version}"
          ;;

        --help|-h|"")
          echo "AIRIS MCP Gateway - Unified MCP server management"
          echo ""
          echo "Usage: airis-gateway <command>"
          echo ""
          echo "Commands:"
          echo "  install     Setup and start Gateway (auto-starts Docker)"
          echo "  start, up   Start services (auto-starts Docker)"
          echo "  stop, down  Stop services"
          echo "  restart     Restart services"
          echo "  logs        View logs (use -f to follow)"
          echo "  status, ps  Show service status"
          echo "  update      Update via Homebrew and rebuild"
          echo "  version     Show version"
          echo ""
          echo "Auto-start on login:"
          echo "  brew services start airis-mcp-gateway"
          ;;

        *)
          echo "Unknown command: $1"
          echo "Run 'airis-gateway --help' for usage"
          exit 1
          ;;
      esac
    EOS
    chmod 0755, bin/"airis-gateway"

    bin.install_symlink "airis-gateway" => "airis-mcp"
  end

  # brew services support
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
        airis-gateway start     # Start services (auto-starts Docker)

      Auto-start on login:
        brew services start airis-mcp-gateway

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
