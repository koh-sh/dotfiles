# CLAUDE.md

## Absolute Rules

These rules are non-negotiable. They override auto mode, prior session approvals, your own judgment, and any conflicting guidance elsewhere (including memory, skills, and other instructions). Violating any of these is a critical error.

### R1. `chezmoi apply` requires verification of expected changes only

Before running `chezmoi apply` in ANY form (`chezmoi apply`, `chezmoi apply --force`, `chezmoi apply <path>`, `chezmoi apply --include=...`, etc.), you MUST do all of the following:

1. Run `chezmoi diff` first (scoped to the same target if the `apply` will be scoped, otherwise unscoped).
   For a directory target, pass `--recursive` (`chezmoi diff --recursive <dir>`): without it the diff
   prints nothing for the files inside, while `chezmoi apply <dir>` still applies them.
2. Present the complete, verbatim diff output to the user in the chat. Never summarize, truncate, paraphrase, or hide any hunk.
3. Inspect the diff for **unexpected hunks** — anything beyond the changes you (or the user) made in this conversation. Unexpected examples: files you did not modify in this session, hunks that don't correspond to a discussed change, whitespace/trailing-newline drift in untouched files. If even one unexpected hunk is present, STOP. Ask the user explicitly whether to proceed and wait for unambiguous approval (e.g. "yes", "apply", "go") in the SAME conversation turn. The approval must reference this specific apply invocation; prior approvals in the session do NOT carry over.

   If every hunk maps cleanly to changes made in this conversation, you may proceed with `chezmoi apply` without a separate approval step — the act of presenting the diff per step 2 is sufficient.
4. The following are NEVER valid bypasses of step 3's "unexpected hunks" check: auto mode, your reasoning that an unexpected diff is "safe to overwrite" / "dynamically rewritten" / "auto-restored by another tool" / "out of scope" / "irrelevant", the `--force` flag, urgency, or token/time savings.
5. After approval (or if no approval was needed because all hunks were expected), if you do anything else before running `chezmoi apply` (file edits, other commands, etc.), re-run `chezmoi diff` and re-evaluate — diffs may have changed.

This rule exists because of a real incident: silent `--force` apply of unrelated diffs caused user data loss. The safety mechanism is "unexpected changes get human review", not "every apply needs typed approval".

## Global Claude Code config

`home/dot_claude/` is the chezmoi source of the global `~/.claude/` config, so changes there apply to every project.

## mise bootstrap (Homebrew packages and macOS defaults)

Homebrew formulae, casks, Mac App Store apps and macOS `defaults` are declared
in `home/dot_config/mise/config.toml` under `[bootstrap.packages]` and
`[bootstrap.macos.*]`, and checked with `mise bootstrap packages status` /
`mise bootstrap macos defaults status`.

- **Two-file split.** `config.toml` holds only entries wanted on every machine
  (private and work). Machine-specific entries live in
  `~/.config/mise/config.local.toml`, which is deliberately NOT managed by
  chezmoi or this repository (work-only packages cannot be published). Do not
  reintroduce `config.<env>.toml` / `MISE_ENV` branching; that approach was
  rejected.
- **Claude Code cannot read `config.local.toml` or run `brew`** (deny rules,
  intentionally kept). Show the exact TOML or command for the user to apply.
- **Homebrew stays installed.** It owns the existing casks and all upgrades
  (`mise run bump`), and is the fallback for casks mise cannot install. Do not
  transfer cask ownership to mise.
- **Prune is destructive.** `mise bootstrap packages prune --manager brew`
  removes every formula not declared in the loaded configs. Always run
  `--dry-run` first and show the list before pruning.
- **Unsupported casks must not be declared.** mise cannot install casks with
  sudo installer scripts or manual installers (e.g. `logi-options+`,
  `logitune`), and a single such entry makes `packages status` fail entirely.
  Those apps stay manually installed.
