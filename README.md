# External Agent Orchestrator

> Dispatch tasks to specialized AI agents (Codex, Gemini, OpenCode) from your Claude Code sessions

[![Claude Code](https://img.shields.io/badge/Claude%20Code-Compatible-blueviolet)](https://claude.ai/code)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

External Agent Orchestrator extends Claude Code with the ability to delegate tasks to external AI coding agents:

- **Codex** (OpenAI GPT-5.2) - Architecture, planning, security analysis with configurable reasoning levels
- **Gemini** (Google) - Visual design, UI/UX, component libraries - **FREE to use**
- **OpenCode** (Multi-provider) - Code generation with Claude, GPT-4, or Gemini backends

```
┌─────────────────────────────────────────────────────────────┐
│                     Claude Code Session                      │
│                                                              │
│  /agent codex:xhigh "Design architecture"                   │
│  /gemini "Create dark mode system"                          │
│  /opencode:haiku "Write utility function"                   │
│                           │                                  │
│                           ▼                                  │
│              ┌────────────────────────┐                     │
│              │   External Agent       │                     │
│              │   Orchestrator         │                     │
│              └────────────────────────┘                     │
│                           │                                  │
└───────────────────────────┼──────────────────────────────────┘
                            │
            ┌───────────────┼───────────────┐
            ▼               ▼               ▼
      ┌──────────┐    ┌──────────┐    ┌──────────┐
      │  Codex   │    │  Gemini  │    │ OpenCode │
      │ (OpenAI) │    │ (Google) │    │ (Multi)  │
      └──────────┘    └──────────┘    └──────────┘
```

## Features

- **Single orchestrator** - One script handles all external agent calls
- **Thin commands** - Slash commands parse and dispatch with minimal overhead
- **Context isolation** - External calls don't pollute your Claude session
- **Model selection** - Choose specific models with colon syntax (`/codex:xhigh`)
- **Reasoning levels** - GPT-5.2 supports low/medium/high/xhigh reasoning effort
- **Multi-provider** - OpenCode supports Claude, GPT-4, and Gemini backends
- **FREE options** - Gemini has generous free tier (60/min, 1000/day)

## Installation

### Prerequisites

- [Claude Code CLI](https://claude.ai/code) installed
- `jq` for JSON parsing (`brew install jq`)
- `curl` for API calls

### Quick Install

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/external-agent-orchestrator.git
cd external-agent-orchestrator

# Install to user level (available in all projects)
./install.sh

# Or install to current project only
./install.sh --project
```

### Set API Keys

```bash
# OpenAI (for Codex, OpenCode:gpt4)
export OPENAI_API_KEY="sk-..."

# Google (for Gemini - FREE!)
export GOOGLE_API_KEY="AIza..."

# Anthropic (for OpenCode:opus/sonnet/haiku)
export ANTHROPIC_API_KEY="sk-ant-..."
```

Add these to your shell profile (`~/.zshrc` or `~/.bashrc`) for persistence.

## Usage

### Main Command: `/agent`

```bash
/agent <agent>[:<model>] <task> [--type TYPE]
```

### Shortcut Commands

```bash
/codex[:<reasoning>] <task>    # Architecture & reasoning
/gemini[:<model>] <task>       # Design (FREE)
/opencode[:<model>] <task>     # Code generation
```

## Agents & Models

### Codex (OpenAI) - Architecture & Reasoning

| Command | Model | Use Case |
|---------|-------|----------|
| `/codex:xhigh` | GPT-5.2 extended | Critical decisions, deep analysis |
| `/codex:high` | GPT-5.2 high | Thorough architecture |
| `/codex:medium` | GPT-5.2 medium | Balanced (default) |
| `/codex:low` | GPT-5.2 low | Fast reviews |

**Task types**: `architecture`, `planning`, `security`, `performance`

### Gemini (Google) - Design (FREE!)

| Command | Model | Use Case |
|---------|-------|----------|
| `/gemini` | Gemini 2.5 Pro | Best design quality (default) |
| `/gemini:flash` | Gemini 2.5 Flash | Fast sketches |

**Task types**: `design`, `visual`, `mockup`

**Cost**: FREE (60 requests/min, 1000/day)

### OpenCode (Multi-provider) - Code Generation

| Command | Model | Use Case |
|---------|-------|----------|
| `/opencode:opus` | Claude Opus 4.5 | Most capable |
| `/opencode:sonnet` | Claude Sonnet | Balanced (default) |
| `/opencode:haiku` | Claude Haiku | Fast, cheap |
| `/opencode:gpt4` | GPT-4 | OpenAI alternative |
| `/opencode:gemini` | Gemini | FREE |

**Task types**: `generation`, `refactor`, `testing`, `documentation`

## Examples

### Architecture

```bash
# Critical architecture decision with extended reasoning
/agent codex:xhigh Design a real-time collaboration system for 10M concurrent users --type architecture

# Quick security review
/codex:low Review this authentication flow for vulnerabilities --type security
```

### Design

```bash
# Comprehensive design system (FREE)
/gemini Create a dark mode design system with color tokens, typography scale, and component specs

# Quick UI sketch (FREE)
/gemini:flash Sketch a mobile onboarding flow with 3 screens
```

### Code Generation

```bash
# Generate production API
/opencode Generate a REST API with JWT authentication, rate limiting, and OpenAPI docs

# Quick utility function
/opencode:haiku Write a TypeScript debounce function with proper types

# FREE code generation
/opencode:gemini Generate TypeScript interfaces for a user management system
```

## Configuration

### Directory Structure

```
~/.claude/                      # User-level (all projects)
├── agents/
│   └── external-agent.md       # Subagent definition
├── commands/
│   ├── agent.md                # Main dispatcher
│   ├── codex.md                # /codex shortcut
│   ├── gemini.md               # /gemini shortcut
│   └── opencode.md             # /opencode shortcut
└── scripts/
    └── external-agent.sh       # Orchestration script
```

For project-level installation, the same structure is created in `.claude/` within your project directory.

### Reasoning Levels (Codex)

| Level | Description | Max Tokens | Speed | Cost |
|-------|-------------|------------|-------|------|
| `xhigh` | Extended reasoning | 32,000 | Slowest | $$$$ |
| `high` | Thorough analysis | 16,000 | Slow | $$$ |
| `medium` | Balanced | 8,000 | Medium | $$ |
| `low` | Fast responses | 4,000 | Fast | $ |

## Cost Guide

| Agent:Model | Speed | Cost |
|-------------|-------|------|
| `codex:xhigh` | Slow | $$$$ |
| `codex:high` | Slow | $$$ |
| `codex:medium` | Medium | $$ |
| `codex:low` | Fast | $ |
| `gemini:pro` | Medium | **FREE** |
| `gemini:flash` | Fast | **FREE** |
| `opencode:opus` | Slow | $$$ |
| `opencode:sonnet` | Medium | $$ |
| `opencode:haiku` | Fast | $ |
| `opencode:gemini` | Medium | **FREE** |

## Troubleshooting

### "API key not set"

```bash
# Check if key is set
echo $OPENAI_API_KEY

# Set the key
export OPENAI_API_KEY="your-key"
```

### "Permission denied"

```bash
chmod +x ~/.claude/scripts/external-agent.sh
```

### "Command not found"

Restart Claude Code to load new commands, or check that files exist:

```bash
ls ~/.claude/commands/
ls ~/.claude/agents/
```

### Missing `jq`

```bash
# macOS
brew install jq

# Ubuntu/Debian
sudo apt-get install jq
```

## How It Works

1. **You invoke** `/agent codex:xhigh "task"`
2. **Command parses** agent=codex, model=gpt-5.2-codex:xhigh
3. **External-agent subagent** is delegated the task
4. **Script calls** OpenAI API with `reasoning_effort=high`
5. **Response returns** to your Claude Code session

This architecture ensures:
- **Single orchestrator** - One script handles all agents
- **Thin commands** - Slash commands just parse and dispatch
- **Context isolation** - External calls don't pollute session
- **Cost efficiency** - Uses appropriate models for each task

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Claude Code](https://claude.ai/code) by Anthropic
- [OpenAI](https://openai.com) for GPT-5.2 Codex
- [Google AI](https://ai.google.dev) for Gemini (free tier!)
