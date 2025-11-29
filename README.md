# Homebrew Tap for Agiletec Inc.

Official Homebrew tap for [Agiletec Inc.](https://github.com/agiletec-inc) packages.

## Quick Install (All AIRIS Tools)

```bash
brew tap agiletec-inc/tap
brew install airis-mcp-gateway airis-workspace mindbase airiscode airis-agent
```

## Available Formulae

| Formula | Description | Command |
|---------|-------------|---------|
| `airis-mcp-gateway` | Unified MCP Gateway (25+ servers) | `airis-gateway` |
| `airis-workspace` | Docker-first monorepo manager | `airis` |
| `mindbase` | AI conversation knowledge management | `mindbase` |
| `airiscode` | Terminal-first autonomous coding runner | `airiscode` |
| `airis-agent` | Claude Code enhancement framework | `airis-agent` |
| `mindbase-menubar` | macOS menu bar companion app | GUI App |

---

### AIRIS MCP Gateway

Unified MCP server management for Claude Code, Cursor, Zed, and more.

```bash
brew install airis-mcp-gateway
airis-gateway install
```

**Features**: 25+ MCP servers, zero-token startup, multi-editor support

**Docs**: https://github.com/agiletec-inc/airis-mcp-gateway

---

### AIRIS Workspace

Docker-first monorepo workspace manager for rapid prototyping.

```bash
brew install airis-workspace
airis init
airis up
```

**Features**: Docker-first, manifest-driven, cross-platform

**Docs**: https://github.com/agiletec-inc/airis-workspace

---

### MindBase

AI conversation knowledge management with PostgreSQL + pgvector + Ollama.

```bash
brew install mindbase
mindbase up
```

**Features**: Vector search, conversation analytics, MCP integration

**Docs**: https://github.com/agiletec-inc/mindbase

---

### AIRIS Code

Terminal-first autonomous coding runner with Claude Code, Codex, Gemini CLI.

```bash
brew install airiscode
airiscode up
airiscode run
```

**Features**: Multi-assistant orchestration, Super Agent runtime, MindBase memory

**Docs**: https://github.com/agiletec-inc/airiscode

---

### AIRIS Agent

Configuration framework for Claude Code with specialized commands and personas.

```bash
brew install airis-agent
airis-agent install-claude
```

**Features**: Slash commands, cognitive personas, development methodologies

**Docs**: https://github.com/agiletec-inc/airis-agent

---

### MindBase Menubar

macOS menu bar companion app for MindBase with auto-collection and chat.

```bash
brew install mindbase-menubar
open /Applications/MindBaseMenubar.app
```

**Features**: Auto-collection toggle, chat window (qwen2.5:3b), health monitoring

**Docs**: https://github.com/agiletec-inc/mindbase

---

## Prerequisites

All tools require Docker:

```bash
# Apple Silicon (recommended)
brew install --cask orbstack

# Intel Mac / Other
brew install --cask docker
```

Some tools require Ollama for local AI:

```bash
brew install ollama
brew services start ollama
ollama pull qwen3-embedding:8b  # For MindBase
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
# Start OrbStack
open -a OrbStack

# Or Docker Desktop
open -a Docker
```

### Ollama not running

```bash
brew services start ollama
ollama list  # Verify models
```

---

## License

MIT License - See individual package repositories for details.
