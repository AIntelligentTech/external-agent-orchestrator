---
description: Dispatch tasks to external AI agents (Codex, Gemini, OpenCode) with model and reasoning selection
argument-hint: :<agent>:<model>:<reasoning> <task>
allowed-tools: Bash(~/.claude/scripts/external-agent.sh:*), Bash(.claude/scripts/external-agent.sh:*)
---

# External Agent Dispatcher

Dispatch tasks to external AI agents with full model and reasoning control.

## Usage

```
/agent:<agent>:<model>:<reasoning> <task>
```

Or shorter forms:
```
/agent:<agent>:<model> <task>        # Uses default reasoning
/agent:<agent> <task>                 # Uses default model and reasoning
```

## Agents

| Agent | Provider | Purpose |
|-------|----------|---------|
| `codex` | OpenAI | Architecture, planning, security, reasoning |
| `gemini` | Google | Design, UI/UX, visual (FREE) |
| `opencode` | Multi | Code generation, refactoring, testing |

## Quick Reference

### Codex Models (OpenAI)
| Model | Reasoning Levels |
|-------|------------------|
| `gpt-5.2` (default) | none, minimal, low, medium, high |
| `gpt-5.1` | none, low, medium, high |
| `gpt-5` | minimal, low, medium, high |
| `gpt-5-mini` | minimal, low, medium, high |
| `o3` | low, medium, high |
| `o3-pro` | low, medium, high |
| `o4-mini` | low, medium, high |
| `gpt-4.1` | - |
| `gpt-4.1-mini` | - |
| `gpt-4` | - |

### Gemini Models (Google, FREE)
| Model | Description |
|-------|-------------|
| `gemini-3-pro` | Latest reasoning-first |
| `gemini-3-flash` (default) | Latest fast |
| `gemini-2.5-pro` | Stable advanced |
| `gemini-2.5-flash` | Stable fast |
| `gemini-2.5-flash-lite` | Budget |
| `gemini-2.0-flash` | Legacy |
| `gemini-2.0-flash-lite` | Legacy budget |

### OpenCode Models (Multi-provider)
| Model | Provider | Reasoning |
|-------|----------|-----------|
| `opus-4.5` | Anthropic | standard, extended |
| `sonnet-4.5` (default) | Anthropic | standard, extended |
| `haiku-4.5` | Anthropic | standard, extended |
| `opus-4.1` | Anthropic | standard, extended |
| `sonnet-4` | Anthropic | standard, extended |
| `gpt-5.2` | OpenAI | none-high |
| `gpt-4.1` | OpenAI | - |
| `gemini-3-pro` | Google | - (FREE) |
| `gemini-2.5-pro` | Google | - (FREE) |
| `gemini-2.5-flash` | Google | - (FREE) |

## Parse Arguments

Strip leading `:` then split by `:`:
- Part 1: Agent (codex, gemini, opencode)
- Part 2: Model (optional, uses default)
- Part 3: Reasoning (optional, uses default)
- Remainder: Task

## Examples

```bash
# Full specification
/agent:codex:gpt-5.2:high Design microservices for 10M users
/agent:opencode:opus-4.5:extended Implement real-time collaboration
/agent:gemini:gemini-3-pro Create comprehensive design system

# Model only (default reasoning)
/agent:codex:o3 Plan database migration strategy
/agent:opencode:haiku-4.5 Write utility function
/agent:gemini:gemini-2.5-flash Quick wireframe

# Agent only (default model and reasoning)
/agent:codex Review this architecture
/agent:gemini Sketch login screen
/agent:opencode Generate REST endpoint
```

## Execution

```bash
~/.claude/scripts/external-agent.sh \
  --agent "<agent>" \
  --model "<model>" \
  --reasoning "<reasoning>" \
  --type "<type>" \
  --task "<task>"
```
