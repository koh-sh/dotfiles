# full-review command

Run comprehensive code review using all specialized review agents.

## Workflow

1. **Execute review agents** in parallel:
   - **my-code-reviewer**: Check functionality, performance, best practices, naming
   - **my-complexity-reviewer**: Check over-engineering, DRY violations, deep nesting
   - **my-security-reviewer**: Check OWASP Top 10, auth, input validation
   - **my-test-reviewer**: Check test structure, meaningful tests, coverage
   - **my-doc-sync-reviewer**: Check README accuracy, documentation completeness

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
| my-code-reviewer | my-complexity-reviewer | my-security-reviewer | my-test-reviewer | my-doc-sync-reviewer |
|------------------|------------------------|----------------------|------------------|-----------------|
| X件              | X件                    | X件                  | X件              | X件             |

Notes:
- Focus on recently changed code (use git diff)
- Missing tests or outdated docs should be flagged as issues
