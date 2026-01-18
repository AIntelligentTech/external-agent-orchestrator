# External Agent Orchestrator

> Dispatch tasks to specialized AI agents (Codex, Gemini, OpenCode) from your Claude Code sessions

[![Claude Code](https://img.shields.io/badge/Claude%20Code-Compatible-blueviolet)](https://claude.ai/code)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

External Agent Orchestrator extends Claude Code with the ability to delegate tasks to external AI coding agents:

- **Codex** (OpenAI) - Architecture, planning, security with GPT-5.2, o3, and reasoning levels
- **Gemini** (Google) - Visual design, UI/UX, component libraries - **FREE to use**
- **OpenCode** (Multi-provider) - Code generation with Claude 4.5, GPT-5.2, or Gemini

```
┌─────────────────────────────────────────────────────────────┐
│                     Claude Code Session                      │
│                                                              │
│  /codex:gpt-5.2:high Design architecture                    │
│  /gemini:gemini-3-pro Create design system                  │
│  /opencode:opus-4.5:extended Implement feature              │
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

- **Consistent syntax** - All commands use `/<agent>:<model>:<reasoning>` format
- **27 models** - 10 OpenAI, 7 Gemini, 10 OpenCode models
- **Reasoning control** - Fine-tune thinking depth (none → high, standard → extended)
- **Multi-provider** - Claude, OpenAI, and Gemini backends
- **FREE options** - All Gemini models are free (60/min, 1000/day)
- **Context isolation** - External calls don't pollute your Claude session

## Installation

### Prerequisites

- [Claude Code CLI](https://claude.ai/code) installed
- `jq` for JSON parsing (`brew install jq`)
- `curl` for API calls

### Quick Install

```bash
git clone https://github.com/AIntelligentTech/external-agent-orchestrator.git
cd external-agent-orchestrator

# Install to user level (available in all projects)
./install.sh

# Or install to current project only
./install.sh --project
```

### Set API Keys

```bash
# OpenAI (for Codex, OpenCode with GPT models)
export OPENAI_API_KEY="sk-..."

# Google (for Gemini - FREE!)
export GOOGLE_API_KEY="AIza..."

# Anthropic (for OpenCode with Claude models)
export ANTHROPIC_API_KEY="sk-ant-..."
```

## Usage

### Consistent Command Format

```bash
/<agent>:<model>:<reasoning> <task>
```

### Examples

```bash
# Codex - Architecture with GPT-5.2 high reasoning
/codex:gpt-5.2:high Design a real-time collaboration system for 10M users

# Gemini - Design with latest model (FREE)
/gemini:gemini-3-pro Create a comprehensive dark mode design system

# OpenCode - Code generation with Claude extended thinking
/opencode:opus-4.5:extended Implement complex WebSocket system
```

## Models Reference (January 2026)

### Codex Models (OpenAI) - 10 models

| Model | Description | Reasoning Levels |
|-------|-------------|------------------|
| `gpt-5.2` | Latest, smartest (default) | none, minimal, low, medium, high |
| `gpt-5.1` | Previous generation | none, low, medium, high |
| `gpt-5` | Base GPT-5 | minimal, low, medium, high |
| `gpt-5-mini` | Fast, cost-efficient | minimal, low, medium, high |
| `o3` | Reasoning specialist | low, medium, high |
| `o3-pro` | Extended thinking | low, medium, high |
| `o4-mini` | Fast reasoning | low, medium, high |
| `gpt-4.1` | Smartest non-reasoning | - |
| `gpt-4.1-mini` | Fast non-reasoning | - |
| `gpt-4` | Legacy | - |

**Task types**: `architecture`, `planning`, `security`, `performance`

### Gemini Models (Google, FREE) - 7 models

| Model | Description | Speed |
|-------|-------------|-------|
| `gemini-3-pro` | Latest reasoning-first, agentic | Medium |
| `gemini-3-flash` | Latest fast model (default) | Fast |
| `gemini-2.5-pro` | Stable, advanced reasoning | Medium |
| `gemini-2.5-flash` | Stable, multimodal, 1M context | Fast |
| `gemini-2.5-flash-lite` | Cost-optimized | Fastest |
| `gemini-2.0-flash` | Previous generation | Fast |
| `gemini-2.0-flash-lite` | Budget option | Fastest |

**Task types**: `design`, `visual`, `mockup`

**Cost**: ALL FREE (60 requests/min, 1000/day)

### OpenCode Models (Multi-provider) - 10 models

#### Anthropic Claude
| Model | Description | Reasoning |
|-------|-------------|-----------|
| `opus-4.5` | Most capable, premium | standard, extended |
| `sonnet-4.5` | Best balance (default) | standard, extended |
| `haiku-4.5` | Fastest Claude | standard, extended |
| `opus-4.1` | Legacy capable | standard, extended |
| `sonnet-4` | Legacy balance | standard, extended |

#### OpenAI
| Model | Description | Reasoning |
|-------|-------------|-----------|
| `gpt-5.2` | Latest OpenAI | none-high |
| `gpt-4.1` | Smartest non-reasoning | - |

#### Google (FREE)
| Model | Description |
|-------|-------------|
| `gemini-3-pro` | Latest reasoning |
| `gemini-2.5-pro` | Stable |
| `gemini-2.5-flash` | Fast |

**Task types**: `generation`, `refactor`, `testing`, `documentation`

## Reasoning Levels

### OpenAI Models (Codex, OpenCode)

| Level | Description | Use Case |
|-------|-------------|----------|
| `none` | No reasoning (GPT-5.x only) | Fastest responses |
| `minimal` | Minimal thinking | Quick reviews |
| `low` | Light reasoning | Simple analysis |
| `medium` | Balanced (default) | Standard tasks |
| `high` | Deep reasoning | Complex architecture |

### Claude Models (OpenCode)

| Level | Description | Use Case |
|-------|-------------|----------|
| `standard` | Normal response (default) | Most tasks |
| `extended` | Extended thinking enabled | Complex problems |

## Examples

### Architecture

```bash
# Deep architecture with GPT-5.2
/codex:gpt-5.2:high Design microservices for 10M concurrent users

# Extended thinking with o3-pro
/codex:o3-pro:high Review security architecture for vulnerabilities

# Fast planning with mini model
/codex:gpt-5-mini:low Quick review of API structure
```

### Design (FREE)

```bash
# Latest reasoning model
/gemini:gemini-3-pro Create comprehensive design system with tokens

# Fast sketching
/gemini:gemini-3-flash Quick sketch of mobile onboarding

# Stable production model
/gemini:gemini-2.5-pro Design accessible component library
```

### Code Generation

```bash
# Most capable Claude with extended thinking
/opencode:opus-4.5:extended Implement real-time WebSocket collaboration

# Best balance for most tasks
/opencode:sonnet-4.5 Generate REST API with JWT authentication

# Fast utility
/opencode:haiku-4.5 Write TypeScript debounce function

# FREE code generation
/opencode:gemini-3-pro Create React component library
```

### Full Agent Syntax

```bash
# Full specification
/agent:codex:gpt-5.2:high Design microservices
/agent:opencode:opus-4.5:extended Complex implementation
/agent:gemini:gemini-3-pro Comprehensive design

# Shorter forms
/agent:codex:o3 Plan migration (default reasoning)
/agent:gemini Quick sketch (default model)
```

## Cost Guide

| Model | Speed | Cost |
|-------|-------|------|
| `gpt-5.2` | Medium | $$ |
| `o3-pro` | Slow | $$$ |
| `gpt-5-mini` | Fast | $ |
| `opus-4.5` | Moderate | $$$ |
| `sonnet-4.5` | Fast | $$ |
| `haiku-4.5` | Fastest | $ |
| `gemini-*` | Varies | **FREE** |

## Configuration

### Directory Structure

```
~/.claude/                      # User-level (all projects)
├── agents/
│   └── external-agent.md       # Subagent definition
├── commands/
│   ├── agent.md                # /agent:<agent>:<model>:<reasoning>
│   ├── codex.md                # /codex:<model>:<reasoning>
│   ├── gemini.md               # /gemini:<model>
│   └── opencode.md             # /opencode:<model>:<reasoning>
└── scripts/
    └── external-agent.sh       # Orchestration script
```

## Troubleshooting

### "API key not set"

```bash
echo $OPENAI_API_KEY
export OPENAI_API_KEY="your-key"
```

### "Permission denied"

```bash
chmod +x ~/.claude/scripts/external-agent.sh
```

### "Command not found"

Restart Claude Code to load new commands.

## How It Works

1. **You invoke** `/codex:gpt-5.2:high Design microservices`
2. **Command parses** model=gpt-5.2, reasoning=high
3. **External-agent subagent** orchestrates the task
4. **Script calls** OpenAI API with `reasoning_effort=high`
5. **Response returns** to your Claude Code session

## Sources

Model information sourced from official documentation:
- [OpenAI Models](https://platform.openai.com/docs/models/)
- [Google Gemini Models](https://ai.google.dev/gemini-api/docs/models)
- [Anthropic Claude Models](https://platform.claude.com/docs/en/about-claude/models/overview)

## Contributing

Contributions welcome! Please submit a Pull Request.

## License

MIT License - see [LICENSE](LICENSE) file.
