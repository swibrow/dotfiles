# Global Agent Instructions

Default instructions for AI coding agents (Claude Code, Codex, etc.) across all
projects. Project-level AGENTS.md / CLAUDE.md files take precedence over this file.

## Working Style

- Be concise. Skip preamble and don't over-explain.
- If a request is ambiguous, present the interpretations instead of picking one silently.
- Don't state versions, API shapes, or flags from memory; verify against docs or the code itself.
- Only cite URLs actually fetched in the current session.
- Don't provide time estimates.
- Never use em dashes in prose. Use a hyphen (-), semicolon (;), or colon (:) instead.
- Only create .yaml files for YAML content (not .yml).
- Comments explain non-obvious constraints only, not what the code does. Prefer clear names and structure over explanatory comments.
- Reversible actions that follow from the request: just do them and say so. Stop and ask only for destructive or hard-to-undo actions, or a genuine change of scope.
- After a code change, verify it by actually running the code or its tests; don't claim it works untested.
- Never edit secrets or ignored files (`*.key`, `*.crt`, `.private/`, anything gitignored).

## Code Discipline

- Write the minimum code that solves the problem: no speculative abstractions, no unrequested configurability, no error handling for impossible cases.
- Touch only what the request requires. Don't refactor or "improve" adjacent code.
- Remove imports, variables, and functions that your change orphaned. Leave pre-existing dead code alone; mention it instead.
- Every changed line should trace back to the request.

## Agent configuration

Use a tool-agnostic layout so config works across all AI tooling. In each repo, put agent config in `.agents/` and `AGENTS.md`, then symlink the Claude-specific paths to them:

```shell
ln -s AGENTS.md CLAUDE.md
ln -s .agents .claude
```

`.agents/` and `AGENTS.md` are the sources of truth; `.claude` and `CLAUDE.md` are symlinks pointing at them. This keeps a single set of instructions that every agent (Claude Code, Codex, Cursor, etc.) reads. The same pattern applies globally: `~/.agents/AGENTS.md` is canonical, and `~/.claude/CLAUDE.md` / `~/.codex/AGENTS.md` symlink to it.

## Environment

- Dotfiles are managed with chezmoi (source: `~/.local/share/chezmoi`). Edit dotfiles in the chezmoi source, not the rendered files in `$HOME`.
- Shell is zsh, no plugin manager.
- Use `container` instead of `docker` for building and running containers. Instead of `docker compose`, use a kind cluster for multi-service local environments.

## Preferred Tools

- Search: `rg` (ripgrep) instead of `grep`.
- Find: `fd` instead of `find`.
- List: `eza` instead of `ls`.
- Data: `jq` for JSON, `yq` for YAML.

## Git

- Never `git commit`, `git push`, or open a PR unless asked.
- Sign off commits (`git commit -s`).
- Use Conventional Commits: `type(scope): summary` (types: feat, fix, chore, ci, docs, refactor, perf, test, build, style, revert).
- Do not mention Claude, Codex, or AI in commit messages, PR descriptions, or code comments. No "Generated with" trailers.
- Prefer `--force-with-lease` over `--force` when force-pushing.

## Versioning

This module is versioned with Semantic Versioning via semantic-release and Conventional Commits. See the [Versioning and Releases](README.md#versioning-and-releases) section of the README for the rules. Note in particular that a Kubernetes minor version update requires a MAJOR release of the module.
