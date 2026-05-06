---
description: Review an action, idea, design, or program against the ACM/IEEE-CS Software Engineering Code of Ethics (8 principles) and report issues with should-be guidance
disable-model-invocation: true
argument-hint: [target: file, URL, or description]
---

# my-ethics-review

Review the target (action, idea, design, or program) against the **ACM/IEEE-CS Software Engineering Code of Ethics and Professional Practice (Version 5.2)** and report ethical concerns with concrete should-be guidance.

## Review Target

$ARGUMENTS

If no target is specified, infer it from recent conversation context. If still unclear, ask one focused clarifying question before proceeding.

## Eight Principles

Evaluate the target against each of the following principles. The PUBLIC interest is paramount and overrides the others when in conflict.

1. **PUBLIC** — Software engineers shall act consistently with the public interest. Consider safety, health, privacy, environment, and the welfare of all affected.
2. **CLIENT AND EMPLOYER** — Software engineers shall act in a manner that is in the best interests of their client and employer consistent with the public interest. Includes confidentiality, conflicts of interest, and honest reporting.
3. **PRODUCT** — Software engineers shall ensure that their products and related modifications meet the highest professional standards possible. Includes quality, testing, documentation, and honest cost/schedule estimates.
4. **JUDGMENT** — Software engineers shall maintain integrity and independence in their professional judgment. Avoid bribery, distorted incentives, and unsubstantiated claims.
5. **MANAGEMENT** — Software engineering managers and leaders shall subscribe to and promote an ethical approach to the management of software development and maintenance. Includes fair labor conditions, realistic estimates, and a healthy process.
6. **PROFESSION** — Software engineers shall advance the integrity and reputation of the profession consistent with the public interest. Do not condone illegal or unethical practice.
7. **COLLEAGUES** — Software engineers shall be fair to and supportive of their colleagues. Includes proper credit, constructive criticism, and respect for competence.
8. **SELF** — Software engineers shall participate in lifelong learning regarding the practice of their profession and shall promote an ethical approach to the practice of the profession. Recognize the limits of your own competence.

## Workflow

1. **Understand the target**
   - For files: read the relevant code or document.
   - For ideas or actions: clarify scope, stakeholders, and intended outcome.
   - Identify affected parties (public, users, client, colleagues, self).

2. **Evaluate against each principle**
   - For each of the 8 principles, ask: "Does this target violate or fail to consider this principle?"
   - Look for both explicit violations and silent omissions (missing safety consideration, missing consent, exaggerated claims, etc.).

3. **Classify findings by severity**
   - `Critical` — Direct risk to public safety, health, or welfare; legal violation; severe rights infringement.
   - `High` — Clear ethical violation. Should not proceed without resolution.
   - `Medium` — Notable concern. Mitigation or discussion is required.
   - `Low` — Minor concern or improvement opportunity.

4. **Verify before reporting**
   - Ground each finding in specific content of the target, not speculation.
   - Discard false positives produced by forcing the code onto unrelated content.

5. **Propose the should-be state**
   - For each finding, describe the ideal state under compliance and a concrete remediation action.

## Output Format

### Ethics Review — <Target one-line description>

**Verdict**: `PASS` | `PROCEED` | `REVISE` | `BLOCK` — <one-sentence rationale>
**Severity counts**: Critical X · High X · Medium X · Low X

Verdict mapping:
- `PASS` — No findings.
- `PROCEED` — Only Low/Medium findings; safe to continue with awareness.
- `REVISE` — High findings present; resolve before proceeding.
- `BLOCK` — Critical findings present; do not proceed without fundamental change.

---

#### Findings

Order by severity (Critical → High → Medium → Low). If none, write `No findings across all 8 principles.` and skip the remaining subsections of this section.

**Principle N — NAME** · `Severity`

- **Issue** — What is wrong, and which clause or spirit of the principle it violates.
- **Impact** — Who is harmed and what risk is incurred.
- **Should-be** — The ideal state if the principle were upheld.
- **Remediation** — Concrete action with priority and responsible party.

(Repeat for each finding.)

---

#### Coverage

Single line: `Findings in: <principle numbers> · Clean: <principle numbers>`

If any principle was excluded as N/A because it was outside the scope of the target, add one line: `N/A: <numbers> — <brief reason>`.

---

#### Recommended Next Steps

Numbered list, 1–3 items, ordered by priority. Each item: a concrete action and which finding it resolves (e.g., `1. Add explicit consent flow before data collection — resolves Finding on Principle 1.`).

Omit this section entirely when the Verdict is `PASS`.

## Notes

- Reference: ACM/IEEE-CS Software Engineering Code of Ethics and Professional Practice (Version 5.2) — https://www.acm.org/code-of-ethics/software-engineering-code
- Flag ethical issues even when the code or design is technically sound.
- Avoid scope creep: pure technical preferences and style belong to other review skills (e.g., `my-review`). This skill focuses solely on the ethics axis.
- When there are no findings, do not manufacture issues. State `No findings.` explicitly.
