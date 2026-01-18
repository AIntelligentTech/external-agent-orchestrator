---
description: Codex agent for architecture, planning, and reasoning tasks (OpenAI GPT-5.2)
argument-hint: :<reasoning> <task>
allowed-tools: Bash(~/.claude/scripts/external-agent.sh:*), Bash(.claude/scripts/external-agent.sh:*)
---

# Codex Agent

Architecture, planning, security, and performance tasks with GPT-5.2 reasoning.

## Usage

```
/codex:<reasoning> <task>
```

## Parse Arguments

The first argument may start with `:` followed by the reasoning level:
- `:xhigh` → Extended reasoning (slowest, most thorough)
- `:high` → High reasoning (thorough)
- `:medium` → Medium reasoning (balanced, default)
- `:low` → Low reasoning (fast)

If no colon prefix, use `medium` as default.

**Examples:**
- `/codex:xhigh Design microservices` → reasoning=xhigh, task="Design microservices"
- `/codex Design an API` → reasoning=medium, task="Design an API"

## Execution

```bash
~/.claude/scripts/external-agent.sh \
  --agent codex \
  --model "gpt-5.2-codex:<reasoning>" \
  --type architecture \
  --task "<task>"
```

## Examples

```bash
/codex:xhigh Design microservices for 10M concurrent users
/codex:high Review this authentication system for vulnerabilities
/codex:medium Plan the migration from monolith to microservices
/codex:low Quick review of this API structure
/codex Design a caching strategy for the application
```

## Cost

| Reasoning | Speed | Cost |
|-----------|-------|------|
| xhigh | Slowest | $$$$ |
| high | Slow | $$$ |
| medium | Medium | $$ |
| low | Fast | $ |
