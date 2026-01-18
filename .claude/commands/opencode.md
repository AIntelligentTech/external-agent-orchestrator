---
description: OpenCode agent for code generation, refactoring, and testing (multi-provider)
argument-hint: :<model>:<reasoning> <task>
allowed-tools: Bash(~/.claude/scripts/external-agent.sh:*), Bash(.claude/scripts/external-agent.sh:*)
---

# OpenCode Agent

Code generation, refactoring, testing, and documentation with multiple providers.

## Usage

```
/opencode:<model>:<reasoning> <task>
```

## Models (10 available)

### Anthropic Claude
| Model | Description | Speed | Cost |
|-------|-------------|-------|------|
| `opus-4.5` | Most capable, premium | Moderate | $$$ |
| `sonnet-4.5` | Best balance (default) | Fast | $$ |
| `haiku-4.5` | Fastest Claude | Fastest | $ |
| `opus-4.1` | Legacy capable | Moderate | $$$ |
| `sonnet-4` | Legacy balance | Fast | $$ |

### OpenAI
| Model | Description | Reasoning | Cost |
|-------|-------------|-----------|------|
| `gpt-5.2` | Latest OpenAI | none-high | $$ |
| `gpt-4.1` | Smartest non-reasoning | - | $$ |

### Google (FREE)
| Model | Description | Speed | Cost |
|-------|-------------|-------|------|
| `gemini-3-pro` | Latest reasoning | Medium | FREE |
| `gemini-2.5-pro` | Stable | Medium | FREE |
| `gemini-2.5-flash` | Fast | Fast | FREE |

## Reasoning Levels (for supported models)

Claude models support extended thinking:
- `standard` - Normal response (default)
- `extended` - Extended thinking enabled

OpenAI models (gpt-5.x):
- `none`, `minimal`, `low`, `medium`, `high`

## Parse Arguments

Format: `:<model>:<reasoning> <task>` or `:<model> <task>`

Examples:
- `/opencode:opus-4.5:extended Complex system` → model=opus-4.5, reasoning=extended
- `/opencode:gpt-5.2:high Generate API` → model=gpt-5.2, reasoning=high
- `/opencode:haiku-4.5 Quick function` → model=haiku-4.5, reasoning=standard

## Examples

```bash
# Most capable Claude with extended thinking
/opencode:opus-4.5:extended Implement complex real-time WebSocket system

# Best balance for most tasks
/opencode:sonnet-4.5 Generate REST API with JWT authentication

# Fast utility function
/opencode:haiku-4.5 Write TypeScript debounce function

# OpenAI with reasoning
/opencode:gpt-5.2:high Generate comprehensive test suite

# FREE code generation
/opencode:gemini-3-pro Create React component library

# Budget-friendly stable option
/opencode:gemini-2.5-flash Generate TypeScript interfaces
```

## Cost Guide

| Model | Speed | Cost |
|-------|-------|------|
| `opus-4.5` | Moderate | $$$ |
| `sonnet-4.5` | Fast | $$ |
| `haiku-4.5` | Fastest | $ |
| `gpt-5.2` | Medium | $$ |
| `gpt-4.1` | Medium | $$ |
| `gemini-*` | Varies | **FREE** |

## Execution

```bash
~/.claude/scripts/external-agent.sh \
  --agent opencode \
  --model "<model>" \
  --reasoning "<reasoning>" \
  --type generation \
  --task "<task>"
```
