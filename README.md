# Homebrew Tap for Agiletec Inc.

Official Homebrew tap for [Agiletec Inc.](https://github.com/agiletec-inc) packages.

## Quick Install

### macOS (Apple Silicon)

```bash
brew tap agiletec-inc/tap
brew install airis-suite
```

### macOS (Intel)

```bash
brew tap agiletec-inc/tap
brew install airis-suite
# Note: Install Docker manually (OrbStack or Docker Desktop)
```

### Linux / WSL2

```bash
curl -fsSL https://raw.githubusercontent.com/agiletec-inc/airis-mcp-gateway/main/scripts/install-suite.sh | bash
```

### Windows

Use WSL2 (recommended) or Docker Compose directly:
```powershell
git clone https://github.com/agiletec-inc/airis-mcp-gateway
cd airis-mcp-gateway
docker compose up -d
```

---

## Available Formulae

| Formula | Description | Command |
|---------|-------------|---------|
| `airis-suite` | **All AIRIS tools** (meta-package) | - |
| `airis-mcp-gateway` | Unified MCP Gateway (25+ servers) | `airis-gateway` |
| `airis-workspace` | Docker-first monorepo manager | `airis` |
| `mindbase` | AI conversation knowledge management | `mindbase` |
| `airiscode` | Terminal-first autonomous coding runner | `airiscode` |
| `airis-agent` | Claude Code enhancement framework | `airis-agent` |
| `mindbase-menubar` | macOS menu bar companion app | GUI App |

---

## Components

### AIRIS MCP Gateway

Unified MCP server management for Claude Code, Cursor, Zed, and more.

```bash
brew install airis-mcp-gateway
airis-gateway install
```

### AIRIS Workspace

Docker-first monorepo workspace manager.

```bash
brew install airis-workspace
airis init && airis up
```

### MindBase

AI conversation knowledge management with vector search.

```bash
brew install mindbase
mindbase setup
```

### AIRIS Code

Terminal-first autonomous coding runner.

```bash
brew install airiscode
airiscode up && airiscode run
```

### AIRIS Agent

Claude Code enhancement framework.

```bash
brew install airis-agent
airis-agent install-claude
```

---

## Prerequisites

### Apple Silicon Mac

OrbStack is automatically installed as a dependency.

### Intel Mac / Linux

Install Docker manually:
- **Intel Mac**: [Docker Desktop](https://docs.docker.com/desktop/install/mac-install/) or [OrbStack](https://orbstack.dev/)
- **Linux**: [Docker Engine](https://docs.docker.com/engine/install/)

### Ollama (for MindBase)

MindBase requires Ollama for local AI inference:
```bash
brew install ollama
brew services start ollama
```

---

## Troubleshooting

### Formula not found

```bash
brew tap agiletec-inc/tap
brew update
```

### Docker not running

```bash
# OrbStack
open -a OrbStack

# Docker Desktop
open -a Docker
```

---

## License

MIT License - See individual package repositories for details.
