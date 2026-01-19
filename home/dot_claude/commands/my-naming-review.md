# naming-review command

Run naming convention and code style review using the naming-style-reviewer agent.

## Workflow

1. **Execute review agent**:
   - **my-naming-style-reviewer**: Check naming conventions and code style consistency

2. **Verify findings**: For each [高] and [中] priority issue reported:
   - Investigate whether the issue is valid
   - Check the actual code to confirm or refute the claim
   - Verify against both language standards AND existing codebase patterns
   - Discard false positives

3. **Generate summary**: For confirmed valid issues only, provide a summary in Japanese:

### 命名・スタイルレビュー結果

**対応事項**:

[高]
1. **[問題タイトル]** - `file:line`
   - 現状: `current_name` / current_style
   - 推奨: `suggested_name` / suggested_style
   - 理由: [言語標準 or コードベース慣例]

[中]
1. **[問題タイトル]** - `file:line`
   - 現状: `current_name` / current_style
   - 推奨: `suggested_name` / suggested_style
   - 理由: [言語標準 or コードベース慣例]

[低]
1. **[問題タイトル]** - `file:line`
   - 現状: `current_name` / current_style
   - 推奨: `suggested_name` / suggested_style
   - 理由: [言語標準 or コードベース慣例]

**トレードオフが必要な項目** (ユーザ判断が必要):

1. **[問題タイトル]** - `file:line`
   - 既存パターン: [codebase convention]
   - 言語標準: [language standard]
   - 選択肢A: [Follow codebase - pros/cons]
   - 選択肢B: [Follow standard - pros/cons]

**検出件数**: X件

Notes:
- Focus on recently changed code (use git diff)
- Default to following existing codebase conventions
- Flag trade-offs for user decision when codebase conventions are problematic
