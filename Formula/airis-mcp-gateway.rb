class AirisMcpGateway < Formula
  desc "Unified MCP Gateway - 25+ servers, one endpoint, 90% token reduction"
  homepage "https://github.com/agiletec-inc/airis-mcp-gateway"
  url "https://github.com/agiletec-inc/airis-mcp-gateway/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "PLACEHOLDER"
  license "MIT"

  # Thin wrapper - no build dependencies

  def install
    bin.install "scripts/airis-gateway"
  end

  def caveats
    <<~EOS
      AIRIS MCP Gateway installed!

      Quick Start:
        airis-gateway up        # Start gateway (pulls latest & runs docker compose)
        airis-gateway down      # Stop gateway
        airis-gateway logs      # View logs
        airis-gateway status    # Show status

      Configuration:
        Config dir: ~/.config/airis-mcp-gateway/
        Edit: airis-gateway config

      Register with Claude Code:
        claude mcp add --transport http airis-mcp-gateway http://localhost:9400/api/v1/mcp/sse

      Ports:
        API:     http://localhost:9400
        Gateway: http://localhost:9390
        UI:      http://localhost:5273 (with: airis-gateway up --profile ui)
    EOS
  end

  test do
    assert_match "AIRIS MCP Gateway", shell_output("#{bin}/airis-gateway help")
  end
end
