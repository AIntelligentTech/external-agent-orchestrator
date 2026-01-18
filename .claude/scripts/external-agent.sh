#!/usr/bin/env bash
#
# External Agent Orchestrator
# Executes tasks via external AI coding agents (Codex, Gemini, OpenCode)
#
# Usage: external-agent.sh --agent <agent> --model <model> --reasoning <level> --type <type> --task <task>
#
# Agents:
#   codex    - OpenAI models with reasoning (architecture, planning, security)
#   gemini   - Google Gemini models (design, visual, FREE)
#   opencode - Multi-provider code generation (Claude, OpenAI, Gemini)
#
# Environment:
#   OPENAI_API_KEY    - Required for codex, opencode with OpenAI models
#   GOOGLE_API_KEY    - Required for gemini, opencode with Gemini models (FREE)
#   ANTHROPIC_API_KEY - Required for opencode with Claude models

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

Usage: $(basename "$0") --agent <agent> --model <model> --reasoning <level> --type <type> --task <task>

Agents:
  codex      OpenAI models with reasoning levels
  gemini     Google Gemini models (FREE)
  opencode   Multi-provider code generation

Codex Models (OpenAI):
  gpt-5.2, gpt-5.1, gpt-5, gpt-5-mini    (with reasoning: none/minimal/low/medium/high)
  o3, o3-pro, o4-mini                     (with reasoning: low/medium/high)
  gpt-4.1, gpt-4.1-mini, gpt-4           (no reasoning)

Gemini Models (Google, FREE):
  gemini-3-pro, gemini-3-flash
  gemini-2.5-pro, gemini-2.5-flash, gemini-2.5-flash-lite
  gemini-2.0-flash, gemini-2.0-flash-lite

OpenCode Models:
  Claude: opus-4.5, sonnet-4.5, haiku-4.5, opus-4.1, sonnet-4
  OpenAI: gpt-5.2, gpt-4.1
  Google: gemini-3-pro, gemini-2.5-pro, gemini-2.5-flash (FREE)

Reasoning Levels:
  OpenAI: none, minimal, low, medium (default), high
  Claude: standard (default), extended

Examples:
  $(basename "$0") --agent codex --model gpt-5.2 --reasoning high --type architecture --task "Design microservices"
  $(basename "$0") --agent gemini --model gemini-3-flash --type design --task "Create dark mode"
  $(basename "$0") --agent opencode --model haiku-4.5 --type generation --task "Write utility"
EOF
      exit 0
      ;;
    *) shift ;;
  esac
done

# Validate required params
if [[ -z "$AGENT" || -z "$TASK" ]]; then
  echo -e "${RED}ERROR: Missing required arguments${NC}" >&2
  echo "Usage: $(basename "$0") --agent <agent> --task <task> [--model <model>] [--reasoning <level>] [--type <type>]" >&2
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

# Map model shortcuts to full API model IDs
map_openai_model() {
  local model="$1"
  case "$model" in
    gpt-5.2) echo "gpt-5.2" ;;
    gpt-5.1) echo "gpt-5.1" ;;
    gpt-5) echo "gpt-5" ;;
    gpt-5-mini) echo "gpt-5-mini" ;;
    o3) echo "o3" ;;
    o3-pro) echo "o3-pro" ;;
    o4-mini) echo "o4-mini" ;;
    gpt-4.1) echo "gpt-4.1" ;;
    gpt-4.1-mini) echo "gpt-4.1-mini" ;;
    gpt-4) echo "gpt-4" ;;
    *) echo "$model" ;;
  esac
}

map_gemini_model() {
  local model="$1"
  case "$model" in
    # Shortcuts
    3-pro|pro) echo "gemini-3-pro-preview" ;;
    3-flash|flash) echo "gemini-3-flash-preview" ;;
    2.5-pro) echo "gemini-2.5-pro" ;;
    2.5-flash) echo "gemini-2.5-flash" ;;
    2.5-flash-lite) echo "gemini-2.5-flash-lite" ;;
    # Full names
    gemini-3-pro) echo "gemini-3-pro-preview" ;;
    gemini-3-flash) echo "gemini-3-flash-preview" ;;
    gemini-2.5-pro) echo "gemini-2.5-pro" ;;
    gemini-2.5-flash) echo "gemini-2.5-flash" ;;
    gemini-2.5-flash-lite) echo "gemini-2.5-flash-lite" ;;
    gemini-2.0-flash) echo "gemini-2.0-flash" ;;
    gemini-2.0-flash-lite) echo "gemini-2.0-flash-lite" ;;
    *) echo "$model" ;;
  esac
}

map_claude_model() {
  local model="$1"
  case "$model" in
    opus-4.5|opus) echo "claude-opus-4-5-20251101" ;;
    sonnet-4.5|sonnet) echo "claude-sonnet-4-5-20250929" ;;
    haiku-4.5|haiku) echo "claude-haiku-4-5-20251001" ;;
    opus-4.1) echo "claude-opus-4-1-20250805" ;;
    sonnet-4) echo "claude-sonnet-4-20250514" ;;
    opus-4) echo "claude-opus-4-20250514" ;;
    *) echo "$model" ;;
  esac
}

# Determine provider from model name
get_provider() {
  local model="$1"
  case "$model" in
    opus-*|sonnet-*|haiku-*|claude-*) echo "anthropic" ;;
    gpt-*|o3*|o4*) echo "openai" ;;
    gemini-*|*-pro|*-flash*) echo "google" ;;
    *) echo "unknown" ;;
  esac
}

# Execute Codex agent (OpenAI with reasoning)
execute_codex() {
  local model="$1"
  local task="$2"
  local type="$3"
  local reasoning="${4:-medium}"

  local api_model
  api_model=$(map_openai_model "$model")

  # Determine if model supports reasoning
  local supports_reasoning=true
  case "$api_model" in
    gpt-4.1*|gpt-4) supports_reasoning=false ;;
  esac

  # Map reasoning level
  local api_reasoning="$reasoning"
  case "$reasoning" in
    none|minimal|low|medium|high) ;;
    *) api_reasoning="medium" ;;
  esac

  # Set max tokens based on reasoning level
  local max_tokens=8000
  case "$reasoning" in
    high) max_tokens=16000 ;;
    medium) max_tokens=8000 ;;
    low|minimal) max_tokens=4000 ;;
    none) max_tokens=4000 ;;
  esac

  local system_prompt
  system_prompt=$(get_system_prompt "$type")
  local escaped_task escaped_system
  escaped_task=$(json_escape "$task")
  escaped_system=$(json_escape "$system_prompt")

  echo -e "${BLUE}[Codex]${NC} Model: $api_model | Reasoning: $api_reasoning | Type: $type" >&2

  if [[ -z "${OPENAI_API_KEY:-}" ]]; then
    echo -e "${RED}ERROR: OPENAI_API_KEY not set${NC}" >&2
    echo "Get a key at: https://platform.openai.com/api-keys" >&2
    exit 1
  fi

  # Build request
  local request_body
  if [[ "$supports_reasoning" == "true" ]]; then
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

# Execute Gemini agent (Google, FREE)
execute_gemini() {
  local model="$1"
  local task="$2"
  local type="$3"

  local api_model
  api_model=$(map_gemini_model "$model")

  local system_prompt
  system_prompt=$(get_system_prompt "$type")
  local escaped_task escaped_system
  escaped_task=$(json_escape "$task")
  escaped_system=$(json_escape "$system_prompt")

  echo -e "${BLUE}[Gemini]${NC} Model: $api_model | Type: $type (FREE)" >&2

  if [[ -z "${GOOGLE_API_KEY:-}" ]]; then
    echo -e "${RED}ERROR: GOOGLE_API_KEY not set${NC}" >&2
    echo "Get a FREE key at: https://ai.google.dev/tutorials/setup" >&2
    exit 1
  fi

  curl -s "https://generativelanguage.googleapis.com/v1beta/models/$api_model:generateContent" \
    -H "Content-Type: application/json" \
    -H "x-goog-api-key: $GOOGLE_API_KEY" \
    -d "{
      \"system_instruction\": {\"parts\": {\"text\": $escaped_system}},
      \"contents\": {\"parts\": {\"text\": $escaped_task}},
      \"generationConfig\": {\"maxOutputTokens\": 8000, \"temperature\": 0.7}
    }" | jq -r '.candidates[0].content.parts[0].text // .error.message // "Unknown error"'
}

# Execute OpenCode agent (multi-provider)
execute_opencode() {
  local model="$1"
  local task="$2"
  local type="$3"
  local reasoning="${4:-standard}"

  local provider
  provider=$(get_provider "$model")

  local system_prompt
  system_prompt=$(get_system_prompt "$type")
  local escaped_task escaped_system
  escaped_task=$(json_escape "$task")
  escaped_system=$(json_escape "$system_prompt")

  case "$provider" in
    anthropic)
      local api_model
      api_model=$(map_claude_model "$model")

      echo -e "${BLUE}[OpenCode]${NC} Model: $api_model (Claude) | Reasoning: $reasoning | Type: $type" >&2

      if [[ -z "${ANTHROPIC_API_KEY:-}" ]]; then
        echo -e "${RED}ERROR: ANTHROPIC_API_KEY not set${NC}" >&2
        echo "Get a key at: https://console.anthropic.com/" >&2
        exit 1
      fi

      local max_tokens=8000
      local request_body

      if [[ "$reasoning" == "extended" ]]; then
        # Extended thinking request
        request_body="{
          \"model\": \"$api_model\",
          \"max_tokens\": 16000,
          \"thinking\": {
            \"type\": \"enabled\",
            \"budget_tokens\": 10000
          },
          \"messages\": [{\"role\": \"user\", \"content\": $escaped_task}]
        }"
      else
        request_body="{
          \"model\": \"$api_model\",
          \"max_tokens\": $max_tokens,
          \"system\": $escaped_system,
          \"messages\": [{\"role\": \"user\", \"content\": $escaped_task}]
        }"
      fi

      curl -s https://api.anthropic.com/v1/messages \
        -H "x-api-key: $ANTHROPIC_API_KEY" \
        -H "anthropic-version: 2023-06-01" \
        -H "content-type: application/json" \
        -d "$request_body" | jq -r '.content[0].text // .content[] | select(.type == "text") | .text // .error.message // "Unknown error"'
      ;;

    openai)
      local api_model
      api_model=$(map_openai_model "$model")

      # Map reasoning for OpenAI
      local api_reasoning="medium"
      case "$reasoning" in
        none|minimal|low|medium|high) api_reasoning="$reasoning" ;;
        extended) api_reasoning="high" ;;
        *) api_reasoning="medium" ;;
      esac

      echo -e "${BLUE}[OpenCode]${NC} Model: $api_model (OpenAI) | Reasoning: $api_reasoning | Type: $type" >&2

      if [[ -z "${OPENAI_API_KEY:-}" ]]; then
        echo -e "${RED}ERROR: OPENAI_API_KEY not set${NC}" >&2
        exit 1
      fi

      local max_tokens=8000
      local request_body

      # Check if model supports reasoning
      local supports_reasoning=true
      case "$api_model" in
        gpt-4.1*|gpt-4) supports_reasoning=false ;;
      esac

      if [[ "$supports_reasoning" == "true" ]]; then
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
      ;;

    google)
      local api_model
      api_model=$(map_gemini_model "$model")

      echo -e "${BLUE}[OpenCode]${NC} Model: $api_model (Gemini, FREE) | Type: $type" >&2

      if [[ -z "${GOOGLE_API_KEY:-}" ]]; then
        echo -e "${RED}ERROR: GOOGLE_API_KEY not set${NC}" >&2
        echo "Get a FREE key at: https://ai.google.dev/tutorials/setup" >&2
        exit 1
      fi

      curl -s "https://generativelanguage.googleapis.com/v1beta/models/$api_model:generateContent" \
        -H "Content-Type: application/json" \
        -H "x-goog-api-key: $GOOGLE_API_KEY" \
        -d "{
          \"system_instruction\": {\"parts\": {\"text\": $escaped_system}},
          \"contents\": {\"parts\": {\"text\": $escaped_task}},
          \"generationConfig\": {\"maxOutputTokens\": 8000}
        }" | jq -r '.candidates[0].content.parts[0].text // .error.message // "Unknown error"'
      ;;

    *)
      echo -e "${RED}ERROR: Unknown provider for model '$model'${NC}" >&2
      exit 1
      ;;
  esac
}

# Main execution
case "$AGENT" in
  codex)
    [[ -z "$MODEL" ]] && MODEL="gpt-5.2"
    [[ -z "$TYPE" ]] && TYPE="architecture"
    [[ -z "$REASONING" ]] && REASONING="medium"
    execute_codex "$MODEL" "$TASK" "$TYPE" "$REASONING"
    ;;
  gemini)
    [[ -z "$MODEL" ]] && MODEL="gemini-3-flash"
    [[ -z "$TYPE" ]] && TYPE="design"
    execute_gemini "$MODEL" "$TASK" "$TYPE"
    ;;
  opencode)
    [[ -z "$MODEL" ]] && MODEL="sonnet-4.5"
    [[ -z "$TYPE" ]] && TYPE="generation"
    [[ -z "$REASONING" ]] && REASONING="standard"
    execute_opencode "$MODEL" "$TASK" "$TYPE" "$REASONING"
    ;;
  *)
    echo -e "${RED}ERROR: Unknown agent '$AGENT'${NC}" >&2
    echo "Valid agents: codex, gemini, opencode" >&2
    exit 1
    ;;
esac
