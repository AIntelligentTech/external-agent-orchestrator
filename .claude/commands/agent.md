---
description: Dispatch tasks to external AI agents (Codex, Gemini, OpenCode) with model selection
argument-hint: :<agent>:<model> <task>
allowed-tools: Bash(~/.claude/scripts/external-agent.sh:*), Bash(.claude/scripts/external-agent.sh:*)
---

# External Agent Dispatcher

Dispatch tasks to external AI agents with model selection.

## Usage

```
/agent:<agent>:<model> <task>
```

Or with space separation:
```
/agent <agent>:<model> <task>
```

## Parse $ARGUMENTS

Arguments may start with `:` (from `/agent:codex:xhigh` syntax) or not (from `/agent codex:xhigh` syntax).

**Step 1**: Strip leading `:` if present
**Step 2**: Split first word by `:` to get agent and model
**Step 3**: Remaining words are the task

Examples:
- `:codex:xhigh Design API` → agent=codex, model=xhigh, task="Design API"
- `codex:xhigh Design API` → agent=codex, model=xhigh, task="Design API"
- `:gemini:flash Sketch UI` → agent=gemini, model=flash, task="Sketch UI"

## Model Mappings

### Codex (OpenAI GPT-5.2)
| Input | Model | Reasoning |
|-------|-------|-----------|
| `codex:xhigh` | gpt-5.2-codex | xhigh |
| `codex:high` | gpt-5.2-codex | high |
| `codex:medium` | gpt-5.2-codex | medium |
| `codex:low` | gpt-5.2-codex | low |
| `codex` | gpt-5.2-codex | medium |

### Gemini (Google, FREE)
| Input | Model |
|-------|-------|
| `gemini:pro` | gemini-2.5-pro |
| `gemini:flash` | gemini-2.5-flash |
| `gemini` | gemini-2.5-pro |

### OpenCode (Multi-provider)
| Input | Model |
|-------|-------|
| `opencode:opus` | claude-opus-4-5 |
| `opencode:sonnet` | claude-sonnet |
| `opencode:haiku` | claude-haiku |
| `opencode:gpt4` | gpt-4 |
| `opencode:gemini` | gemini |
| `opencode` | claude-sonnet |

## Execution

Run the orchestrator script:

```bash
~/.claude/scripts/external-agent.sh --agent <agent> --model <model> --type <type> --task "<task>"
```

If user-level script not found, try project-level:
```bash
.claude/scripts/external-agent.sh --agent <agent> --model <model> --type <type> --task "<task>"
```

## Examples

```bash
# Full colon syntax
/agent:codex:xhigh Design a scalable microservices architecture
/agent:codex:low Quick security review of auth flow
/agent:gemini:flash Sketch a mobile login screen
/agent:opencode:haiku Write a debounce utility function

# Space-separated (also works)
/agent codex:xhigh Design a scalable microservices architecture
/agent gemini:pro Create a dark mode design system
```
