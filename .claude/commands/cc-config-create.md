---
description: Create Claude Code configuration files (commands, agents, settings)
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(ls:*), Read, Write, Edit, Glob, Grep, WebSearch, WebFetch, Task
argument-hint: [feature-type] [description]
---

# cc-config-create

Create Claude Code configuration files following the workflow below.

## Context

- Target directory: @home/dot_claude (managed by chezmoi)
- Existing structure: !`ls -la home/dot_claude/`

## Workflow

1. **Research the specification**
   - Use the claude-code-guide agent to research the relevant Claude Code feature
   - Ensure you are referencing the latest specification
   - Understand all available options and syntax

2. **Research best practices**
   - Search official Claude Code documentation
   - Look for community examples and patterns on the internet
   - Identify common pitfalls to avoid

3. **Implement the configuration**
   - Create files under `home/dot_claude/` (chezmoi source directory)
   - Follow chezmoi naming conventions (e.g., `dot_` prefix for dotfiles)
   - Include appropriate frontmatter for slash commands
   - Use clear, descriptive names and descriptions

4. **Request review**
   - Present the created/modified files to the user
   - Explain the design decisions made
   - Ask for feedback before finalizing

## User Request

$ARGUMENTS
