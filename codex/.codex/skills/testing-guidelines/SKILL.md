---
name: testing-guidelines
description: General, language-agnostic testing strategy and conventions. Use when planning or writing tests in any stack.
---

# General Testing Guidelines

## Strategy (Priority Order)
1. Unit/service-level tests for business logic.
2. End-to-end flows across multiple UI/HTTP steps.
3. Template/UI smoke tests.

If you must choose between testing services or views, test services first.

## Coverage Expectations
- Always cover happy paths and error paths.
- Include validation errors, domain constraints, edge cases (empty values, duplicates, limits), and state changes.
- When queries return DTOs, verify DTO structure and data.

## Naming Conventions
- Test files: `test_*` naming pattern.
- Test functions: `test_<action>_<scenario>` with clear intent.
- Test classes: `Test<Context>` for grouping related tests.

## Test Organization
- Group tests by feature/module.
- Keep shared utilities and factories close to tests or in a shared test module.

## Execution Focus
- Use fast, isolated tests as the default; reserve E2E for critical flows.
- Prefer deterministic inputs; avoid flakiness.
