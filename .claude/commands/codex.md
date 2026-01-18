---
description: Codex agent for architecture, planning, and reasoning tasks (OpenAI GPT-5.2)
argument-hint: [:<reasoning>] <task>
allowed-tools: Bash(~/.claude/scripts/external-agent.sh:*), Bash(.claude/scripts/external-agent.sh:*)
---

# Codex Agent Shortcut

Invoke the Codex agent for architecture, planning, security, and performance tasks.

## Command Format

```
/codex[:<reasoning>] <task>
```

## Reasoning Levels

| Level | Description | Speed | Cost |
|-------|-------------|-------|------|
| `xhigh` | Extended reasoning, most thorough | Slow | $$$$ |
| `high` | High reasoning, thorough analysis | Slow | $$$ |
| `medium` | Medium reasoning, balanced (default) | Medium | $$ |
| `low` | Low reasoning, fast responses | Fast | $ |

## Parse Command

- `/codex <task>` → model=`gpt-5.2-codex:medium`
- `/codex:xhigh <task>` → model=`gpt-5.2-codex:xhigh`
- `/codex:high <task>` → model=`gpt-5.2-codex:high`
- `/codex:medium <task>` → model=`gpt-5.2-codex:medium`
- `/codex:low <task>` → model=`gpt-5.2-codex:low`

## Examples

```bash
/codex Design a real-time collaboration system
/codex:xhigh Design microservices for 10M users
/codex:high Review authentication system for vulnerabilities
/codex:low Quick review of this API structure
```

## Execution

Delegate to `/agent codex:<reasoning> <task> --type architecture`
