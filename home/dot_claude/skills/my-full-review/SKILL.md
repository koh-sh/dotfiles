---
description: Run comprehensive code review using all specialized review agents
disable-model-invocation: true
argument-hint: [scope: file path or directory (defaults to git diff)]
---

# my-full-review

Run comprehensive code review using all specialized review agents.

## Review Scope

$ARGUMENTS

If no scope specified, use `git diff` to identify recently changed code.

## Workflow

1. **Execute review agents** in parallel:
   - **my-code-reviewer**: Check functionality, performance, best practices, naming
   - **my-complexity-reviewer**: Check over-engineering, DRY violations, deep nesting
   - **my-responsibility-reviewer**: Check separation of concerns, misplaced logic, reinvented utilities, abstraction level
   - **my-security-reviewer**: Check OWASP Top 10, auth, input validation
   - **my-test-reviewer**: Check test structure, meaningful tests, coverage
   - **my-doc-sync-reviewer**: Check README accuracy, documentation completeness
   - **my-naming-style-reviewer**: Check naming conventions and code style consistency

2. **Verify findings**: For each [高] and [中] priority issue reported:
   - Investigate whether the issue is valid
   - Check the actual code/tests/docs to confirm or refute the claim
   - Discard false positives

3. **Generate summary**: For confirmed valid issues only, provide a summary in Japanese:

### 総合レビュー結果

**対応事項**:

[高]
1. **[問題タイトル]** - `file:line` (my-xxx-reviewer)
   - 問題: [何が問題か]
   - 推奨: [どう修正すべきか]

[中]
1. **[問題タイトル]** - `file:line` (my-xxx-reviewer)
   - 問題: [何が問題か]
   - 推奨: [どう修正すべきか]

[低]
1. **[問題タイトル]** - `file:line` (my-xxx-reviewer)
   - 問題: [何が問題か]
   - 推奨: [どう修正すべきか]

**検出件数**:
| my-code-reviewer | my-complexity-reviewer | my-responsibility-reviewer | my-security-reviewer | my-test-reviewer | my-doc-sync-reviewer | my-naming-style-reviewer |
|------------------|------------------------|----------------------------|----------------------|------------------|----------------------|--------------------------|
| X件              | X件                    | X件                        | X件                  | X件              | X件                  | X件                      |

Notes:
- Focus on recently changed code (use git diff)
- Missing tests or outdated docs should be flagged as issues
- For my-responsibility-reviewer findings, do NOT collapse the multiple options into a single 推奨. Keep the trade-off structure: present the 課題 (with concrete downside) and list the options (案A / 案B / ...) with their pros and cons. If space is tight in the summary, give a one-line option summary and refer the user to the agent's original output for the full trade-off analysis.
- In the detection count table, my-responsibility-reviewer counts each 課題 (trade-off unit) as 1, where a single 課題 contains multiple options (案A / 案B / ...). Note that this granularity differs from other reviewers, where 1 finding corresponds to 1 fix.
