# Homebrew Tap for Agiletec Inc.

Official Homebrew tap for [Agiletec Inc.](https://github.com/agiletec-inc) packages.

## Installation

```bash
# Add this tap
brew tap agiletec-inc/tap

# Install AIRIS MCP Gateway
brew install airis-mcp-gateway
```

## Available Formulae

### AIRIS MCP Gateway

Unified MCP server management for Claude Code, Claude Desktop, Cursor, Zed, and more.

**Install**:
```bash
brew install airis-mcp-gateway
airis-gateway install
```

**Features**:
- ✅ 25+ MCP servers in one Gateway
- ✅ Zero-token startup
- ✅ Multi-editor support
- ✅ Docker-first architecture
- ✅ Secure secret management

**Documentation**: https://github.com/agiletec-inc/airis-mcp-gateway

---

## Troubleshooting

### Formula not found

Make sure you've tapped the repository:
```bash
brew tap agiletec-inc/tap
```

### Docker not found

AIRIS MCP Gateway requires Docker:
```bash
# Install Docker Desktop
brew install --cask docker

# Or use OrbStack (lighter alternative)
brew install --cask orbstack
```

---

## License

MIT License - See individual package repositories for details.
