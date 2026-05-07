---
description: Fact-check a previous assistant output and produce a corrected, evidence-backed version. Triggers on "verify", "fact-check", "double-check", "確認して", "検証して".
disable-model-invocation: true
argument-hint: [target: defaults to the immediately preceding assistant message]
---

# my-ai-fact-check

Fact-check a prior assistant output by re-reading code, consulting authoritative sources, and running safe checks. Replace speculation with evidence and return a **corrected version of the original output**, not just a verdict.

## Target

$ARGUMENTS

If empty, treat the **immediately preceding assistant message** as the target. If no prior assistant output exists, ask what to verify and stop.

## Workflow

1. **Extract atomic claims** from the target. Keep each claim independently checkable (one API signature, one file behavior, one version number, etc.). Do not paraphrase away nuance.

2. **Verify each claim** using the highest-confidence method available, in this priority order:
   - **(A) Code reading** — for claims about this repo or readable dependencies. Re-read files end-to-end with Read / Grep / Glob. Do not rely on memory or earlier excerpts.
   - **(B) Web research** — for claims about external libraries, languages, APIs, specs. Source priority: official docs → official repo (README, source, releases, issues) → reputable references. Discard blog/AI-generated content that contradicts primary sources.
   - **(C) Command / script execution** — when a check can settle a claim (e.g., `--version`, `--help`, a focused test, a one-liner).
     - **Auto-run (read-only):** `ls`, `grep`, `git status`, `git diff`, `git log`, `--version`, `--help`, file reads.
     - **Approval required (any side effect):** writes/deletes, git mutations, network calls with effects, sudo, anything with non-trivial blast radius. STOP and ask before running. Auto mode does not waive this.
     - Never chain commands with `&&` (project rule).
   - **(D) Other means** — type checks, linters, dry-runs, sandbox repros. Same approval gate as (C).

3. **Record evidence** for every claim: file:line, URL, or `command` + output snippet — specific enough that the user can re-verify independently.

4. **Classify each claim**: `Verified`, `Refuted` (with the corrected fact), or `Unverified` (with the reason — inaccessible source, denied approval, no authoritative info, etc.). Never silently mark an unchecked claim as Verified.

5. **Rewrite the original output** incorporating refutations and unverified flags. This rewritten version is the primary deliverable.

## Output Format

### Corrected Output

> Rewrite the original assistant output with all refuted claims fixed in place. Preserve the original's structure, voice, and level of detail as much as possible — only change what evidence requires changing. For any `Unverified` claim that remains, mark it inline with `[unverified: <one-line reason>]` so the reader sees uncertainty in context. If the original was fully correct, restate it verbatim and say "no changes" under Changes.

### Changes

> Bulleted list of every modification made above versus the original. Each bullet: what changed, why, and the evidence (file:line / URL / command). Group as `Refuted` (corrections) and `Unverified` (uncertainty added). If empty, write `- None — original output was fully verified.`

### Verification Log

> One row per claim. Compact table:
>
> | # | Claim (short) | Method | Evidence | Result |
> |---|---------------|--------|----------|--------|
> | 1 | ...           | A/B/C/D | `file:line` or URL or `cmd` | Verified / Refuted / Unverified |

### Pending Approvals

> List any verification step skipped because it required user approval and was not granted, or risky checks worth running next. Format: `- <what to run> — <what it would settle>`. If none, write `- None`.

### Summary

> One-line overall assessment, then counts:
>
> | Verified | Refuted | Unverified |
> |----------|---------|------------|
> | X        | X       | X          |

## Notes

- The **Corrected Output** section is the primary deliverable. Do not skip it, even when nothing changed (restate verbatim and note "no changes").
- New questions surfaced during verification become additional claims — verify them too, or list under Unverified with a reason.
- Web research: cite primary sources only. Do not adopt secondhand or contradicting non-official info.
- Risk gate is hard: any side-effect command needs explicit user approval per invocation, even under auto mode.
- Do not promote ambiguous findings to `Verified`. When in doubt, classify as `Unverified` and explain.
