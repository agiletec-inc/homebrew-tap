class AirisAgent < Formula
  desc "Configuration framework for Claude Code with specialized commands and personas"
  homepage "https://github.com/agiletec-inc/airis-agent"
  url "https://github.com/agiletec-inc/airis-agent/archive/refs/tags/v4.1.6.tar.gz"
  sha256 "ffa0069dd2c1093f151b0927eadbaee14d3beb365936837ae82fbe2da8547e7a"
  license "MIT"

  on_arm do
    depends_on cask: "orbstack"
  end

  def install
    libexec.install Dir["*"]

    (bin/"airis-agent").write <<~EOS
      #!/bin/bash
      set -e
      AGENT_DIR="#{libexec}"
      cd "$AGENT_DIR"

      case "$1" in
        up|start)
          docker compose up -d
          echo "✅ AIRIS Agent running"
          ;;
        down|stop)
          docker compose down
          ;;
        logs)
          docker compose logs -f "${@:2}"
          ;;
        status|ps)
          docker compose ps
          ;;
        mcp)
          shift
          docker compose exec workspace python -m airis_agent.mcp_server "$@"
          ;;
        install-claude)
          CLAUDE_DIR="$HOME/.claude"
          mkdir -p "$CLAUDE_DIR/commands"
          if [[ -d "$AGENT_DIR/commands" ]]; then
            cp -r "$AGENT_DIR/commands/"* "$CLAUDE_DIR/commands/" 2>/dev/null || true
            echo "✅ Commands installed to $CLAUDE_DIR/commands/"
          else
            echo "⚠️  No commands directory found"
          fi
          ;;
        shell)
          docker compose exec workspace bash
          ;;
        version)
          echo "AIRIS Agent v#{version}"
          ;;
        *)
          echo "AIRIS Agent - Claude Code Enhancement Framework"
          echo ""
          echo "Usage: airis-agent <command>"
          echo ""
          echo "Commands:"
          echo "  up, start       Start agent"
          echo "  down, stop      Stop agent"
          echo "  logs            View logs"
          echo "  status, ps      Show status"
          echo "  mcp             Run MCP server"
          echo "  install-claude  Install commands to Claude Code"
          echo "  shell           Open shell"
          echo "  version         Show version"
          ;;
      esac
    EOS
    chmod 0755, bin/"airis-agent"
  end

  def caveats
    <<~EOS
      AIRIS Agent installed!

      Prerequisites:
        - Docker runtime (OrbStack recommended)

      Quick Start:
        airis-agent install-claude  # Install to Claude Code
        airis-agent up              # Start agent
    EOS
  end

  test do
    assert_match "AIRIS Agent", shell_output("#{bin}/airis-agent version")
  end
end
