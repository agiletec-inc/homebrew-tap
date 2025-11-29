class AirisMcpGateway < Formula
  desc "Unified MCP server management with 90% token reduction for Claude Code & Cursor"
  homepage "https://github.com/agiletec-inc/airis-mcp-gateway"
  url "https://github.com/agiletec-inc/airis-mcp-gateway/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "6b6b4a690a0f5e86aaff7d77b971c54a39b6f852763775fb693840ae3602765f"
  license "MIT"

  depends_on "node"

  def install
    # Install CLI package with dev dependencies for TypeScript build
    cd "packages/cli" do
      system "npm", "install"
      system "npx", "tsc"
    end

    # Install CLI files
    libexec.install "packages/cli/dist", "packages/cli/node_modules", "packages/cli/package.json"

    # Install scripts for full installation
    (libexec/"scripts").install Dir["scripts/*"]
    libexec.install ".env.example"

    # Create wrapper script that runs dist/index.js directly
    (bin/"airis-gateway").write <<~EOS
      #!/bin/bash
      export NODE_PATH="#{libexec}/node_modules"
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/dist/index.js" "$@"
    EOS

    # Also create airis-mcp alias
    bin.install_symlink "airis-gateway" => "airis-mcp"
  end

  # brew services support - runs on macOS startup
  service do
    run [opt_bin/"airis-gateway", "start"]
    keep_alive false
    log_path var/"log/airis-mcp-gateway.log"
    error_log_path var/"log/airis-mcp-gateway.log"
    working_dir var/"airis-mcp-gateway"
  end

  def post_install
    # Create working directory
    (var/"airis-mcp-gateway").mkpath
    (var/"log").mkpath
  end

  def caveats
    <<~EOS
      AIRIS MCP Gateway has been installed!

      Quick Start:
        airis-gateway install   # Clone repo, setup Docker, register IDEs
        airis-gateway start     # Start Gateway (auto-starts Docker)

      Auto-start on login:
        brew services start airis-mcp-gateway

      Commands:
        airis-gateway install   # Full installation
        airis-gateway start     # Start containers (auto-starts Docker)
        airis-gateway stop      # Stop containers
        airis-gateway status    # Show container status
        airis-gateway logs -f   # Follow logs
        airis-gateway update    # Update to latest version

      Access URLs:
        Gateway:     http://gateway.localhost:9390
        Settings UI: http://ui.gateway.localhost:5273
        API:         http://api.gateway.localhost:9400
    EOS
  end

  test do
    assert_match "airis-gateway", shell_output("#{bin}/airis-gateway --help")
  end
end
