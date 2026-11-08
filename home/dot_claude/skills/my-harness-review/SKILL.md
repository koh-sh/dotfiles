---
description: Review this project's Claude Code harness (CLAUDE.md, AGENTS.md, .claude/, .mcp.json) after a Claude Code update or as the harness evolves, then open one PR with the changes the user adopts.
disable-model-invocation: true
---

# my-harness-review

Review the project's harness with the same procedure every time: detect issues, propose changes, apply only the ones the user adopts, and open one PR. Run it after a Claude Code update or when the harness has changed during development. It is not meant to run on a schedule.

## Scope

Harness files, as the pathspec used by the git commands below:

```
':(glob)**/CLAUDE.md' ':(glob)**/AGENTS.md' .claude .mcp.json
```

`.claude/` covers rules, skills, commands, agents and settings.json. Findings about files outside this repository (user-level `~/.claude/`, the installation) are listed for information only and never go into the PR.

## 1. Preflight

- Run `git status --porcelain --untracked-files=all -- <harness pathspec>`. If anything is listed, stop and ask the user to commit or stash it. Step 2 lets commands write to these files and step 5 reverts what is not adopted, so existing changes would be lost or mixed into the PR.
- If the current branch is not the default branch, or the default branch is behind its remote, tell the user and ask whether to continue. The PR in step 6 targets the default branch.

## 2. User-run commands

The model cannot run these. Ask the user to run them in this session in this order and to say when they are done, then end the turn. Their output lands in the conversation.

- `/doctor`: setup checkup, including unused skills, MCP servers and plugins against their context cost, slow hooks, and CLAUDE.md bloat
- `/doctor prompt-audit`: outdated or conflicting instructions and references to missing files or commands
- `/fewer-permission-prompts`: writes an allowlist to `.claude/settings.json`
- `/insights`: friction in recent sessions; each run analyzes only sessions it has not seen

Tell the user: when `/doctor` asks to change something, accept changes to files inside this repository and decline the rest, such as installation, usage and user-level settings fixes. Accepted changes become proposals in step 4 and are reverted if not adopted. If a command is unavailable, note it and continue.

## 3. Model-run checks

When the user is back, run these yourself. Keep the evidence (command output, `file:line`, report excerpt) for every finding.

1. Collect what step 2 wrote: `git diff -- <harness pathspec>` and `git status --porcelain --untracked-files=all -- <harness pathspec>`.
2. Run `claude plugin validate . --strict`. It checks `.claude/{skills,agents,commands}`, warnings included, such as unrecognized frontmatter fields. It does not check CLAUDE.md, rules, settings.json or .mcp.json.
3. Read `.claude/settings.json` and `.mcp.json` directly instead of `/hooks` and `/permissions`. Check that hook commands point at scripts that exist, and look for permission rules that are redundant, shadowed by another rule, or broader than needed.
4. Read `~/.claude/usage-data/report.html` and keep only what concerns this project: misunderstood requests, repeated corrections, tool errors.

## 4. Proposals

Merge the findings from steps 2 and 3, drop duplicates, and present one numbered list. Each item has:

- **What**: the finding, with `file:line`
- **Evidence**: command output or report excerpt
- **Proposal**: the concrete change
- **Source**: the check that found it
- **State**: `pending` (not written yet) or `in working tree` (written in step 2, reverted if not adopted)

Split the writes from step 2 into independent changes so each can be adopted separately. List out-of-repository findings, including the `/doctor` fixes the user declined, after the numbered list without proposals.

Ask which items to adopt with AskUserQuestion: multiSelect, one option per item, up to 4 options per question and 4 questions per call, and more calls when there are more items.

## 5. Apply

1. Revert every `in working tree` change that was not adopted. Use `git restore -- <file>` only when none of the file's changes were adopted; otherwise edit out the rejected hunks. Delete an untracked file that a command created only when it was not adopted, naming it first.
2. Apply the adopted `pending` items.
3. Show `git diff --stat` and the full `git diff`.

## 6. Pull request

1. Ask for approval to create the branch, commit, push and open the PR. Do none of these without it.
2. Create `chore/harness-review-<YYYY-MM-DD>` from the current HEAD.
3. Commit each concern separately, following the project's commit conventions.
4. Push and open one PR titled `chore(claude): review harness`, adapted to the project's conventions. The body has:
   - adopted changes, each with its evidence
   - items not adopted, one line each
   - verification in a new session: what to check for each adopted change. The harness is loaded at session start, so this session cannot show the effect.
5. Reply with the PR URL and tell the user to run the verification in a new session.
