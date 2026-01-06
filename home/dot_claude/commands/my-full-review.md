# full-review command

Run comprehensive code review using all specialized review agents.

Execute the following reviews in parallel:

1. **my-code-reviewer**: Check functionality, performance, best practices, naming
2. **my-complexity-reviewer**: Check over-engineering, DRY violations, deep nesting
3. **my-security-reviewer**: Check OWASP Top 10, auth, input validation
4. **my-test-reviewer**: Check test structure, meaningful tests, coverage
5. **my-doc-sync-reviewer**: Check README accuracy, documentation completeness

After all reviews complete, provide a summary in Japanese:

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
