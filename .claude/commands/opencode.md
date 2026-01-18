---
description: OpenCode agent for code generation, refactoring, and testing (multi-provider)
argument-hint: [:<model>] <task>
allowed-tools: Bash(~/.claude/scripts/external-agent.sh:*), Bash(.claude/scripts/external-agent.sh:*)
---

# OpenCode Agent Shortcut

Invoke the OpenCode agent for code generation, refactoring, testing, and documentation.

## Command Format

```
/opencode[:<model>] <task>
```

## Models

| Model | Provider | Description | Speed | Cost |
|-------|----------|-------------|-------|------|
| `opus` | Anthropic | Claude Opus 4.5, most capable | Slow | $$$ |
| `sonnet` | Anthropic | Claude Sonnet, balanced (default) | Medium | $$ |
| `haiku` | Anthropic | Claude Haiku, fast | Fast | $ |
| `gpt4` | OpenAI | GPT-4 | Medium | $$ |
| `gemini` | Google | Gemini 2.5 Pro | Medium | FREE |

## Parse Command

- `/opencode <task>` → model=`claude-sonnet`
- `/opencode:opus <task>` → model=`claude-opus-4-5`
- `/opencode:sonnet <task>` → model=`claude-sonnet`
- `/opencode:haiku <task>` → model=`claude-haiku`
- `/opencode:gpt4 <task>` → model=`gpt-4`
- `/opencode:gemini <task>` → model=`gemini`

## Examples

```bash
/opencode Generate a REST API with JWT authentication
/opencode:opus Implement complex real-time system with WebSockets
/opencode:haiku Write a debounce utility function
/opencode:gemini Generate TypeScript interfaces for user management
```

## Execution

Delegate to `/agent opencode:<model> <task> --type generation`
