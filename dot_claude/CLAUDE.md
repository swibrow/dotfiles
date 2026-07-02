Only create .yaml for yaml files

Don't add inline comments to code unless it's genuinely complex and the code can't speak for itself. Prefer clear names and structure over explanatory comments.

## Containers

Use `container` instead of `docker` for building and running containers. Instead of `docker compose`, use a kind cluster for multi-service local environments.

## Versioning

This module is versioned with Semantic Versioning via semantic-release and Conventional Commits. See the [Versioning and Releases](README.md#versioning-and-releases) section of the README for the rules. Note in particular that a Kubernetes minor version update requires a MAJOR release of the module.
