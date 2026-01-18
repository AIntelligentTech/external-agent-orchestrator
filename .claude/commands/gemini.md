---
description: Gemini agent for visual design and UI/UX tasks (Google, FREE)
argument-hint: :<model> <task>
allowed-tools: Bash(~/.claude/scripts/external-agent.sh:*), Bash(.claude/scripts/external-agent.sh:*)
---

# Gemini Agent

Visual design, UI/UX, and component library tasks. **FREE to use.**

## Usage

```
/gemini:<model> <task>
```

## Models (7 available)

| Model | Description | Speed | Cost |
|-------|-------------|-------|------|
| `gemini-3-pro` | Latest reasoning-first, agentic | Medium | FREE |
| `gemini-3-flash` | Latest fast model (default) | Fast | FREE |
| `gemini-2.5-pro` | Stable, advanced reasoning | Medium | FREE |
| `gemini-2.5-flash` | Stable, multimodal, 1M context | Fast | FREE |
| `gemini-2.5-flash-lite` | Cost-optimized | Fastest | FREE |
| `gemini-2.0-flash` | Previous generation | Fast | FREE |
| `gemini-2.0-flash-lite` | Budget option | Fastest | FREE |

## Parse Arguments

Format: `:<model> <task>`

Examples:
- `/gemini:gemini-3-pro Create design system` → model=gemini-3-pro
- `/gemini:gemini-2.5-flash Sketch UI` → model=gemini-2.5-flash

**Shortcuts** (for convenience):
- `3-pro` → `gemini-3-pro`
- `3-flash` → `gemini-3-flash`
- `2.5-pro` → `gemini-2.5-pro`
- `2.5-flash` → `gemini-2.5-flash`
- `flash` → `gemini-3-flash`
- `pro` → `gemini-3-pro`

## Examples

```bash
# Latest reasoning model for complex design
/gemini:gemini-3-pro Create a comprehensive design system with tokens and components

# Fast sketching with latest model
/gemini:gemini-3-flash Quick sketch of mobile onboarding flow

# Stable model for production
/gemini:gemini-2.5-pro Design accessible component library

# Ultra-fast budget option
/gemini:gemini-2.5-flash-lite Simple wireframe for settings page

# Using shortcuts
/gemini:3-pro Create dark mode design system
/gemini:flash Quick UI sketch
```

## Cost

**ALL FREE** - Gemini has generous free tier:
- 60 requests per minute
- 1,000 requests per day

## Execution

```bash
~/.claude/scripts/external-agent.sh \
  --agent gemini \
  --model "<model>" \
  --type design \
  --task "<task>"
```
