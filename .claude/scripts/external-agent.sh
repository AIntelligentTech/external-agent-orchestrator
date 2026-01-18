#!/usr/bin/env bash
#
# External Agent Orchestrator
# Executes tasks via external AI coding CLIs (OpenCode, Gemini, Codex)
#
# Usage: external-agent.sh --agent <agent> --model <model> --type <type> --task <task>
#
# Agents:
#   codex    - OpenAI GPT-5.2 with reasoning (architecture, planning, security)
#   gemini   - Google Gemini (design, visual, FREE)
#   opencode - Multi-provider code generation (Claude, GPT-4, Gemini)
#
# Environment:
#   OPENAI_API_KEY    - Required for codex, opencode:gpt4
#   GOOGLE_API_KEY    - Required for gemini, opencode:gemini (FREE)
#   ANTHROPIC_API_KEY - Required for opencode:opus/sonnet/haiku

set -euo pipefail

# Colors for stderr output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Defaults
AGENT=""
MODEL=""
TYPE=""
TASK=""
REASONING=""

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --agent) AGENT="$2"; shift 2 ;;
    --model) MODEL="$2"; shift 2 ;;
    --type) TYPE="$2"; shift 2 ;;
    --task) TASK="$2"; shift 2 ;;
    --reasoning) REASONING="$2"; shift 2 ;;
    --help|-h)
      cat <<EOF
External Agent Orchestrator

Usage: $(basename "$0") --agent <agent> --model <model> --type <type> --task <task>

Agents:
  codex      OpenAI GPT-5.2 with reasoning levels
  gemini     Google Gemini (FREE)
  opencode   Multi-provider code generation

Models by Agent:
  codex:     xhigh, high, medium, low, gpt-5, gpt-4
  gemini:    pro, flash (both FREE)
  opencode:  opus, sonnet, haiku, gpt4, gemini

Types:
  codex:     architecture, planning, security, performance
  gemini:    design, visual, mockup
  opencode:  generation, refactor, testing, documentation

Examples:
  $(basename "$0") --agent codex --model gpt-5.2-codex:xhigh --type architecture --task "Design microservices"
  $(basename "$0") --agent gemini --model gemini-2.5-flash --type design --task "Create dark mode"
  $(basename "$0") --agent opencode --model claude-haiku --type generation --task "Write utility"
EOF
      exit 0
      ;;
    *) shift ;;
  esac
done

# Validate required params
if [[ -z "$AGENT" || -z "$TASK" ]]; then
  echo -e "${RED}ERROR: Missing required arguments${NC}" >&2
  echo "Usage: $(basename "$0") --agent <agent> --task <task> [--model <model>] [--type <type>]" >&2
  exit 1
fi

# Get system prompt by task type
get_system_prompt() {
  local type="$1"
  case "$type" in
    architecture)
      echo "You are an expert software architect with deep experience in distributed systems, microservices, and scalable architecture. Design comprehensive, maintainable systems with clear justifications for every decision."
      ;;
    planning)
      echo "You are an expert technical planner and project lead. Create detailed, actionable implementation plans with clear milestones, dependencies, and success criteria."
      ;;
    security)
      echo "You are a senior security architect and penetration testing expert. Identify vulnerabilities, design secure solutions, and follow security best practices (OWASP, etc.)."
      ;;
    performance)
      echo "You are a performance engineering expert. Optimize systems for speed, efficiency, and scalability. Provide measurable improvements and benchmarking strategies."
      ;;
    design)
      echo "You are a world-class UI/UX designer. Create beautiful, accessible, user-centered designs with detailed specifications for implementation."
      ;;
    visual)
      echo "You are an expert visual analyst. Analyze designs for usability, accessibility, and visual hierarchy. Provide actionable feedback."
      ;;
    mockup)
      echo "You are an expert mockup designer. Create detailed wireframes and mockups with responsive layouts and interaction specifications."
      ;;
    generation)
      echo "You are an expert software engineer. Write clean, production-ready, well-documented code following best practices."
      ;;
    refactor)
      echo "You are a code refactoring specialist. Improve code quality, maintainability, and performance while preserving functionality."
      ;;
    testing)
      echo "You are an expert test engineer. Write comprehensive tests with good coverage, clear assertions, and maintainable structure."
      ;;
    documentation)
      echo "You are a technical writer. Create clear, comprehensive documentation that developers can easily follow."
      ;;
    *)
      echo "You are an expert AI assistant. Complete the task thoroughly and professionally."
      ;;
  esac
}

# Escape JSON string
json_escape() {
  printf '%s' "$1" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))'
}

# Execute OpenCode agent (multi-provider)
execute_opencode() {
  local model="$1"
  local task="$2"
  local type="$3"

  # Map model shorthand to full provider/model
  local full_model provider model_name
  case "$model" in
    claude-opus-4-5|opus) full_model="anthropic/claude-opus-4-5-20251101"; provider="anthropic"; model_name="claude-opus-4-5-20251101" ;;
    claude-sonnet|sonnet) full_model="anthropic/claude-sonnet-4-20250514"; provider="anthropic"; model_name="claude-sonnet-4-20250514" ;;
    claude-haiku|haiku) full_model="anthropic/claude-3-5-haiku-20241022"; provider="anthropic"; model_name="claude-3-5-haiku-20241022" ;;
    gpt-4) full_model="openai/gpt-4"; provider="openai"; model_name="gpt-4" ;;
    gpt-4-turbo) full_model="openai/gpt-4-turbo"; provider="openai"; model_name="gpt-4-turbo" ;;
    gemini) full_model="google/gemini-2.5-pro"; provider="google"; model_name="gemini-2.5-pro" ;;
    *)
      if [[ "$model" == *"/"* ]]; then
        full_model="$model"
        provider="${model%%/*}"
        model_name="${model##*/}"
      else
        full_model="anthropic/$model"
        provider="anthropic"
        model_name="$model"
      fi
      ;;
  esac

  local system_prompt
  system_prompt=$(get_system_prompt "$type")
  local escaped_task escaped_system
  escaped_task=$(json_escape "$task")
  escaped_system=$(json_escape "$system_prompt")

  echo -e "${BLUE}[OpenCode]${NC} Model: $full_model | Type: $type" >&2

  case "$provider" in
    anthropic)
      if [[ -z "${ANTHROPIC_API_KEY:-}" ]]; then
        echo -e "${RED}ERROR: ANTHROPIC_API_KEY not set${NC}" >&2
        echo "Get a key at: https://console.anthropic.com/" >&2
        exit 1
      fi
      curl -s https://api.anthropic.com/v1/messages \
        -H "x-api-key: $ANTHROPIC_API_KEY" \
        -H "anthropic-version: 2023-06-01" \
        -H "content-type: application/json" \
        -d "{
          \"model\": \"$model_name\",
          \"max_tokens\": 8000,
          \"system\": $escaped_system,
          \"messages\": [{\"role\": \"user\", \"content\": $escaped_task}]
        }" | jq -r '.content[0].text // .error.message // "Unknown error"'
      ;;
    openai)
      if [[ -z "${OPENAI_API_KEY:-}" ]]; then
        echo -e "${RED}ERROR: OPENAI_API_KEY not set${NC}" >&2
        echo "Get a key at: https://platform.openai.com/api-keys" >&2
        exit 1
      fi
      curl -s https://api.openai.com/v1/chat/completions \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -d "{
          \"model\": \"$model_name\",
          \"messages\": [
            {\"role\": \"system\", \"content\": $escaped_system},
            {\"role\": \"user\", \"content\": $escaped_task}
          ],
          \"max_tokens\": 8000
        }" | jq -r '.choices[0].message.content // .error.message // "Unknown error"'
      ;;
    google)
      if [[ -z "${GOOGLE_API_KEY:-}" ]]; then
        echo -e "${RED}ERROR: GOOGLE_API_KEY not set${NC}" >&2
        echo "Get a FREE key at: https://ai.google.dev/tutorials/setup" >&2
        exit 1
      fi
      curl -s "https://generativelanguage.googleapis.com/v1beta/models/$model_name:generateContent" \
        -H "Content-Type: application/json" \
        -H "x-goog-api-key: $GOOGLE_API_KEY" \
        -d "{
          \"system_instruction\": {\"parts\": {\"text\": $escaped_system}},
          \"contents\": {\"parts\": {\"text\": $escaped_task}},
          \"generationConfig\": {\"maxOutputTokens\": 8000}
        }" | jq -r '.candidates[0].content.parts[0].text // .error.message // "Unknown error"'
      ;;
    *)
      echo -e "${RED}ERROR: Unknown provider '$provider'${NC}" >&2
      exit 1
      ;;
  esac
}

# Execute Gemini agent (Google, FREE)
execute_gemini() {
  local model="$1"
  local task="$2"
  local type="$3"

  # Default model
  [[ -z "$model" || "$model" == "pro" ]] && model="gemini-2.5-pro"
  [[ "$model" == "flash" ]] && model="gemini-2.5-flash"

  local system_prompt
  system_prompt=$(get_system_prompt "$type")
  local escaped_task escaped_system
  escaped_task=$(json_escape "$task")
  escaped_system=$(json_escape "$system_prompt")

  echo -e "${BLUE}[Gemini]${NC} Model: $model | Type: $type (FREE)" >&2

  if [[ -z "${GOOGLE_API_KEY:-}" ]]; then
    echo -e "${RED}ERROR: GOOGLE_API_KEY not set${NC}" >&2
    echo "Get a FREE key at: https://ai.google.dev/tutorials/setup" >&2
    exit 1
  fi

  curl -s "https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent" \
    -H "Content-Type: application/json" \
    -H "x-goog-api-key: $GOOGLE_API_KEY" \
    -d "{
      \"system_instruction\": {\"parts\": {\"text\": $escaped_system}},
      \"contents\": {\"parts\": {\"text\": $escaped_task}},
      \"generationConfig\": {\"maxOutputTokens\": 8000, \"temperature\": 0.7}
    }" | jq -r '.candidates[0].content.parts[0].text // .error.message // "Unknown error"'
}

# Execute Codex agent (OpenAI with reasoning effort)
execute_codex() {
  local model="$1"
  local task="$2"
  local type="$3"
  local reasoning="${4:-medium}"

  # Parse model and reasoning level
  local base_model="$model"
  local reasoning_effort="$reasoning"

  # Handle model:reasoning format (e.g., gpt-5.2-codex:xhigh)
  if [[ "$model" == *":"* ]]; then
    base_model="${model%%:*}"
    reasoning_effort="${model##*:}"
  fi

  # Map reasoning levels to API values
  local api_reasoning
  case "$reasoning_effort" in
    xhigh|extended) api_reasoning="high" ;;  # API max is high; xhigh extends tokens
    high) api_reasoning="high" ;;
    medium) api_reasoning="medium" ;;
    low) api_reasoning="low" ;;
    *) api_reasoning="medium" ;;
  esac

  # Set max tokens based on reasoning level
  local max_tokens
  case "$reasoning_effort" in
    xhigh|extended) max_tokens=32000 ;;
    high) max_tokens=16000 ;;
    medium) max_tokens=8000 ;;
    low) max_tokens=4000 ;;
    *) max_tokens=8000 ;;
  esac

  # Map model shorthand
  local api_model
  case "$base_model" in
    gpt-5.2-codex|gpt-5.2) api_model="gpt-5.2-codex" ;;
    gpt-5-codex|gpt-5) api_model="gpt-5-codex" ;;
    gpt-4-turbo) api_model="gpt-4-turbo" ;;
    gpt-4) api_model="gpt-4" ;;
    *) api_model="$base_model" ;;
  esac

  local system_prompt
  system_prompt=$(get_system_prompt "$type")
  local escaped_task escaped_system
  escaped_task=$(json_escape "$task")
  escaped_system=$(json_escape "$system_prompt")

  echo -e "${BLUE}[Codex]${NC} Model: $api_model | Reasoning: $reasoning_effort | Type: $type" >&2

  if [[ -z "${OPENAI_API_KEY:-}" ]]; then
    echo -e "${RED}ERROR: OPENAI_API_KEY not set${NC}" >&2
    echo "Get a key at: https://platform.openai.com/api-keys" >&2
    exit 1
  fi

  # Build request - use reasoning_effort for o1/o3/5.2 style models
  local request_body
  if [[ "$api_model" == *"5.2"* || "$api_model" == *"o1"* || "$api_model" == *"o3"* ]]; then
    request_body="{
      \"model\": \"$api_model\",
      \"reasoning_effort\": \"$api_reasoning\",
      \"messages\": [
        {\"role\": \"system\", \"content\": $escaped_system},
        {\"role\": \"user\", \"content\": $escaped_task}
      ],
      \"max_completion_tokens\": $max_tokens
    }"
  else
    request_body="{
      \"model\": \"$api_model\",
      \"messages\": [
        {\"role\": \"system\", \"content\": $escaped_system},
        {\"role\": \"user\", \"content\": $escaped_task}
      ],
      \"max_tokens\": $max_tokens
    }"
  fi

  curl -s https://api.openai.com/v1/chat/completions \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    -d "$request_body" | jq -r '.choices[0].message.content // .error.message // "Unknown error"'
}

# Main execution
case "$AGENT" in
  opencode)
    [[ -z "$MODEL" ]] && MODEL="claude-sonnet"
    [[ -z "$TYPE" ]] && TYPE="generation"
    execute_opencode "$MODEL" "$TASK" "$TYPE"
    ;;
  gemini)
    [[ -z "$MODEL" ]] && MODEL="gemini-2.5-pro"
    [[ -z "$TYPE" ]] && TYPE="design"
    execute_gemini "$MODEL" "$TASK" "$TYPE"
    ;;
  codex)
    [[ -z "$MODEL" ]] && MODEL="gpt-5.2-codex:medium"
    [[ -z "$TYPE" ]] && TYPE="architecture"
    execute_codex "$MODEL" "$TASK" "$TYPE" "$REASONING"
    ;;
  *)
    echo -e "${RED}ERROR: Unknown agent '$AGENT'${NC}" >&2
    echo "Valid agents: opencode, gemini, codex" >&2
    exit 1
    ;;
esac
