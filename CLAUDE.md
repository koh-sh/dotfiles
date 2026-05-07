# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Absolute Rules

These rules are non-negotiable. They override auto mode, prior session approvals, your own judgment, and any conflicting guidance elsewhere (including memory, skills, and other instructions). Violating any of these is a critical error.

### R1. `chezmoi apply` requires verification of expected changes only

Before running `chezmoi apply` in ANY form (`chezmoi apply`, `chezmoi apply --force`, `chezmoi apply <path>`, `chezmoi apply --include=...`, etc.), you MUST do all of the following:

1. Run `chezmoi diff` first (scoped to the same target if the `apply` will be scoped, otherwise unscoped).
2. Present the complete, verbatim diff output to the user in the chat. Never summarize, truncate, paraphrase, or hide any hunk.
3. Inspect the diff for **unexpected hunks** — anything beyond the changes you (or the user) made in this conversation. Unexpected examples: files you did not modify in this session, hunks that don't correspond to a discussed change, whitespace/trailing-newline drift in untouched files. If even one unexpected hunk is present, STOP. Ask the user explicitly whether to proceed and wait for unambiguous approval (e.g. "yes", "apply", "go") in the SAME conversation turn. The approval must reference this specific apply invocation; prior approvals in the session do NOT carry over.

   If every hunk maps cleanly to changes made in this conversation, you may proceed with `chezmoi apply` without a separate approval step — the act of presenting the diff per step 2 is sufficient.
4. The following are NEVER valid bypasses of step 3's "unexpected hunks" check: auto mode, your reasoning that an unexpected diff is "safe to overwrite" / "dynamically rewritten" / "auto-restored by another tool" / "out of scope" / "irrelevant", the `--force` flag, urgency, or token/time savings.
5. After approval (or if no approval was needed because all hunks were expected), if you do anything else before running `chezmoi apply` (file edits, other commands, etc.), re-run `chezmoi diff` and re-evaluate — diffs may have changed.

This rule exists because of a real incident: silent `--force` apply of unrelated diffs caused user data loss. The safety mechanism is "unexpected changes get human review", not "every apply needs typed approval".

## Overview

This is a chezmoi-managed dotfiles repository. Chezmoi manages dotfiles by storing them in a source directory and applying them to the home directory.

## Key Architecture

- `.chezmoiroot` is set to `home`, meaning all managed dotfiles are under `home/`
- Files prefixed with `dot_` become dotfiles (e.g., `dot_config/` → `~/.config/`)
- Template files use `.tmpl` suffix for OS-specific logic
- External dependencies (like Hammerspoon Spoons) are defined in `.chezmoiexternal.toml.tmpl`
- Scripts in `.chezmoiscripts/` run during apply (prefixed with `run_once_` or `run_onchange_`)

## Commands

```bash
# Check differences between repo and local configs
chezmoi diff

# Apply dotfiles to local machine
chezmoi apply

# View chezmoi configuration
chezmoi dump-config
```

## Skills

- `/apply` - Run `chezmoi diff` and apply changes (prompts for confirmation if differences exist)
- `/commit` - Git add, commit, and push with a simple commit message
- `/apply-and-commit` - Apply dotfiles changes and commit to git
- `/cc-config-create` - Create Claude Code configuration files (skills, agents, settings)

## Managed Configurations

Located in `home/dot_config/`: git, hammerspoon, irb, mise, npm, nvim, tig, tmux, vim, wezterm, xonsh, zsh
