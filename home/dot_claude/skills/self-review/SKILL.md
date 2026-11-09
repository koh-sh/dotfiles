---
description: Review a code change for over-engineering, misplaced or re-implemented logic, naming drift, and docs or tests left behind, then fix what has one right answer and ask only about judgment calls. Use right after finishing a code change, before reporting it as done, and when the user asks to review their own code changes. Not for someone else's pull request.
argument-hint: [scope: path, commit range, or your own PR (defaults to the unreviewed changes of this session)]
---

# self-review

Review a code change the way a reviewer outside this session would, then act on the result: fix what has one right answer, ask only about what reasonable engineers could disagree on, and report what changed. Write the result in Japanese.

## Scope

$ARGUMENTS

Without an argument, review the code changes this session made since its last self-review (all of them when there was none). When the session made no changes, review `git diff HEAD` and, on a branch other than the default branch, the commits not yet on it. Skip the review when the scope changes docs only.

Bugs and security are out of scope here. The user runs `/code-review low` or `/security-review` for those; do not invoke them from this skill.

## 1. Run two checks in parallel

- **Design**: start the `design-reviewer` agent with the scope (paths or diff range) and one line on what the change is for. Do not pass your reasoning about the design: the reviewer judges the code, not the intent behind it.
- **Sync**: while it runs, check yourself what the change left behind.
  - Docs: list the names, commands, paths, options and behaviors the diff adds, changes or removes. Grep the docs and agent instruction files (README*, docs/, CLAUDE.md, AGENTS.md, .claude/) for each, and note every statement that no longer matches the code.
  - Tests: for each changed function or behavior, find the tests that exercise it. Note behavior changes with no test and tests that still describe the old behavior.

## 2. Verify

Open the code at each finding's `file:line` and drop findings whose premise does not hold: the "existing helper" does not exist or does something else, sibling files do not follow the "convention", the case "that cannot occur" can occur. If the reviewer reported nothing on a large change, scan the diff yourself for new helpers, new public methods on existing types, and new cross-module imports.

## 3. Act

Sort every remaining finding:

- **Fix**: it has one right answer within the scope (reuse the existing helper, remove the unneeded option, rename to the local convention, update the stale doc line, add the missing test). Apply it.
- **Ask**: reasonable engineers could disagree (where a responsibility belongs, codebase convention versus language standard, whether to extract now). Ask all of them in one AskUserQuestion call, recommended option first, each option stating its concrete consequence. Apply the answers.
- **Drop**: taste with no concrete cost. Do not report it.

Fix once. Do not review your own fixes again; run the project's tests or checks when the fixes touched code.

## 4. Report

Keep it short, in Japanese:

- **直したもの**: one line each, with `file:line`
- **決めてもらったもの**: each question and the answer applied
- **確認できなかったこと**: what was not checked and why (for example, the repository has no tests)

When nothing was found, say so in one line. Then continue with the report of the original task.
