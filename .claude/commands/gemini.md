---
description: Gemini agent for visual design and UI/UX tasks (Google, FREE)
argument-hint: [:<model>] <task>
allowed-tools: Bash(~/.claude/scripts/external-agent.sh:*), Bash(.claude/scripts/external-agent.sh:*)
---

# Gemini Agent Shortcut

Invoke the Gemini agent for design and visual tasks. **FREE to use.**

## Command Format

```
/gemini[:<model>] <task>
```

## Models

| Model | Description | Speed |
|-------|-------------|-------|
| `pro` | Gemini 2.5 Pro, most capable (default) | Medium |
| `flash` | Gemini 2.5 Flash, fast sketches | Fast |

## Parse Command

- `/gemini <task>` → model=`gemini-2.5-pro`
- `/gemini:pro <task>` → model=`gemini-2.5-pro`
- `/gemini:flash <task>` → model=`gemini-2.5-flash`

## Examples

```bash
/gemini Create a comprehensive dark mode design system
/gemini:pro Design a component library with accessibility
/gemini:flash Quick sketch of settings page layout
```

## Cost

**FREE** - Gemini has generous free tier:
- 60 requests per minute
- 1,000 requests per day

## Execution

Delegate to `/agent gemini:<model> <task> --type design`
