# spec-review command

Run specification/document review with verification workflow.

## Workflow

1. **Execute spec-critic-reviewer** agent to review the target document
2. **Verify findings**: For each Critical and Major issue reported:
   - Investigate whether the issue is valid
   - Check the actual document/code to confirm or refute the claim
3. **Generate improvement suggestions**: For confirmed valid issues:
   - Provide concrete improvement recommendations
   - Include specific text or structure changes where applicable

## Target Document

$ARGUMENTS

## Output Format

### 1. spec-critic-reviewer実行結果

[Run the agent and include the full review output here]

---

### 2. 指摘事項の検証

#### 致命的な問題 (Critical Issues) の検証

| # | 問題 | 検証結果 | 根拠 |
|---|------|----------|------|
| 1 | [issue] | ✅ 正当 / ❌ 誤検知 / ⚠️ 部分的に正当 | [evidence] |

#### 重要な問題 (Major Issues) の検証

| # | 問題 | 検証結果 | 根拠 |
|---|------|----------|------|
| 1 | [issue] | ✅ 正当 / ❌ 誤検知 / ⚠️ 部分的に正当 | [evidence] |

---

### 3. 改善案

#### 対応が必要な指摘

**[Issue Title]** (Critical/Major)
- 現状: [current state in document]
- 改善案: [specific suggestion for improvement]
- 変更例:
  ```
  [concrete example of improved text/structure]
  ```

---

### 4. サマリー

| 区分 | 指摘数 | 正当 | 誤検知 |
|------|--------|------|--------|
| Critical | X | X | X |
| Major | X | X | X |

**アクション**: [次のステップの推奨]
