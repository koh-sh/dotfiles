# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

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

## Custom Slash Commands

- `/apply` - Run `chezmoi diff` and apply changes (prompts for confirmation if differences exist)
- `/commit` - Git add, commit, and push with a simple commit message

## Managed Configurations

Located in `home/dot_config/`: git, hammerspoon, irb, mise, npm, nvim, tig, tmux, vim, wezterm, xonsh, zsh
