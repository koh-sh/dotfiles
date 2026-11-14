---
description: Review this project's Claude Code harness (CLAUDE.md, AGENTS.md, .claude/, .mcp.json) with Claude Code's own checks and with what the project's past sessions taught (domain knowledge and the user's preferences), then open one PR with the changes the user adopts. Run it after a Claude Code update, as the harness evolves, or after sessions worth learning from.
disable-model-invocation: true
allowed-tools: Bash(claude -p --permission-mode plan *) Bash(${CLAUDE_SKILL_DIR}/scripts/sessions.sh *)
---

# harness-review

Review the project's harness with the same procedure every time: detect issues, apply the changes the evidence settles, ask about the rest, and open one PR. Two kinds of checks feed it. Claude Code's own checks find generic problems. Session learning reads this project's past sessions for what is specific to it: the domain knowledge the user explained and the preferences they showed. Run it after a Claude Code update, when the harness has changed during development, or after sessions that taught Claude something about the project. It is not meant to run on a schedule.

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
4. Session learning, as described below.

### Session learning

1. Run `${CLAUDE_SKILL_DIR}/scripts/sessions.sh collect ${CLAUDE_SESSION_ID}`. It condenses the part of this project's other sessions that earlier reviews have not covered, newest first, into one dialogue file: what the user typed and their answers, rejections and interrupts, with Claude's last reply before each (cut short) and the tools it called in that turn by name, plus the tool calls that were rejected or failed, the errors, and the call right after each error. It prints the file's path and how many sessions it holds. Older sessions that do not fit under the size limit are left out and count as reviewed once marked. The current session is left out, since it is still going on. In the file, each session starts with a `##### SESSION <id>` line. Under it, `=== NEW` is what to review; `=== EARLIER`, when present, is the end of what an earlier review covered, given only as context.
2. Read the dialogue file and this project's auto memory, which is already in context.
3. Look for these signals in the `=== NEW` parts, strongest first:
   1. **Decisions**: the user's answers to AskUserQuestion and to Claude's questions.
   2. **Corrections**: the user correcting Claude, interrupting it, or rejecting a tool call, and what they wanted instead.
   3. **Domain knowledge**: terms, constraints, and the reasons behind them that the user explained.
   4. **Procedures**: steps the user walked Claude through, or that repeat across sessions.
   5. **Recurrence**: a correction or error about something an existing harness rule already covered, meaning the rule did not work.
   6. **Errors**: tool errors and what resolved them, such as the right command, a setup step the project needs, or a path that moved.
4. When sessions disagree, the later one wins. One clear signal is enough for a proposal, but make it only as broad as the evidence: a correction about one module is a rule for that module. Skip:
   - the exchanges of earlier harness-review runs (where `/harness-review` was invoked): what they adopted is already in the harness, and what the user turned down there must not be proposed again
   - one-off instructions that only applied to the task at hand
   - what the harness already says, unless it is a recurrence
   - preferences about the user in general rather than this project; they belong in the user's own config, so list them with the findings outside this repository
   - secrets, credentials and personal details
5. Place each change by what it is:
   - **Project-wide knowledge and preferences**: the CLAUDE.md or AGENTS.md that already holds the project's instructions. Keep it under 200 lines; put what matters only for part of the code in `.claude/rules/<topic>.md` with a `paths:` frontmatter.
   - **Procedures**: a skill at `.claude/skills/<name>/SKILL.md`.
   - **Recurrence**: first rewrite the rule so it is harder to miss, more specific and with its reason. If the rule's history (`git log -p -- <file>`) shows an earlier review already did that, and the rule can be checked mechanically, enforce it with a hook: a script in `.claude/hooks/`, run as `bash "$CLAUDE_PROJECT_DIR"/.claude/hooks/<name>.sh` from `.claude/settings.json`.
   - **Contradictions**: when the user went against an existing rule on purpose, change or remove the rule.

## 4. Proposals

When every check has finished, merge the findings and drop duplicates (session learning and `/insights` often find the same correction or error). Sort each finding by confidence:

- **Apply without asking**: the evidence settles it and the change has one right form, such as a reference to a file or command that no longer exists, a rule that contradicts the code, a `claude plugin validate` error, or a decision or correction the user stated, written at the scope they stated it.
- **Ask**: everything else, including a change that generalizes beyond its evidence, removes or weakens an existing rule, widens permissions, adds a hook, or picks between options.

Report the first group as one line per item: the change and its file. Present the second group as one numbered list. Each item has:

- **What**: the finding, with `file:line`
- **Evidence**: command output or report excerpt; for session learning, the session id and a paraphrase of what the user said or did
- **Proposal**: the concrete change
- **Source**: the check that found it; for session learning, also the signal

The headless checks also cover user-level config and transcripts from every project, so expect many findings outside this repository. List them after the numbered list, without proposals.

Ask which items of the second group to adopt with AskUserQuestion: multiSelect, one option per item, up to 4 options per question and 4 questions per call, and more calls when there are more items.

Once the user has chosen, or right after sorting when nothing needs asking, run `${CLAUDE_SKILL_DIR}/scripts/sessions.sh mark ${CLAUDE_SESSION_ID}`, so the next review starts after what this one covered. Do it even when nothing from session learning was adopted, so turned-down proposals do not come back.

## 5. Apply

1. Apply the first group and the adopted items.
2. Show the full `git diff`.

## 6. Pull request

1. Ask for approval to create the branch, commit, push and open the PR. Do none of these without it.
2. Create `chore/harness-review-<YYYY-MM-DD>` from the current HEAD.
3. Commit each concern separately, following the project's commit conventions.
4. Push and open one PR titled `chore(claude): review harness`, adapted to the project's conventions. The body lists the adopted changes.

   Keep the evidence out of the commit messages and the PR: it comes from the user's sessions, memory and local usage data, which must not become public. For the same reason, leave the items not adopted out of the PR.
5. Reply with the PR URL.
