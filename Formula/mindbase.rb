class Mindbase < Formula
  desc "AI conversation knowledge management with PostgreSQL + pgvector + Ollama"
  homepage "https://github.com/agiletec-inc/mindbase"
  url "https://github.com/agiletec-inc/mindbase/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "dac4d2eb9cdf78accd6f1f1bf5078974b5f38410d0f18867cb4f3f1777c76777"
  license "MIT"

  on_arm do
    depends_on cask: "orbstack"
  end

  # Ollama runs locally for GPU acceleration (Apple Silicon)
  depends_on "ollama"

  def install
    libexec.install Dir["*"]

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
          docker compose down
          ;;
        logs)
          docker compose logs -f "${@:2}"
          ;;
        status|ps)
          docker compose ps
          ;;
        migrate)
          docker compose exec api alembic upgrade head
          ;;
        shell)
          docker compose exec api bash
          ;;
        model-pull)
          echo "📥 Pulling embedding model..."
          ollama pull qwen3-embedding:8b
          ;;
        setup)
          echo "🔧 Setting up MindBase..."
          ollama pull qwen3-embedding:8b
          docker compose up -d
          sleep 5
          docker compose exec api alembic upgrade head
          echo "✅ Setup complete"
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
          echo "  up, start   Start services"
          echo "  down, stop  Stop services"
          echo "  logs        View logs"
          echo "  status, ps  Show status"
          echo "  migrate     Run DB migrations"
          echo "  model-pull  Pull Ollama embedding model"
          echo "  setup       Full setup (model + start + migrate)"
          echo "  shell       Open shell in API container"
          echo "  version     Show version"
          echo ""
          echo "Prerequisites:"
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
    opoo "Model pull failed: #{e.message}"
    opoo "Run manually: ollama pull qwen3-embedding:8b"
  end

  def caveats
    <<~EOS
      MindBase installed!

      Prerequisites:
        - Docker runtime (OrbStack recommended)
        - Ollama running: brew services start ollama

      Quick Start:
        mindbase setup  # Full setup
        mindbase up     # Start services
        mindbase logs   # View logs

      Access:
        API:  http://localhost:18003
        Docs: http://localhost:18003/docs
    EOS
  end

  test do
    assert_match "MindBase", shell_output("#{bin}/mindbase version")
  end
end
