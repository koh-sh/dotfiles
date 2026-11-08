---
name: pr-review-check
description: One pass of pr-review-loop (run by its scheduled loop) - open a WezTerm pane running a Claude Code session for each newly requested PR review and for each new review-back on your own PRs. Pass the GitHub org(s) as arguments.
argument-hint: <org> [<org>...]
model: sonnet
---

Each pass runs the two checks below. Both open their sessions the same way:

- From the existing clone at ~/github/<repo>, create a worktree of the PR's latest head at ~/worktrees/<repo>/pr-<number> (update it if it already exists). If there is no clone, do not start anything; just report it.
- Start the session with: wezterm cli spawn --cwd <worktree> -- env $(env | grep -o '^CLAUDE_CODE_[A-Z_]*' | sed 's/^/-u /') claude --model opus "<prompt>"
## 1. Review requests

Check review requests with `gh search prs "user-review-requested:@me" --state=open <ORGS> --draft=false --updated=">=$(date -v-7d +%F)"`, replacing `<ORGS>` with one `--owner=<org>` per org in "$ARGUMENTS", and for each PR that was not there at the previous check (all of them on the first run), open a session with the prompt `/pr-review-request <PR URL>`.

`user-review-requested:` matches only reviews requested from you personally; `--review-requested` would also match requests to every team you belong to (e.g. CODEOWNERS auto-assignments).

## 2. Review-backs on your own PRs

List your open PRs that have reviews you have not answered yet, replacing `<ORGS>` with one `org:<org>` per org in "$ARGUMENTS":

```bash
gh api graphql -f q="is:pr is:open author:@me archived:false <ORGS> updated:>=$(date -v-7d +%F)" -f query='
query($q: String!) {
  viewer { login }
  search(query: $q, type: ISSUE, first: 50) {
    nodes {
      ... on PullRequest {
        url
        isDraft
        commits(last: 1) { nodes { commit { committedDate } } }
        comments(last: 50) { nodes { author { login } createdAt } }
        reviews(last: 50) { nodes { id author { login __typename } state submittedAt } }
      }
    }
  }
}' --jq '
.data.viewer.login as $me
| .data.search.nodes[]
| select(.isDraft | not)
| ([.commits.nodes[].commit.committedDate]
   + [.reviews.nodes[] | select(.author.login == $me) | .submittedAt]
   + [.comments.nodes[] | select(.author.login == $me) | .createdAt]
  | max) as $mine
| {url, new: [.reviews.nodes[] | select(.author.login != $me and .author.__typename != "Bot" and .submittedAt > $mine) | {id, author: .author.login, state, submittedAt}]}
| select(.new | length > 0)'
```

A review counts as unanswered when it was submitted after your latest commit, review, or comment on the PR (the ball is on your side), so restarting the loop never reopens PRs you already answered. Only reviews are checked, not issue comments, since bots (e.g. plan notifications) post those; inline review comments belong to a review, so they are covered.

Handle each listed PR whose newest review id was not already handled at a previous check:

- If any listed review is COMMENTED or CHANGES_REQUESTED, open a session with the prompt `/pr-review-back <PR URL>`.

- If every listed review is APPROVED, do not open a session; just report the PR and its approvers.

## Notes

What a session does lives in the `pr-review-request` and `pr-review-back` skills, which the prompt invokes. They must be user-level skills (in ~/.claude/skills): a session's working directory is the PR's worktree in another repository, where this repository's project skills are not loaded.

The spawned pane inherits this session's environment, so the `env -u` strips every `CLAUDE_CODE_*` variable to start the session as an independent one; otherwise it inherits `CLAUDE_CODE_CHILD_SESSION` and its transcript is not saved.

This check runs on Sonnet (`model: sonnet`) while the sessions pin `--model opus`, so the session model never follows the loop's or the user's default model. Do not add `disable-model-invocation` here: it would stop the scheduled loop from running this skill.
