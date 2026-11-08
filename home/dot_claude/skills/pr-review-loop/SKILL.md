---
name: pr-review-loop
description: Every 10 minutes, open a WezTerm pane running a Claude Code session for each newly requested PR review and for each new review-back on your own PRs. Pass the GitHub org(s) as arguments.
argument-hint: <org> [<org>...]
disable-model-invocation: true
model: sonnet
---

Invoke the `loop` skill with args `10m /pr-review-check $ARGUMENTS`.

Each check runs as the `pr-review-check` skill rather than a plain prompt so its `model: sonnet` applies to every scheduled run; a plain prompt would run on the session's model.
