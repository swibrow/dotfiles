---
name: commit-convention
user-invocable: false
description: |
  Commit message conventions and code review standards.
  Background knowledge for consistent git practices across projects.
---

# Commit & Code Review Conventions

## Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### Types

| Type | When |
|------|------|
| `feat` | New feature |
| `fix` | Bug fix |
| `refactor` | Code change that neither fixes nor adds |
| `chore` | Maintenance (deps, CI, config) |
| `docs` | Documentation only |
| `test` | Adding or fixing tests |
| `ci` | CI/CD changes |
| `perf` | Performance improvement |

### Rules

- Subject line: imperative mood, no period, under 72 chars
- Body: explain **why**, not what (the diff shows what)
- Footer: reference tickets (`Refs: DND-123`) or breaking changes
- One logical change per commit

## Code Review Standards

When reviewing code, check:

1. **Correctness** — Does it do what it claims?
2. **Security** — OWASP top 10, input validation at boundaries
3. **Error handling** — Fails gracefully, no swallowed errors
4. **Naming** — Clear, consistent, no abbreviations
5. **Tests** — Meaningful coverage, not just line count
6. **Complexity** — Could it be simpler?

Don't nitpick formatting — that's what linters are for.
