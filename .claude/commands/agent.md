---
description: Dispatch tasks to external AI agents (Codex, Gemini, OpenCode) with model selection
argument-hint: <agent>:<model> <task> [--type TYPE]
allowed-tools: Bash(~/.claude/scripts/external-agent.sh:*), Bash(.claude/scripts/external-agent.sh:*)
---

# External Agent Dispatcher

Parse the command and delegate to the external-agent subagent.

## Command Format

```
/agent <agent>[:<model>] <task> [--type TYPE]
```

## Parse Arguments

Extract from `$ARGUMENTS`:
1. **Agent and Model**: First word, split by `:` (e.g., `codex:xhigh` → agent=codex, model=xhigh)
2. **Task**: Everything after the first word, excluding `--type` flag
3. **Type** (optional): Value after `--type` flag

## Agent Defaults

| Agent | Default Model | Default Type |
|-------|---------------|--------------|
| codex | gpt-5.2-codex:medium | architecture |
| gemini | gemini-2.5-pro | design |
| opencode | claude-sonnet | generation |

## Model Mappings

### Codex
- `xhigh` → `gpt-5.2-codex:xhigh`
- `high` → `gpt-5.2-codex:high`
- `medium` → `gpt-5.2-codex:medium`
- `low` → `gpt-5.2-codex:low`
- `gpt-5` → `gpt-5-codex`
- `gpt-4` → `gpt-4`

### Gemini
- `pro` → `gemini-2.5-pro`
- `flash` → `gemini-2.5-flash`

### OpenCode
- `opus` → `claude-opus-4-5`
- `sonnet` → `claude-sonnet`
- `haiku` → `claude-haiku`
- `gpt4` → `gpt-4`
- `gemini` → `gemini`

## Examples

```bash
# Architecture with extended reasoning
/agent codex:xhigh Design a real-time collaboration system --type architecture

# Quick security review
/agent codex:low Review auth flow --type security

# UI design (FREE)
/agent gemini Create dark mode design system

# Fast UI sketch (FREE)
/agent gemini:flash Sketch mobile onboarding

# Code generation
/agent opencode Generate REST API with JWT

# Fast utility (cheap)
/agent opencode:haiku Write debounce function
```

## Execution

Use the external-agent subagent to orchestrate:

```
AGENT: <parsed-agent>
MODEL: <parsed-model>
TYPE: <parsed-type>
TASK: <parsed-task>
```
