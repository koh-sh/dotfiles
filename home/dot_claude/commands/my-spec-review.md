# spec-review command

Run specification/document review with verification workflow.

## Workflow

1. **Execute spec-critic-reviewer** agent to review the target document
2. **Verify findings**: For each Critical and Major issue reported:
   - Investigate whether the issue is valid
   - Check the actual document/code to confirm or refute the claim
3. **Generate improvement suggestions**: For confirmed valid issues only:
   - Provide concrete improvement recommendations
   - Include specific text or structure changes where applicable

## Target Document

$ARGUMENTS

## Output Format

### 確認された課題と改善案

For each verified valid issue (Critical first, then Major):

---

**[Issue Title]** `Critical` / `Major`

**問題点**: [Description of the issue]

**改善案**: [Specific suggestion for improvement]

**変更例**:
```
[Concrete example of improved text/structure]
```

---

(Repeat for each valid issue)

### サマリー

- **Critical**: X件
- **Major**: X件
- **推奨アクション**: [Next steps]
