---
name: pytest-testing
description: Pytest/Django testing conventions for this repo (stack, config, structure, and DB usage). Use when writing or running tests here.
---

# Pytest/Django Testing (FAKPy)

## Stack
- Pytest 9.x
- pytest-django 4.11+
- pytest-cov
- Faker (pt_BR)

## Configuration
`pyproject.toml`:
```toml
[tool.pytest.ini_options]
DJANGO_SETTINGS_MODULE = "config.settings.development"
pythonpath = ["src"]
```

## Test Structure
- App tests live in `src/<app>/tests/`.
- Shared tests live in `src/core/tests/`.
- Each app may define `factories.py`.

## Naming
- Files: `test_*.py`
- Functions: `test_<acao>_<cenario>()`
- Classes: `Test<NomeDoContexto>`
- Fixtures: snake_case

## Database Access
Use `@pytest.mark.django_db` only when tests touch the DB (create/read/update/delete or models).
Avoid it for pure function tests or validation utilities that do not hit the DB.

## Commands
Recommended:
- `just test`
- `just coverage`
- `just coverage-html`

Alternatives:
- `uv run pytest -q`
- `uv run pytest -v`
- `uv run pytest --cov=src`
- `uv run pytest --cov=src --cov-report=html`

Targeted runs:
- File: `uv run pytest src/app/tests/test_file.py`
- Function: `uv run pytest src/app/tests/test_file.py::test_name`
- Class: `uv run pytest src/core/tests/test_file.py::TestClass`
- Pattern: `uv run pytest -k "pattern"`
