class Mindbase < Formula
  desc "AI conversation knowledge management with PostgreSQL + pgvector + Ollama"
  homepage "https://github.com/agiletec-inc/mindbase"
  url "https://github.com/agiletec-inc/mindbase/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "" # TODO: Calculate after release
  license "MIT"
  head "https://github.com/agiletec-inc/mindbase.git", branch: "main"

  # Ollama runs natively on Apple Silicon for GPU acceleration
  depends_on "ollama"

  def install
    # Install entire project for docker compose
    libexec.install Dir["*"]

    # Create wrapper script
    (bin/"mindbase").write <<~EOS
      #!/bin/bash
      set -e

      MINDBASE_DIR="#{libexec}"
      cd "$MINDBASE_DIR"

      case "$1" in
        up|start)
          echo "🚀 Starting MindBase..."
          docker compose up -d
          echo "✅ MindBase running at http://localhost:18003"
          ;;
        down|stop)
          echo "🛑 Stopping MindBase..."
          docker compose down
          ;;
        logs)
          docker compose logs -f "${@:2}"
          ;;
        ps|status)
          docker compose ps
          ;;
        migrate)
          docker compose exec api alembic upgrade head
          ;;
        shell)
          docker compose exec api bash
          ;;
        version)
          echo "MindBase v#{version}"
          ;;
        *)
          echo "MindBase - AI Conversation Knowledge Management"
          echo ""
          echo "Usage: mindbase <command>"
          echo ""
          echo "Commands:"
          echo "  up, start     Start all services (PostgreSQL, API, etc.)"
          echo "  down, stop    Stop all services"
          echo "  logs          View logs (add service name for specific logs)"
          echo "  ps, status    Show running services"
          echo "  migrate       Run database migrations"
          echo "  shell         Open shell in API container"
          echo "  version       Show version"
          echo ""
          echo "Prerequisites:"
          echo "  - Docker runtime (OrbStack recommended)"
          echo "  - Ollama running: ollama serve"
          ;;
      esac
    EOS
    chmod 0755, bin/"mindbase"
  end

  def post_install
    ohai "Pulling Ollama embedding model..."
    system "ollama", "pull", "qwen3-embedding:8b"
  rescue StandardError => e
    opoo "Ollama model pull failed: #{e.message}"
    opoo "Run manually: ollama pull qwen3-embedding:8b"
  end

  def caveats
    <<~EOS
      MindBase installed!

      Prerequisites:
        - Docker runtime (OrbStack recommended for Apple Silicon)
        - Ollama running: brew services start ollama

      Quick Start:
        mindbase up        # Start services
        mindbase logs      # View logs
        mindbase down      # Stop services

      Access:
        API:  http://localhost:18003
        Docs: http://localhost:18003/docs

      First time setup:
        1. Start Ollama: ollama serve (or brew services start ollama)
        2. Start MindBase: mindbase up
        3. Embedding model is auto-pulled during install
    EOS
  end

  test do
    assert_match "MindBase v#{version}", shell_output("#{bin}/mindbase version")
  end
end
