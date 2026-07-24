Only create .yaml for yaml files

Don't add inline comments to code unless it's genuinely complex and the code can't speak for itself. Prefer clear names and structure over explanatory comments.

## Agent configuration

Use a tool-agnostic layout so config works across all AI tooling. In each repo, put agent config in `.agents/` and `AGENTS.md`, then symlink the Claude-specific paths to them:

```shell
ln -s AGENTS.md CLAUDE.md
ln -s .agents .claude
```

`.agents/` and `AGENTS.md` are the sources of truth; `.claude` and `CLAUDE.md` are symlinks pointing at them. This keeps a single set of instructions that every agent (Claude Code, Cursor, etc.) reads.

## Containers

Use `container` instead of `docker` for building and running containers. Instead of `docker compose`, use a kind cluster for multi-service local environments.

## Versioning

This module is versioned with Semantic Versioning via semantic-release and Conventional Commits. See the [Versioning and Releases](README.md#versioning-and-releases) section of the README for the rules. Note in particular that a Kubernetes minor version update requires a MAJOR release of the module.
