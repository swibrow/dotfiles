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

Use a tool-agnostic layout so config works across all AI tooling. In each repo, `AGENTS.md` is the source of truth for instructions; `CLAUDE.md` is a real file (no symlinks) whose first line imports it:

```markdown
@AGENTS.md
```

Claude-specific additions may follow the import line; never duplicate shared instructions there. `.claude/` is a real directory for skills/commands/settings; Claude Code has no import mechanism for directories, so there is no `.agents/` directory at repo level. Every agent reads the same instructions: Claude Code via the import, Codex and others read `AGENTS.md` directly. Globally, `~/.agents/AGENTS.md` remains canonical, with `~/.claude/CLAUDE.md` / `~/.codex/AGENTS.md` symlinked to it.

## Environment

- Dotfiles are managed with chezmoi (source: `~/.local/share/chezmoi`). Edit dotfiles in the chezmoi source, not the rendered files in `$HOME`.
- That dotfiles repo is **public**. Two things must never land in it: secret env values, and strings naming the employer, its GitHub orgs, its domains, or the work email inside absolute paths. Use `$HOME` or `{{ .chezmoi.homeDir }}` rather than absolute `/Users/...` paths.
- Those excluded bits live in a **private layer**: a separate git repo cloned to `~/.config/dotfiles-private` by `.chezmoiexternal.yaml`. Public config reads it but must degrade gracefully when it is absent. Its current org-name list is in `~/.config/dotfiles-private/work.zsh`; check a change against that file before committing to the public repo.
- The private layer is a plain git repo, not chezmoi-managed files, so `chezmoi diff`/`status` say nothing about it and changes there need their own commit and push:
  ```shell
  git -C ~/.config/dotfiles-private add -A
  git -C ~/.config/dotfiles-private commit -s -m "..."
  git -C ~/.config/dotfiles-private push
  ```
  This matters most after `mise run secret:set NAME`, which writes an age-encrypted value into that repo and leaves it uncommitted. An unpushed rotation stays invisible until a new machine clones the layer without it.
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
