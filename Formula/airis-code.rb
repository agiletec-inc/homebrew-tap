class AirisCode < Formula
  desc "Terminal-first autonomous coding runner with Claude Code, Codex, Gemini CLI"
  homepage "https://github.com/agiletec-inc/airis-code"
  url "https://github.com/agiletec-inc/airis-code/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "461bf7f474a4a0002567947d828130b63d4e7812fca49db5d68caa720d29b911"
  license "MIT"

  def install
    libexec.install Dir["*"]

    # Main CLI command (mirrors actual airis CLI)
    (bin/"airis-code").write <<~EOS
      #!/bin/bash
      set -e
      AIRIS_CODE_DIR="#{libexec}"

      # Ensure workspace is running
      ensure_running() {
        if ! docker compose -f "$AIRIS_CODE_DIR/docker-compose.yml" ps --status running 2>/dev/null | grep -q workspace; then
          echo "🚀 Starting AIRIS Code workspace..."
          docker compose -f "$AIRIS_CODE_DIR/docker-compose.yml" up -d
          sleep 2
        fi
      }

      # Execute CLI command inside container
      run_cli() {
        ensure_running
        docker compose -f "$AIRIS_CODE_DIR/docker-compose.yml" exec -T workspace \\
          pnpm --filter @airiscode/cli start "$@"
      }

      case "$1" in
        # Workspace management
        up|start)
          docker compose -f "$AIRIS_CODE_DIR/docker-compose.yml" up -d
          echo "✅ AIRIS Code workspace running"
          ;;
        down|stop)
          docker compose -f "$AIRIS_CODE_DIR/docker-compose.yml" down
          ;;
        logs)
          shift
          docker compose -f "$AIRIS_CODE_DIR/docker-compose.yml" logs -f "$@"
          ;;
        ps|status)
          docker compose -f "$AIRIS_CODE_DIR/docker-compose.yml" ps
          ;;
        shell)
          ensure_running
          docker compose -f "$AIRIS_CODE_DIR/docker-compose.yml" exec workspace sh
          ;;
        build)
          ensure_running
          docker compose -f "$AIRIS_CODE_DIR/docker-compose.yml" exec workspace pnpm build
          ;;

        # CLI commands (pass through to airis CLI)
        code)
          shift
          run_cli code "$@"
          ;;
        chat)
          shift
          run_cli chat "$@"
          ;;
        config)
          shift
          run_cli config "$@"
          ;;
        session)
          shift
          run_cli session "$@"
          ;;

        # Version
        -v|--version|version)
          echo "AIRIS Code v#{version}"
          ;;

        # Help
        -h|--help|help|"")
          echo "AIRIS Code - Terminal-first Autonomous Coding Runner"
          echo ""
          echo "Usage: airis-code [command] [options]"
          echo ""
          echo "CLI Commands:"
          echo "  <task>         Execute task (shorthand for 'code <task>')"
          echo "  code <task>    Execute coding task"
          echo "  chat           Interactive chat mode"
          echo "  config         Configuration management"
          echo "  session        Session management"
          echo ""
          echo "Workspace Commands:"
          echo "  up, start      Start workspace container"
          echo "  down, stop     Stop workspace container"
          echo "  logs           View container logs"
          echo "  ps, status     Show container status"
          echo "  shell          Open shell in container"
          echo "  build          Build project"
          echo ""
          echo "Options:"
          echo "  -v, --version  Show version"
          echo "  -h, --help     Show this help"
          ;;

        # Default: treat as task (shorthand for 'code <task>')
        *)
          run_cli "$@"
          ;;
      esac
    EOS
    chmod 0755, bin/"airis-code"
  end

  def caveats
    <<~EOS
      AIRIS Code installed!

      Prerequisites:
        - Docker runtime (OrbStack recommended)

      Quick Start:
        airis-code up              # Start workspace
        airis-code "fix the bug"   # Run task
        airis-code chat            # Interactive mode
        airis-code down            # Stop workspace

      CLI Commands:
        airis-code code <task>     # Execute coding task
        airis-code config          # Configuration
        airis-code session         # Session management
    EOS
  end

  test do
    assert_match "AIRIS Code", shell_output("#{bin}/airis-code version")
  end
end
