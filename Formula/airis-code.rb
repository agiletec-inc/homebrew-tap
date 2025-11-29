class AirisCode < Formula
  desc "Terminal-first autonomous coding runner with Claude Code, Codex, Gemini CLI"
  homepage "https://github.com/agiletec-inc/airis-code"
  url "https://github.com/agiletec-inc/airis-code/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "461bf7f474a4a0002567947d828130b63d4e7812fca49db5d68caa720d29b911"
  license "MIT"

  def install
    libexec.install Dir["*"]

    (bin/"airis-code").write <<~EOS
      #!/bin/bash
      set -e
      AIRIS_CODE_DIR="#{libexec}"
      cd "$AIRIS_CODE_DIR"

      case "$1" in
        up|start)
          docker compose up -d
          echo "✅ AIRIS Code workspace running"
          ;;
        down|stop)
          docker compose down
          ;;
        run)
          shift
          docker compose exec workspace pnpm --filter @airis-code/cli start "$@"
          ;;
        logs)
          docker compose logs -f "${@:2}"
          ;;
        status|ps)
          docker compose ps
          ;;
        exec)
          shift
          docker compose exec workspace "$@"
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
          echo "Usage: airis-code <command> [args]"
          echo ""
          echo "Commands:"
          echo "  up, start   Start workspace"
          echo "  down, stop  Stop workspace"
          echo "  run [args]  Run autonomous coding session"
          echo "  logs        View logs"
          echo "  status, ps  Show status"
          echo "  exec <cmd>  Execute command in workspace"
          echo "  shell       Open shell"
          echo "  build       Build project"
          echo "  version     Show version"
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
        airis-code up    # Start workspace
        airis-code run   # Run autonomous coding
        airis-code down  # Stop workspace
    EOS
  end

  test do
    assert_match "AIRIS Code", shell_output("#{bin}/airis-code version")
  end
end
