---
description: Codex agent for architecture, planning, and reasoning tasks (OpenAI)
argument-hint: :<model>:<reasoning> <task>
allowed-tools: Bash(~/.claude/scripts/external-agent.sh:*), Bash(.claude/scripts/external-agent.sh:*)
---

# Codex Agent

Architecture, planning, security, and performance tasks using OpenAI models with reasoning.

## Usage

```
/codex:<model>:<reasoning> <task>
```

## Models (10 available)

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

## Reasoning Levels

| Level | Description | Use Case |
|-------|-------------|----------|
| `none` | No reasoning (GPT-5.x only) | Fast responses |
| `minimal` | Minimal thinking | Quick reviews |
| `low` | Light reasoning | Simple analysis |
| `medium` | Balanced (default) | Standard tasks |
| `high` | Deep reasoning | Complex architecture |

## Parse Arguments

Format: `:<model>:<reasoning> <task>` or `:<model> <task>` (uses default reasoning)

Examples:
- `/codex:gpt-5.2:high Design microservices` → model=gpt-5.2, reasoning=high
- `/codex:o3:medium Plan migration` → model=o3, reasoning=medium
- `/codex:gpt-4.1 Quick review` → model=gpt-4.1, reasoning=none

## Examples

```bash
# Deep architecture analysis
/codex:gpt-5.2:high Design a real-time collaboration system for 10M users

# Extended thinking for critical decisions
/codex:o3-pro:high Review security architecture for vulnerabilities

# Fast planning
/codex:gpt-5-mini:low Quick review of this API structure

# Non-reasoning model
/codex:gpt-4.1 Summarize this codebase architecture
```

## Execution

```bash
~/.claude/scripts/external-agent.sh \
  --agent codex \
  --model "<model>" \
  --reasoning "<reasoning>" \
  --type architecture \
  --task "<task>"
```
