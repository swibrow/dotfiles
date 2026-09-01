# atuin gateway API key injection
#
# The self-hosted atuin sync server sits behind an Envoy apiKeyAuth
# SecurityPolicy requiring an `X-API-Key` header. Atuin's own config-rs env
# override needs the literal name `ATUIN_EXTRA_HEADERS__X-API-Key`, which zsh's
# `export` refuses (hyphens aren't valid in a shell identifier) - `env` has no
# such restriction, so inject it there instead. The key itself lives as
# ATUIN_API_KEY, age-encrypted via `mise run secret:set ATUIN_API_KEY`.
#
# Shadowing the `atuin` command also covers its own shell-search keybindings,
# which invoke the bare word `atuin` under the hood.
atuin() {
  env "ATUIN_EXTRA_HEADERS__X-API-Key=$ATUIN_API_KEY" command atuin "$@"
}
