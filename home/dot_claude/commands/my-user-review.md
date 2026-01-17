---
description: Open git diff in browser for user to review changes visually
allowed-tools: Bash(npx difit:*), Bash(git diff:*), Bash(git branch:*), Bash(git remote:*)
argument-hint: [自然言語での指示（例: mainとの差分を表示して）]
---

# my-user-review command

Open git diff in browser using difit for visual code review.

User provides instructions in natural language. Interpret and execute the appropriate difit command.

## difit command reference

| Command | Description |
|---------|-------------|
| `npx difit .` | All uncommitted changes (staged + unstaged) |
| `npx difit staged` | Staged changes only |
| `npx difit working` | Unstaged changes only |
| `npx difit @ <branch>` | Compare HEAD with specified branch |
| `npx difit <ref1> <ref2>` | Compare two refs |
| `npx difit HEAD~N` | Show last N commits |

## Default behavior (no arguments)

1. Check for uncommitted changes (including untracked files): `git status --porcelain`
2. If changes exist: Run `npx difit .`
3. If no changes, get current branch: `git branch --show-current`
4. Get default branch: `git remote show origin | grep 'HEAD branch' | sed 's/.*: //'`
5. If current branch != default branch: Run `npx difit @ <default-branch>`
6. Otherwise: Inform user there's nothing to review

## Examples of natural language instructions

- "mainとの差分を表示して" → `npx difit @ main`
- "直近3コミットの差分を見せて" → `npx difit HEAD~3`
- "ステージ済みの変更だけ見たい" → `npx difit staged`
- "developブランチと比較" → `npx difit @ develop`
- "featureとmainの差分" → `npx difit feature main`

$ARGUMENTS
