---
description: OpenCode agent for code generation, refactoring, and testing (multi-provider)
argument-hint: :<model> <task>
allowed-tools: Bash(~/.claude/scripts/external-agent.sh:*), Bash(.claude/scripts/external-agent.sh:*)
---

# OpenCode Agent

Code generation, refactoring, testing, and documentation with multiple providers.

## Usage

```
/opencode:<model> <task>
```

## Parse Arguments

The first argument may start with `:` followed by the model:
- `:opus` → Claude Opus 4.5 (most capable)
- `:sonnet` → Claude Sonnet (balanced, default)
- `:haiku` → Claude Haiku (fast, cheap)
- `:gpt4` → GPT-4
- `:gemini` → Gemini 2.5 Pro (FREE)

If no colon prefix, use `sonnet` as default.

**Examples:**
- `/opencode:haiku Write debounce` → model=claude-haiku
- `/opencode Generate REST API` → model=claude-sonnet

## Execution

```bash
~/.claude/scripts/external-agent.sh \
  --agent opencode \
  --model "<model>" \
  --type generation \
  --task "<task>"
```

## Examples

```bash
/opencode:opus Implement a complex real-time collaboration system
/opencode:sonnet Generate a REST API with JWT authentication
/opencode:haiku Write a debounce utility function with TypeScript types
/opencode:gpt4 Create a React hook for form validation
/opencode:gemini Generate TypeScript interfaces for user management
/opencode Refactor this function for better performance
```

## Cost

| Model | Provider | Speed | Cost |
|-------|----------|-------|------|
| opus | Anthropic | Slow | $$$ |
| sonnet | Anthropic | Medium | $$ |
| haiku | Anthropic | Fast | $ |
| gpt4 | OpenAI | Medium | $$ |
| gemini | Google | Medium | FREE |
