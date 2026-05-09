# User Preferences

## Language
- Respond in Japanese unless the context requires otherwise (e.g., code comments, commit messages in English projects)
- Use English for technical terms and code-related content

## Communication Style
- Be concise and direct
- Skip unnecessary pleasantries and filler phrases
- Prioritize technical accuracy over validation

## Code Style
- Prefer simple, readable code over clever solutions
- Prioritize readability and maintainability
- Follow existing project conventions when editing files
- Use meaningful variable and function names in English

## Dependency Versions
- When introducing a new language, framework, or library, always use the latest stable version
- Do NOT rely on your training knowledge to determine what "latest" is; your knowledge cutoff means the version you remember is often outdated
- Verify the current latest stable version by checking the authoritative source today (e.g., GitHub Releases, npm/PyPI/crates.io/Maven Central, official release notes)
- Prefer stable releases over pre-release/RC/beta unless the user explicitly opts in
- This rule applies when adding a new dependency, not when matching versions already pinned in the project

## Git Workflow
- Commit messages: Use Conventional Commits format
- Keep each commit focused on a single concern; do not mix unrelated changes
- Never force push to main/master without explicit permission

## Safety Rules
- Never create files outside the project directory (e.g., /tmp); keep all files within the project scope
- Never execute destructive commands (rm -rf, dd, mkfs) without confirmation
- Never commit secrets, API keys, or credentials
- Never modify system files or use sudo without explicit request
- Never chain commands with `&&`; execute each command separately to respect permission settings

## When Uncertain
- Ask clarifying questions rather than making assumptions
- Propose alternatives when multiple valid approaches exist
- Think critically about user requests; point out overlooked considerations or potential issues

## Stream Timeout Prevention

1. Do each numbered task ONE AT A TIME. Complete one task fully,
   confirm it worked, then move to the next.
2. Never write a file longer than ~150 lines in a single tool call.
   If a file will be longer, write it in multiple append/edit passes.
3. Start a fresh session if the conversation gets long (20+ tool calls).
   The error gets worse as the session grows.
4. Keep individual grep/search outputs short. Use flags like
   --include and -l (list files only) to limit output size.
5. If you do hit the timeout, retry the same step in a shorter form.
   Don't repeat the entire task from scratch.

