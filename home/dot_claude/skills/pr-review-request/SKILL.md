---
name: pr-review-request
description: Review a pull request you were asked to review, for the sessions pr-review-check opens - a reading guide and the decisions left to you first, then verified findings as Conventional Comments. Posts nothing to GitHub. Pass the PR URL.
argument-hint: <PR URL>
disable-model-invocation: true
---

Review $ARGUMENTS. The working directory is a worktree of the PR's latest head. Do not post anything to GitHub, and do not run the PR's code (tests, builds, scripts), subagents included: read it. Write the result in Japanese.

## 1. Context

- Read the PR: description, linked issues, diff, and CI status (`gh pr checks`). Read the repository's own guidance (CLAUDE.md, CONTRIBUTING, review guidelines) where present.
- It is a re-review when you (`gh api user --jq .login`) have reviewed this PR before. Then review the changes since the commit of your latest review, and collect your earlier review threads to see how each was answered.
- Pick the review depth from the changes under review:
  - Count only substantive lines. Leave out generated code, lock files, formatter or lint autofixes, renames and moves, and the same transformation applied in many places. Check that such a change is uniform in every hunk; a hunk that departs from the pattern counts as substantive.
  - **Deep**: over 400 substantive lines, or it adds a new module, external interface, permission, schema or dependency. **Light**: up to 100 substantive lines and adds none of those. **Standard**: everything else.

## 2. Find problems

Pick the lenses the change touches, always including spec conformance:

| Lens | Look for |
|---|---|
| Spec conformance | the change does what the description and linked issues say; nothing missing or contradicting |
| Security | authentication and authorization, input handling, secrets, permissions |
| Data | migrations, deletes, backfills, anything that cannot be rolled back |
| Concurrency | races, ordering, retries, idempotency |
| Error handling | swallowed errors, silent fallbacks, missing timeouts |
| Compatibility | API, schema, config and CLI contracts that other code depends on |
| Blast radius | IaC, CI, deploy and permission changes: what breaks if this is wrong |

Look for problems in each picked lens that would block the merge, with file:line evidence, and for non-blocking points in the rest. At Light and Standard depth, do all of it yourself. At Deep depth, run one subagent per picked lens in parallel on Sonnet (`model: sonnet`) for the blocking problems, and look for the non-blocking points yourself.

## 3. Verify

Try to refute each candidate `issue` and `suggestion` against the actual code. At Light depth do it yourself; otherwise hand all candidates to one subagent, so they are not checked by whoever found them. Drop what is refuted, turn what can be neither confirmed nor refuted into a `question`, and merge duplicates.

## 4. Labels

Use [Conventional Comments](https://conventionalcomments.org/) labels, with the lens as a decoration (e.g. `issue (blocking, security)`):

| Label | When |
|---|---|
| `issue (blocking)` | outage, data loss or corruption, security hole, a change that cannot be rolled back, a contradiction of the spec; only with confirmed evidence |
| `issue (non-blocking)` | a real problem that does not need to stop the merge |
| `suggestion (non-blocking)` | a maintainability or readability improvement |
| `question` | suspicious but unconfirmed: ask instead of asserting |
| `nitpick (non-blocking)` | taste; reported as a count only |
| `praise` | at most one, only when genuinely notable |

No findings is a valid result. Do not add findings to fill the list.

## 5. Output

Use these sections, in this order:

1. **概要**: what changes and why, in three lines (for a re-review, what changed since your last review).
2. **読む順番**: the changed files in reading order, one line each on its role. Mark the ones that only need a skim (generated code, lock files, mechanical changes).
3. **あなたが決めること**: at most three decisions only you can make, each with a recommendation and its reason.
4. **指摘**: numbered, ordered `issue (blocking)` → `issue (non-blocking)` → `suggestion` → `question`. Each as `<label> [decorations]: <subject>`, with its file:line evidence and whether verification confirmed it. Nitpicks as a count only (list them when asked).
5. **ラリーの状況** (re-review only): a table of your earlier threads: point / what you asked / their answer / state (agreed, open, fixed in code) / next step.
6. **確認状況**: CI status, the review depth picked and why, what verification covered, and what was not checked.
7. The PR URL, to open in the browser.

## 6. Pick what to post

Ask which findings to post (AskUserQuestion with multiple selection when they fit, otherwise by number). Then write only the picked ones as ready-to-paste GitHub comments: the file:line each attaches to, and the comment in Conventional Comments form, short and specific, without verification notes. Findings that were not picked are not written in that form.
