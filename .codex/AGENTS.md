# Global Working Agreements

- Start with the simplest interpretation of my request.
- Keep changes minimal and tightly scoped to what I asked for.
- Do not add extra features, examples, or embellishments unless requested.
- Avoid over-investigating code or running unnecessary commands when I am asking a narrow question.
- Before making any code or config change, explain what you plan to change, why you are making that change, and any important tradeoffs or alternatives if relevant, then wait for my explicit approval before editing files, running mutating commands, or committing.
- When debugging or trying unfamiliar tools, read `--help` or documentation before repeated guesses.
- Prefer `rg` for text search instead of `grep`.
- Prefer `fd` for file discovery instead of `find` when available.
- In `uv`-managed Python projects, use `uv run` for Python commands.
- Prefer running scripts as modules with `-m` when appropriate.
- For inline Python snippets in `uv` projects, use `uv run python ...` instead of bare `python`.
