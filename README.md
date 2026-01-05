# utils

Developer utilities for git worktree management and code review workflows.

## gw - Git Worktree Manager

A powerful CLI tool for managing isolated git worktrees with explicit purpose tracking. Perfect for code reviews, feature development, bug fixes, and experiments.

### Features

- 🎯 **Purpose-driven worktrees**: Every worktree has an explicit purpose (review, feature, bugfix, experiment, etc.)
- 🚀 **Simple commands**: Intuitive CLI for creating, navigating, and managing worktrees
- 🔒 **Safety first**: Prevents accidental removal of worktrees you're currently working in
- 💻 **Shell integration**: Native `cd` command support for seamless navigation
- 🎨 **VS Code integration**: Optional `--open` flag to open worktrees directly in VS Code

### Installation

```bash
# Install tools (user-level)
curl -sSL https://raw.githubusercontent.com/tkxkd0159/utils/main/install.sh | bash -s -- gw <tool2>

# Install tools (system-wide)
curl -sSL https://raw.githubusercontent.com/tkxkd0159/utils/main/install.sh | sudo bash -s -- gw <tool2>
```

### Quick Start

```bash
# Create a worktree for code review
gw add review feature/new-ui

# Navigate to it
gw cd review feature/new-ui

# List all worktrees
gw list

# Open in VS Code
gw open review feature/new-ui

# Remove when done
gw remove review feature/new-ui
```

### Usage

```bash
gw add [--open] PURPOSE [REMOTE:]BRANCH    # Create worktree
gw cd PURPOSE [REMOTE:]BRANCH              # Navigate to worktree
gw open PURPOSE [REMOTE:]BRANCH            # Open in VS Code
gw list                                    # List all worktrees
gw remove PURPOSE [REMOTE:]BRANCH          # Remove worktree
gw install                                 # Set up shell integration
gw --help                                  # Show help
```

**Purpose examples:** `review`, `feature`, `bugfix`, `experiment`, `hotfix`

### How It Works

- Creates isolated worktrees in `../<repo>.worktrees/` directory
- Branch naming: `<remote>-<branch>-gwt-<purpose>`
- Default remote is `origin` if not specified
- Shell integration enables native `cd` command functionality
- Worktrees are isolated from each other - perfect for parallel work

### Documentation

See [CLAUDE.md](CLAUDE.md) for detailed documentation and code review workflow integration.