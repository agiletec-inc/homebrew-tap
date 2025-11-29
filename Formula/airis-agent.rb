class AirisAgent < Formula
  desc "Configuration framework for Claude Code with specialized commands and personas"
  homepage "https://github.com/agiletec-inc/airis-agent"
  url "https://github.com/agiletec-inc/airis-agent/archive/refs/tags/v4.1.6.tar.gz"
  sha256 "ffa0069dd2c1093f151b0927eadbaee14d3beb365936837ae82fbe2da8547e7a"
  license "MIT"
  head "https://github.com/agiletec-inc/airis-agent.git", branch: "main"

  # Python for running the agent and MCP server
  depends_on "python"
  depends_on "uv" # Fast Python package manager

  def install
    # Install entire project for docker compose
    libexec.install Dir["*"]

    # Create wrapper script
    (bin/"airis-agent").write <<~EOS
      #!/bin/bash
      set -e

      AIRIS_AGENT_DIR="#{libexec}"
      cd "$AIRIS_AGENT_DIR"

      case "$1" in
        up|start)
          echo "🚀 Starting AIRIS Agent..."
          docker compose up -d
          echo "✅ Agent running"
          ;;
        down|stop)
          echo "🛑 Stopping AIRIS Agent..."
          docker compose down
          ;;
        logs)
          docker compose logs -f "${@:2}"
          ;;
        ps|status)
          docker compose ps
          ;;
        mcp)
          # Run MCP server directly (for Claude Code integration)
          shift
          cd "$AIRIS_AGENT_DIR"
          uv run python -m airis_agent.mcp_server "$@"
          ;;
        workspace-mcp)
          # Run workspace MCP server
          shift
          cd "$AIRIS_AGENT_DIR"
          uv run python -m airis_agent.workspace_mcp.server "$@"
          ;;
        install-claude)
          # Install AIRIS Agent commands to Claude Code
          echo "📦 Installing AIRIS Agent to Claude Code..."
          CLAUDE_DIR="$HOME/.claude"
          mkdir -p "$CLAUDE_DIR/commands"
          cp -r "$AIRIS_AGENT_DIR/commands/"* "$CLAUDE_DIR/commands/" 2>/dev/null || true
          echo "✅ Commands installed to $CLAUDE_DIR/commands/"
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
          echo "Usage: airis-agent <command> [args]"
          echo ""
          echo "Commands:"
          echo "  up, start       Start agent services"
          echo "  down, stop      Stop agent services"
          echo "  logs            View logs"
          echo "  ps, status      Show service status"
          echo "  mcp             Run MCP server (for Claude Code)"
          echo "  workspace-mcp   Run workspace MCP server"
          echo "  install-claude  Install commands to Claude Code"
          echo "  shell           Open shell in workspace"
          echo "  version         Show version"
          echo ""
          echo "MCP Integration:"
          echo "  Add to ~/.claude/mcp.json:"
          echo "  {"
          echo "    \"airis-agent\": {"
          echo "      \"command\": \"airis-agent\","
          echo "      \"args\": [\"mcp\"]"
          echo "    }"
          echo "  }"
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
        - Claude Code installed

      Quick Start:
        airis-agent install-claude  # Install commands to Claude Code
        airis-agent up              # Start agent services

      MCP Integration:
        Add to ~/.claude/mcp.json:
        {
          "airis-agent": {
            "command": "airis-agent",
            "args": ["mcp"]
          }
        }

      Features:
        - Specialized slash commands for Claude Code
        - Cognitive personas (architect, debugger, etc.)
        - Development methodology enforcement
    EOS
  end

  test do
    assert_match "AIRIS Agent v#{version}", shell_output("#{bin}/airis-agent version")
  end
end
