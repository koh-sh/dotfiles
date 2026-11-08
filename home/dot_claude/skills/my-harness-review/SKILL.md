---
description: Review this project's Claude Code harness (CLAUDE.md, AGENTS.md, .claude/, .mcp.json) after a Claude Code update or as the harness evolves, then open one PR with the changes the user adopts.
disable-model-invocation: true
allowed-tools: Bash(claude -p --permission-mode plan *)
---

# my-harness-review

Review the project's harness with the same procedure every time: detect issues, propose changes, apply only the ones the user adopts, and open one PR. Run it after a Claude Code update or when the harness has changed during development. It is not meant to run on a schedule.

## Scope

Harness files, as the pathspec used by the git commands below:

```
':(glob)**/CLAUDE.md' ':(glob)**/AGENTS.md' .claude .mcp.json
```

`.claude/` covers rules, skills, commands, agents and settings.json. Findings about anything outside this repository (user-level `~/.claude/`, claude.ai connectors, the installation, other projects) are listed for information only and never go into the PR.

## 1. Preflight

- Run `git status --porcelain --untracked-files=all -- <harness pathspec>`. If anything is listed, stop and ask the user to commit or stash it, so the PR holds only this review's changes.
- If the current branch is not the default branch, or the default branch is behind its remote, tell the user and ask whether to continue. The PR in step 6 targets the default branch.

## 2. Start the headless checks

The model cannot invoke these commands itself, so run each in its own headless session. Start all of them in parallel with the Bash tool in the background (`run_in_background`), without redirecting their output:

- `claude -p --permission-mode plan "/doctor"`: setup checkup, including unused skills, MCP servers and plugins against their context cost, slow hooks, and CLAUDE.md bloat
- `claude -p --permission-mode plan "/doctor prompt-audit"`: outdated or conflicting instructions and references to missing files or commands
- `claude -p --permission-mode plan "/fewer-permission-prompts"`: read-only commands worth adding to an allowlist
- `claude -p --permission-mode plan "/insights"`: friction in recent sessions; each run analyzes only sessions it has not seen, and writes the report to `~/.claude/usage-data/report.html`

Plan mode keeps them from changing files: each returns its findings and proposed changes as text. They take several minutes each. Go on with step 3 while they run. Their output often ends with questions, because plan mode cannot ask the user. Ignore those questions and treat the output as findings. When the output points to a plan file under `~/.claude/plans/` for the full report or proposed diffs, read that file too.

## 3. Model-run checks

Keep the evidence (command output, `file:line`, report excerpt) for every finding.

1. Run `claude plugin validate . --strict`. It checks `.claude/{skills,agents,commands}`, warnings included, such as unrecognized frontmatter fields. It does not check CLAUDE.md, rules, settings.json or .mcp.json.
2. Read `.claude/settings.json` and `.mcp.json` directly instead of `/hooks` and `/permissions`. Check that hook commands point at scripts that exist, and look for permission rules that are redundant, shadowed by another rule, or broader than needed.
3. When `/insights` has finished, read `~/.claude/usage-data/report.html` and keep only what concerns this project: misunderstood requests, repeated corrections, tool errors.

## 4. Proposals

When every check has finished, merge the findings, drop duplicates, and present one numbered list. Each item has:

- **What**: the finding, with `file:line`
- **Evidence**: command output or report excerpt
- **Proposal**: the concrete change
- **Source**: the check that found it

The headless checks also cover user-level config and transcripts from every project, so expect many findings outside this repository. List them after the numbered list, without proposals.

Ask which items to adopt with AskUserQuestion: multiSelect, one option per item, up to 4 options per question and 4 questions per call, and more calls when there are more items.

## 5. Apply

1. Apply the adopted items.
2. Show `git diff --stat` and the full `git diff`.

## 6. Pull request

1. Ask for approval to create the branch, commit, push and open the PR. Do none of these without it.
2. Create `chore/harness-review-<YYYY-MM-DD>` from the current HEAD.
3. Commit each concern separately, following the project's commit conventions.
4. Push and open one PR titled `chore(claude): review harness`, adapted to the project's conventions. The body has:
   - adopted changes, each with its evidence
   - items not adopted, one line each
   - verification in a new session: what to check for each adopted change. The harness is loaded at session start, so this session cannot show the effect.
5. Reply with the PR URL and tell the user to run the verification in a new session.
