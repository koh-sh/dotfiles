# review command

Run code review using code and complexity review agents.

Execute the following reviews in parallel:

1. **my-code-reviewer**: Check functionality, performance, best practices, naming
2. **my-complexity-reviewer**: Check over-engineering, DRY violations, deep nesting

After all reviews complete, provide a summary in Japanese:

### コードレビュー結果

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
| my-code-reviewer | my-complexity-reviewer |
|------------------|------------------------|
| X件              | X件                    |

Notes:
- Focus on recently changed code (use git diff)
