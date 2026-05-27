---
name: "new-uv-project"
description: "Scaffold a new Python project using uv with the standard dev stack: ruff (format + lint), ty (type-check), and pytest. Use when creating a new Python project from scratch."
---

# New uv Python project

Scaffold a new Python project with the standard tooling stack.

## Workflow

1. Run `uv init <project-name>` (or `uv init .` if already in the target directory).
2. Add dev dependencies: `uv add --dev ruff ty pytest`.
3. Configure `pyproject.toml` with the tool settings below.
4. Create a `tests/` directory with an empty `__init__.py`.
5. Run the edit loop to verify the scaffold is clean: `uv run ruff format .`, `uv run ruff check . --fix`, `uv run ty check`, `uv run -m pytest`.

## Standard `pyproject.toml` tool config

Add these sections to the generated `pyproject.toml`:

```toml
[tool.ruff]
line-length = 88

[tool.ruff.lint]
select = ["E", "F", "I", "UP"]

[tool.pytest.ini_options]
testpaths = ["tests"]
```

## Rules

- Use `uv add --dev` for dev-only dependencies; never add them to `[project].dependencies`.
- Set `requires-python` to the minimum version the project actually needs (default `>=3.11`).
- Do not add a `.venv` to version control; confirm `.gitignore` includes it.
- If the project already has a `pyproject.toml`, adapt rather than overwrite.
