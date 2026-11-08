---
description: Review a specification, design doc, or implementation plan, then revise the document for the confirmed issues and ask only about decisions the document leaves open. Use when the user asks to review such a document.
argument-hint: [document-path-or-url]
---

# spec-review

Review the target document with the `spec-critic-reviewer` agent, verify what it found, then improve the document itself. Write the result in Japanese.

## Target

$ARGUMENTS

Without an argument, use the document the conversation is about. If that is unclear, ask which document.

## 1. Review

Run `spec-critic-reviewer` on the target.

## 2. Verify

For each Critical and Major issue, check the document, and the code or sources it refers to, to confirm or refute it. Drop what does not hold.

## 3. Act

- When the document is a file you can edit, fix in place the confirmed issues that have one right answer: contradictions, undefined terms, missing error cases, vague wording.
- Ask the issues only the document's owner can settle (scope, trade-offs, open questions) in one AskUserQuestion call, recommended option first, each option stating its concrete consequence. Write the answers into the document.
- When the document cannot be edited (a URL, a read-only file), give each change as replacement text instead.

## 4. Report

Keep it short, in Japanese:

- **直したもの**: the section and one line for each edit
- **決めてもらったもの**: each question and where its answer went in the document
- **残したもの**: Minor issues as a count only; list them when asked
