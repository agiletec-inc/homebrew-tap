class Airiscode < Formula
  desc "Terminal-first autonomous coding runner with Claude Code, Codex, Gemini CLI"
  homepage "https://github.com/agiletec-inc/airiscode"
  url "https://github.com/agiletec-inc/airiscode/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "461bf7f474a4a0002567947d828130b63d4e7812fca49db5d68caa720d29b911"
  license "MIT"
  head "https://github.com/agiletec-inc/airiscode.git", branch: "main"

  depends_on "node"

  def install
    # Install entire project for docker compose
    libexec.install Dir["*"]

    # Create wrapper script
    (bin/"airiscode").write <<~EOS
      #!/bin/bash
      set -e

      AIRISCODE_DIR="#{libexec}"
      cd "$AIRISCODE_DIR"

      case "$1" in
        up|start)
          echo "🚀 Starting AIRIS Code workspace..."
          docker compose up -d
          echo "✅ Workspace running"
          ;;
        down|stop)
          echo "🛑 Stopping AIRIS Code..."
          docker compose down
          ;;
        logs)
          docker compose logs -f "${@:2}"
          ;;
        ps|status)
          docker compose ps
          ;;
        exec)
          docker compose exec workspace "${@:2}"
          ;;
        run)
          # Run autonomous coding session
          shift
          docker compose exec workspace pnpm --filter @airiscode/cli run start "$@"
          ;;
        shell)
          docker compose exec workspace sh
          ;;
        build)
          docker compose exec workspace pnpm build
          ;;
        version)
          echo "AIRIS Code v#{version}"
          ;;
        *)
          echo "AIRIS Code - Terminal-first Autonomous Coding Runner"
          echo ""
          echo "Usage: airiscode <command> [args]"
          echo ""
          echo "Commands:"
          echo "  up, start     Start workspace container"
          echo "  down, stop    Stop workspace container"
          echo "  run [args]    Run autonomous coding session"
          echo "  logs          View logs"
          echo "  ps, status    Show container status"
          echo "  exec <cmd>    Execute command in workspace"
          echo "  shell         Open shell in workspace"
          echo "  build         Build the project"
          echo "  version       Show version"
          echo ""
          echo "Prerequisites:"
          echo "  - Docker runtime (OrbStack recommended)"
          ;;
      esac
    EOS
    chmod 0755, bin/"airiscode"
  end

  def caveats
    <<~EOS
      AIRIS Code installed!

      Prerequisites:
        - Docker runtime (OrbStack recommended for Apple Silicon)
        - Claude Code, Codex CLI, or Gemini CLI installed

      Quick Start:
        airiscode up       # Start workspace
        airiscode run      # Run autonomous coding session
        airiscode down     # Stop workspace

      Supported CLI Assistants:
        - Claude Code (claude)
        - Codex CLI (codex)
        - Gemini CLI (gemini)
        - Aider (aider)
    EOS
  end

  test do
    assert_match "AIRIS Code v#{version}", shell_output("#{bin}/airiscode version")
  end
end
