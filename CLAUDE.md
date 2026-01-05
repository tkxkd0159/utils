# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This repository contains utilities and templates for code review workflows and git worktree management with explicit purpose tracking.

## Repository Structure

- **`copilot/`**: GitHub Copilot chat modes and prompt templates
  - `Code-Review.chatmode.md`: Autonomous two-phase code review agent configuration
  - `two-phase-review.prompt.md`: Standard two-phase review prompt (generates `REPORT-$ARGUMENTS.md`)
  - `two-phase-review-gwt.prompt.md`: Git worktree-integrated review prompt (uses `gw` script)
- **`scripts/`**: Shell utilities
  - `gw`: Git worktree manager with explicit purpose tracking (review, feature, bugfix, etc.)

## Git Worktree Manager (`gw`)

The `gw` script manages isolated git worktrees with explicit purpose tracking. It creates worktrees in a sibling directory named `<repo>.worktrees/`.

### Common Commands

```bash
# Add a new worktree with explicit purpose
gw add review feature-branch           # Default origin remote
gw add feature upstream:feature-x      # Specify remote
gw add --open bugfix issue-123         # Opens in VS Code

# Navigate to a worktree (after running 'gw install')
gw cd review feature-branch
gw cd feature upstream:feature-x

# Open existing worktree in VS Code
gw open review feature-branch

# List all managed worktrees
gw list

# Remove a worktree and its local branch
gw remove review feature-branch
```

### How It Works

- **Purpose is required**: Every worktree must specify its purpose (review, feature, bugfix, experiment, hotfix, etc.)
- Creates local branches named `<remote>-<branch>-gwt-<purpose>`
- Worktrees are created at `../<repo-name>.worktrees/<remote>-<branch>-gwt-<purpose>/`
- Default remote is `origin` if not specified (format: `[remote:]branch`)
- If a remote doesn't exist, prompts to add it interactively
- The `cd` command requires shell integration installed via `gw install`

## Code Review Workflows

### Two-Phase Review Process

Both review prompts follow a rigorous three-phase methodology:

**Phase 1: Data Gathering & Initial Draft**
- Fetch latest changes from `origin/main`
- Generate diffs: `DIFF.patch` and `FILES.txt`
- Perform broad review guided by analysis criteria (correctness, security, performance, etc.)
- Create internal draft report (not saved to file)

**Phase 2: Critical Self-Correction**
- Shift perspective to Principal Engineer reviewing Staff Engineer's draft
- Eliminate false positives and challenge severity assessments
- Simplify fix suggestions and identify deeper architectural issues

**Phase 3: Final Report Generation**
- Format refined findings into structured report
- Save as `REPORT-$ARGUMENTS.md` with sections: VERDICT, TRIAGE SUMMARY, ISSUES TABLE, PERF NOTES, SECURITY NOTES, RELEASE/OPS, NICE-TO-HAVES, OPEN QUESTIONS

### Difference Between Review Prompts

- **`two-phase-review.prompt.md`**: Works in the current repository
- **`two-phase-review-gwt.prompt.md`**: Uses `gw` to create isolated worktree, performs review, then cleans up
  - Adds Phase 1 step: `gw add review $ARGUMENTS && gw cd review $ARGUMENTS`
  - Adds Phase 4 cleanup: `cd - && gw remove review $ARGUMENTS`
  - Note: Requires `gw install` to be run once for shell integration

### Analysis Criteria

Reviews must ignore files under `mocks/` and evaluate:
- Correctness & Edge Cases
- Security & Privacy (injection, XSS/CSRF/SSRF, secrets, PII)
- Performance (algorithmic complexity, N+1 queries, blocking I/O)
- API & Compatibility (breaking changes, migrations)
- Testing (coverage gaps, flake risks)
- Reliability & Ops (error handling, observability)
- Maintainability (readability, DRY, coupling)
- Style/Consistency (conventions, linting)
