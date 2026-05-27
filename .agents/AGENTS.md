# Global Working Agreements

- Start with the simplest interpretation of my request.
- Keep changes minimal and tightly scoped to what I asked for.
- Do not add extra features, examples, or embellishments unless requested.
- Avoid over-investigating code or running unnecessary commands when I am asking a narrow question.
- Before making any code or config change, explain what you plan to change, why you are making that change, and any important tradeoffs or alternatives if relevant, then wait for my explicit approval before editing files, running mutating commands, or committing.
- When debugging or trying unfamiliar tools, read `--help` or `man` pages before repeated guesses.
- Prefer `rg` for text search instead of `grep`.
- Prefer `fd` for file discovery instead of `find` when available.
- Both `rg` and `fd` respect `.gitignore` by default; pass `--no-ignore` when you need to search ignored or untracked paths.
- Prefer `eza` for directory listing instead of `ls` when available.
- In `uv`-managed Python projects, use `uv run` for Python commands.
- Prefer running scripts as modules with `-m` when appropriate.
- For inline Python snippets in `uv` projects, use `uv run python - <<'PY' ...` instead of bare `python`.
- Install dependencies (including dev tools like `pytest`, `ruff`, or `ty`) with `uv sync`.
- All new functions and classes must have type annotations.

## Quality Checks (run via CLI)
- Format code with Ruff: `uv run ruff format .`
- Lint (and auto-fix safe issues) with Ruff: `uv run ruff check . --fix`
- Type-check with ty: `uv run ty check`
- Run tests with pytest: `uv run -m pytest` (add `-k` or `-s` for targeted/debug runs)

## Edit Loop (required after code changes)
Run in order, fix failures, and repeat until clean:
1. `uv run ruff format .`
2. `uv run ruff check . --fix`
3. `uv run ty check`
4. `uv run -m pytest`

## Git Commits
- Use Conventional Commits: `<type>(<scope>): <description>` (e.g., `fix(auth): handle expired tokens`).
- Types: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `ci`.
- Keep the description under 72 characters; use imperative mood.
- Do not commit without explicit user approval.
- Commit `uv.lock` for applications; add it to `.gitignore` for libraries.

## Security
- Never commit secrets or large proprietary data. Keep credentials in env vars or a private `.env` (add `.env.example` when needed) and extend `.gitignore` if new sensitive patterns appear.
