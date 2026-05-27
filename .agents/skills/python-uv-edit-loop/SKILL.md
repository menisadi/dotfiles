---
name: "python-uv-edit-loop"
description: "Use when working in a Python repository managed with uv and code edits have been made. Run the standard format, lint-fix, and test loop with uv, fix failures, and repeat until the tree is clean or a blocker remains."
---

# Python uv edit loop

Use this skill after editing Python code in a repository that uses `uv`.

## Workflow

1. Confirm the repo uses `uv` and identify the narrowest relevant test target if the change is scoped.
2. Run formatting with `uv run ruff format .`.
3. Run lint fixes with `uv run ruff check . --fix`.
4. Run type checks with `uv run ty check`.
5. Run tests with `uv run -m pytest` or a narrower target when the request is intentionally scoped.
6. If a step fails, inspect the failure, fix the issue, and rerun the sequence from the top.
7. In the final response, state what was run and whether anything remains failing or unverified.

## Rules

- Use `uv run` for Python commands; do not call bare `python` directly.
- Prefer the narrowest test target that still validates the change when the scope is clear.
- If the user explicitly asks for the full suite, run the full suite.
- If a command fails because tools are missing or the environment is broken, report that clearly instead of guessing.
