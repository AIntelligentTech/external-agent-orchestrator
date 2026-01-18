#!/usr/bin/env bash
#
# External Agent Orchestrator - Installation Script
#
# Usage:
#   ./install.sh           Install to user level (~/.claude/) - available in all projects
#   ./install.sh --project Install to project level (.claude/) - only current project
#
# Requirements:
#   - Claude Code CLI installed
#   - jq installed (for JSON parsing)
#   - curl installed (for API calls)
#   - API keys for desired providers

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default to user-level installation
INSTALL_TARGET="user"
TARGET_DIR="$HOME/.claude"

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --project|-p)
      INSTALL_TARGET="project"
      TARGET_DIR=".claude"
      shift
      ;;
    --help|-h)
      cat <<EOF
External Agent Orchestrator - Installation Script

Usage:
  ./install.sh              Install to user level (~/.claude/)
  ./install.sh --project    Install to project level (.claude/)
  ./install.sh --help       Show this help

Options:
  --project, -p    Install to current project directory (.claude/)
                   Commands will only be available in this project

  --help, -h       Show this help message

What gets installed:
  agents/external-agent.md     Subagent definition
  commands/agent.md            /agent dispatcher command
  commands/codex.md            /codex shortcut
  commands/gemini.md           /gemini shortcut
  commands/opencode.md         /opencode shortcut
  scripts/external-agent.sh    Orchestration script

Requirements:
  - Claude Code CLI
  - jq (JSON parsing)
  - curl (API calls)

After installation, set your API keys:
  export OPENAI_API_KEY="sk-..."        # For Codex, OpenCode:gpt4
  export GOOGLE_API_KEY="AIza..."       # For Gemini (FREE!)
  export ANTHROPIC_API_KEY="sk-ant-..." # For OpenCode:opus/sonnet/haiku
EOF
      exit 0
      ;;
    *)
      echo -e "${RED}Unknown option: $1${NC}"
      echo "Use --help for usage information"
      exit 1
      ;;
  esac
done

echo -e "${BOLD}External Agent Orchestrator - Installation${NC}"
echo ""

# Check prerequisites
echo -e "${BLUE}Checking prerequisites...${NC}"

MISSING_DEPS=()

if ! command -v jq &> /dev/null; then
  MISSING_DEPS+=("jq")
fi

if ! command -v curl &> /dev/null; then
  MISSING_DEPS+=("curl")
fi

if [[ ${#MISSING_DEPS[@]} -gt 0 ]]; then
  echo -e "${YELLOW}WARNING: Missing dependencies: ${MISSING_DEPS[*]}${NC}"
  echo "Install with: brew install ${MISSING_DEPS[*]}"
  echo ""
fi

# Confirm installation location
if [[ "$INSTALL_TARGET" == "user" ]]; then
  echo -e "Installing to: ${GREEN}$TARGET_DIR${NC} (user level - all projects)"
else
  echo -e "Installing to: ${GREEN}$TARGET_DIR${NC} (project level - current project only)"
fi
echo ""

# Create directories
echo -e "${BLUE}Creating directories...${NC}"
mkdir -p "$TARGET_DIR/agents"
mkdir -p "$TARGET_DIR/commands"
mkdir -p "$TARGET_DIR/scripts"

# Copy files
echo -e "${BLUE}Installing files...${NC}"

# Agent definition
cp "$SCRIPT_DIR/.claude/agents/external-agent.md" "$TARGET_DIR/agents/"
echo "  agents/external-agent.md"

# Commands
cp "$SCRIPT_DIR/.claude/commands/agent.md" "$TARGET_DIR/commands/"
echo "  commands/agent.md"
cp "$SCRIPT_DIR/.claude/commands/codex.md" "$TARGET_DIR/commands/"
echo "  commands/codex.md"
cp "$SCRIPT_DIR/.claude/commands/gemini.md" "$TARGET_DIR/commands/"
echo "  commands/gemini.md"
cp "$SCRIPT_DIR/.claude/commands/opencode.md" "$TARGET_DIR/commands/"
echo "  commands/opencode.md"

# Scripts
cp "$SCRIPT_DIR/.claude/scripts/external-agent.sh" "$TARGET_DIR/scripts/"
chmod +x "$TARGET_DIR/scripts/external-agent.sh"
echo "  scripts/external-agent.sh"

echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""

# Check API keys
echo -e "${BLUE}Checking API keys...${NC}"

check_key() {
  local key_name="$1"
  local service="$2"
  local get_url="$3"
  local is_free="${4:-}"

  if [[ -n "${!key_name:-}" ]]; then
    echo -e "  ${GREEN}$key_name${NC} is set ($service)"
  else
    if [[ -n "$is_free" ]]; then
      echo -e "  ${YELLOW}$key_name${NC} not set ($service - FREE!) - $get_url"
    else
      echo -e "  ${YELLOW}$key_name${NC} not set ($service) - $get_url"
    fi
  fi
}

check_key "OPENAI_API_KEY" "Codex, OpenCode:gpt4" "https://platform.openai.com/api-keys"
check_key "GOOGLE_API_KEY" "Gemini, OpenCode:gemini" "https://ai.google.dev/tutorials/setup" "FREE"
check_key "ANTHROPIC_API_KEY" "OpenCode:opus/sonnet/haiku" "https://console.anthropic.com/"

echo ""
echo -e "${BOLD}Quick Start${NC}"
echo ""
echo "  # Full colon syntax"
echo "  /agent:gemini:flash Describe a modern button component"
echo "  /agent:codex:xhigh Design a scalable microservices architecture"
echo "  /agent:opencode:haiku Write a debounce utility function"
echo ""
echo "  # Shortcut commands"
echo "  /gemini:pro Create a dark mode design system (FREE)"
echo "  /codex:high Review authentication for vulnerabilities"
echo "  /opencode:sonnet Generate a REST API with JWT"
echo ""
echo -e "For more examples, see: ${BLUE}https://github.com/AIntelligentTech/external-agent-orchestrator${NC}"
echo ""

# Remind about restart
if [[ "$INSTALL_TARGET" == "user" ]]; then
  echo -e "${YELLOW}NOTE: Restart Claude Code to load the new commands.${NC}"
else
  echo -e "${YELLOW}NOTE: Restart Claude Code or start a new session in this project.${NC}"
fi
