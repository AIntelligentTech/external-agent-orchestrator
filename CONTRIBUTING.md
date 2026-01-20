# Contributing to External Agent Orchestrator

Thank you for your interest in contributing\! This document provides guidelines for contributions.

## How to Contribute

### Reporting Issues

1. Check existing issues to avoid duplicates
2. Use the issue template if available
3. Include:
   - Clear description of the problem
   - Steps to reproduce
   - Expected vs actual behavior
   - Environment details (OS, Claude Code version)

### Suggesting Features

1. Open an issue with the "enhancement" label
2. Describe the use case and benefit
3. Consider backward compatibility

### Pull Requests

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Test thoroughly
5. Commit with clear messages
6. Push to your fork
7. Open a Pull Request

## Development Setup

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/external-agent-orchestrator.git
cd external-agent-orchestrator

# Test the install script locally
./install.sh --project .
```

## Code Style

- Shell scripts should pass `shellcheck`
- Use meaningful variable names
- Comment complex logic
- Keep functions focused and small

## Testing

Before submitting:
1. Test install.sh on a fresh directory
2. Verify all agent types work (codex, gemini, opencode)
3. Test with different Claude Code versions if possible

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
