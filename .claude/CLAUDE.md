@~/.agents/AGENTS.md

## General Principles
- Before making edits or running commands, explain your plan and wait for confirmation. Don't jump into code changes without discussing the approach first.
- When I ask about something, start with the simplest interpretation. Don't over investigate code, run bash commands, or make edits unless I explicitly ask for changes.
- Don't add extra features, examples, or embellishments beyond what I ask for. Keep changes minimal and scoped to the request.

- Install dependencies (including dev tools like `pytest`, `ruff`, or `ty`) with `uv sync`.
- Prefer running as a module with `-m` when appropriate.
- When running a script always use `uv run`.
- This also applies to one-off inline Python snippets; use `uv run python - <<'PY' ...` and never call bare `python` directly.

### Quality Checks (run via CLI)
- Format code with Ruff:
  - `uv run ruff format .`
- Lint (and auto-fix safe issues) with Ruff:
  - `uv run ruff check . --fix`
- Type-check with ty:
  - `uv run ty check`
- Run tests with pytest:
  - `uv run -m pytest` (add flags like `-k` or `-s` for targeted/debug runs)

### Agent / Model Edit Loop (required)
After every session of edits by the model, run the following checks (in this order):
1. Format:
   - `uv run ruff format .`
2. Lint (with fixes):
   - `uv run ruff check . --fix`
3. Tests (if there are any):
   - `uv run -m pytest`

If any step fails, explain the problem, fix issues and rerun the sequence until all checks pass.

## Debugging
- When debugging or trying tool commands, read --help or documentation first before attempting multiple guesses.

## Security & Configuration Tips
- Never commit secrets or large proprietary data. Keep credentials in env vars or a private `.env` (add an `.env.example` when needed) and extend `.gitignore` if new sensitive patterns appear.
