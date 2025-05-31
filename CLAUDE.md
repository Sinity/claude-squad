# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Building
```bash
go build -v -o claude-squad
```

### Testing
```bash
go test -v ./...
```

### Linting
```bash
# Format code
gofmt -w .

# Run golangci-lint (requires installation)
golangci-lint run --timeout=5m
```

## Architecture Overview

Claude Squad is a terminal application that manages multiple AI coding assistants (Claude Code, Codex, Aider) in isolated workspaces. It uses:

- **tmux** for session isolation - each AI assistant runs in its own tmux session
- **git worktrees** for branch isolation - each session works on its own branch without conflicts
- **Bubble Tea TUI framework** for the terminal interface

### Key Components

- `main.go` - CLI entry point using Cobra, handles commands (reset, debug, version)
- `app/` - Main application logic and TUI state management
- `session/` - Core session management:
  - `git/` - Git worktree operations for branch isolation
  - `tmux/` - tmux session lifecycle management
- `ui/` - Terminal UI components (list view, preview, diff view)
- `daemon/` - Background daemon for auto-accept mode (`--autoyes` flag)

### Session Lifecycle

1. New session creates a git worktree on a new branch
2. AI assistant runs in isolated tmux session within that worktree
3. Changes can be reviewed, committed, and pushed from the main UI
4. Sessions can be paused (checkout) or resumed

### Platform Support

The codebase has platform-specific implementations:
- Unix systems: Full tmux and pty support
- Windows: Stub implementations (limited functionality)