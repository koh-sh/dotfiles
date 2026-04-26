---
description: Run responsibility / separation-of-concerns review using the responsibility-reviewer agent, then re-evaluate findings
disable-model-invocation: true
argument-hint: [scope: file path or directory (defaults to git diff)]
---

# my-responsibility-review

Run responsibility / separation-of-concerns review using `my-responsibility-reviewer`, then **re-evaluate the agent's findings** before presenting to the user.

The agent owns the output format. The skill owns the verification step. Do not redefine the output structure here — see the agent definition for the full format (課題 / 関連コード / 選択肢 / 判断材料 / 総合所感).

## Review Scope

$ARGUMENTS

If no scope specified, use `git diff` to identify recently changed code.

## Workflow

### 1. Invoke the agent

Run `my-responsibility-reviewer` against the specified scope. Pass the scope (file path / directory / git diff range) through faithfully.

### 2. Re-evaluate the agent's findings

For each 課題 returned, run the following checks. Use Grep / Glob / Read directly — do not delegate the verification back to the agent.

- **Validity check** — Re-search the codebase to confirm the agent's premises hold:
  - Claims of "no existing utility" → run grep/glob to verify
  - Claims of "convention says X" → check 2–3 sibling files
  - Claims of "this is duplicated at `path:line`" → open both locations and confirm
  - Discard 課題 whose premises don't hold up

- **Option sanity-check** — For each 案 (A / B / ...) within a 課題:
  - Verify the cited メリット / デメリット against the actual codebase
  - Flag any pro/con that is speculative, contradicted by the code, or assumes facts not in evidence
  - If a stated trade-off is wrong, correct it; if uncertain, mark it explicitly

- **Coverage check** — Look for plausibly-missed 課題:
  - If the agent's response is short relative to the change size, scan the diff for: new helper functions (potential reinvention), new public methods on existing classes (potential responsibility creep), new cross-module imports (potential boundary issue)
  - If you find one the agent missed, add it as an additional 課題 in the agent's format

- **Judgment-axis check** — For each 判断材料:
  - Verify the axis maps to evidence the user can actually evaluate (e.g. "if this pattern repeats" — is there a second occurrence already?)
  - Add concrete signals from the codebase that tilt the decision toward one option, where possible

### 3. Present the result

- Pass through the agent's output **in its original format**.
- For 課題 you modified during re-evaluation, prefix with a note so the user can see what changed:
  - `[skill検証で追加]` — coverage check で追加した課題
  - `[skill検証で削除: <理由>]` — validity check で前提が崩れた課題（削除した旨と理由のみ表示し、課題本体は出さない）
  - `[skill検証で修正: <箇所>]` — option sanity-check や judgment-axis で記述を修正した課題

- Append a short skill-level note at the very end:

### スキル検証ノート

- 削除した課題: X件 (理由: ...)
- 追加した課題: X件
- 修正した選択肢 / 判断材料: X件
- 検証の信頼度: 高 / 中 / 低
  - 高: コードベース横断のgrep/globで関連箇所を一通り確認できた
  - 中: 主要箇所は確認したが、一部の前提は未検証
  - 低: 探索範囲が限定的で、見落としの可能性がある

## Notes

- The agent owns the output format; the skill owns the verification. Do not restructure or collapse the agent's trade-off output.
- If verification reveals the agent missed a critical area, do not silently patch it — surface it transparently via `[skill検証で追加]`.
- The verification step is the value-add of invoking the reviewer through this skill rather than calling the agent directly. Take it seriously.
- Focus verification on `[高]` and `[中]` 課題. For `[低]`, a lighter sanity-check is acceptable.
