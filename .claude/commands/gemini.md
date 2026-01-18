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

## Parse Arguments

The first argument may start with `:` followed by the model:
- `:pro` → Gemini 2.5 Pro (most capable, default)
- `:flash` → Gemini 2.5 Flash (fast)

If no colon prefix, use `pro` as default.

**Examples:**
- `/gemini:flash Sketch login screen` → model=gemini-2.5-flash
- `/gemini Create design system` → model=gemini-2.5-pro

## Execution

```bash
~/.claude/scripts/external-agent.sh \
  --agent gemini \
  --model "<model>" \
  --type design \
  --task "<task>"
```

## Examples

```bash
/gemini:pro Create a comprehensive dark mode design system with tokens
/gemini:flash Quick sketch of mobile onboarding flow
/gemini Design a component library with accessibility guidelines
```

## Cost

**FREE** - Gemini has generous free tier:
- 60 requests per minute
- 1,000 requests per day

| Model | Speed | Cost |
|-------|-------|------|
| pro | Medium | FREE |
| flash | Fast | FREE |
