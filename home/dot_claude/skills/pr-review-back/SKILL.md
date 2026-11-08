---
name: pr-review-back
description: Work through new reviews on your own pull request, for the sessions pr-review-check opens - the state of every thread first, then a fix-or-reply plan per point and ready-to-paste replies for the ones you pick. Changes no code and posts nothing to GitHub. Pass the PR URL.
argument-hint: <PR URL>
disable-model-invocation: true
---

$ARGUMENTS is your own PR (you are `gh api user --jq .login`). Read the reviews submitted after your latest commit, review or comment on it, inline comments included, and work out how to answer them. Do not change code and do not post anything to GitHub. Write the result in Japanese.

## 1. Check each point

Before deciding how to answer a point, check it against the actual code: is the reviewer right, partly right, or mistaken? Use a subagent per point when there are many. Keep the reviewer's Conventional Comments labels when they used them; points from a CHANGES_REQUESTED review or with a `blocking` decoration go first.

## 2. Output

Use these sections, in this order:

1. **概要**: who reviewed, how many points, and what they ask for overall.
2. **スレッドの状況**: a table of every open thread on the PR, earlier ones included: point / the reviewer's ask / what you said so far / state (agreed, open, fixed in code) / proposed action (fix the code or reply) and why.
3. **あなたが決めること**: at most three points where the ask conflicts with the design or needs your judgment, each with a recommendation and its reason.
4. **対応案**: for each point, the fix (what to change, where) or the reply draft.
5. **繰り返しそうな指摘**: points that show a pattern you (Claude) are likely to repeat in other changes, not something specific to this PR. For each, a one-line rule to add to the `## Code Style` section of the user-level CLAUDE.md or to the `design-reviewer` agent, and why. Propose only; the user applies it in their dotfiles. Leave the section out when there are none.
6. The PR URL, to open in the browser.

## 3. Pick what to send

Ask which proposed actions to take (AskUserQuestion with multiple selection when they fit, otherwise by number). Then write the replies for the picked ones ready to paste, each with the thread it answers.
