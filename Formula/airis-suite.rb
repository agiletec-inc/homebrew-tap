class AirisSuite < Formula
  desc "Complete AIRIS development environment - MCP Gateway, Workspace, and Agent tools"
  homepage "https://github.com/agiletec-inc"
  url "https://github.com/agiletec-inc/airis-mcp-gateway/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "6b6b4a690a0f5e86aaff7d77b971c54a39b6f852763775fb693840ae3602765f"
  license "MIT"

  # Core AIRIS tools
  depends_on "agiletec/tap/airis-mcp-gateway"  # MCP server hub
  depends_on "agiletec/tap/airis-workspace"    # Monorepo manager
  depends_on "agiletec/tap/mindbase"           # Cross-session memory

  def install
    # Meta-package - just creates a marker file
    (prefix/"INSTALLED").write <<~EOS
      AIRIS Suite v#{version}
      Installed: #{Time.now}

      Components:
      - airis-mcp-gateway: Unified MCP server management
      - airis-workspace: Docker-first monorepo manager
      - mindbase: Cross-session memory with semantic search
    EOS
  end

  def caveats
    <<~EOS
      AIRIS Suite has been installed!

      Components installed:
        - airis-mcp-gateway  (MCP server hub with 90% token reduction)
        - airis-workspace    (Docker-first monorepo manager)
        - mindbase           (Cross-session memory)

      Quick Start:
        # Setup MCP Gateway
        airis-gateway install
        airis-gateway start

        # Or auto-start on login
        brew services start airis-mcp-gateway

      Individual component help:
        airis-gateway --help
        airis --help
        mindbase --help

      Access URLs:
        MCP Gateway:  http://gateway.localhost:9390
        Settings UI:  http://ui.gateway.localhost:5273
    EOS
  end

  test do
    assert_predicate prefix/"INSTALLED", :exist?
  end
end
