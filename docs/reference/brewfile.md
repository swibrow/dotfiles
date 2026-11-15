# Brewfile

All packages managed by Homebrew, split across two files at the root of the
chezmoi source dir:

- `homebrew/Brewfile` — cross-platform CLI tools, installed on both the `osx`
  and `linux-dev` profiles.
- `homebrew/Brewfile.macos` — GUI casks and the handful of macOS-only formulas,
  installed only on the `osx` profile.

`~/.config/homebrew/Brewfile` and `Brewfile.macos` are **symlinks** back into
the source dir (`dot_config/homebrew/symlink_Brewfile.tmpl`), and
`HOMEBREW_BUNDLE_FILE` points at the first one. Every `brew bundle` subcommand
therefore reads and writes the repo directly — nothing to copy back, and no
edits for `chezmoi apply` to silently revert.

## Staying in sync

`brew install` / `brew uninstall` are wrapped in zsh
(`dot_config/zsh/functions/general.zsh`) and mirrored into the right Brewfile by
[`brewfile-sync`](scripts.md), so a later `brew bundle` cannot
resurrect something you removed. Work-tap entries are routed to the private
layer, casks to `Brewfile.macos`, everything else to `Brewfile`. After
installing from a script rather than an interactive shell, run
`brewfile-sync add <pkg>` by hand.

To rebuild a Brewfile from scratch instead:

```bash
brew bundle dump --force --no-vscode
```

!!! warning
    Always use `--no-vscode` to exclude VS Code extensions. A dump also flattens
    the three-way split — it re-adds the work tap and its formulae, and puts
    casks in the main file. Move those back before committing.

Both Brewfiles are auto-installed during `chezmoi apply` via a hash-tracked run
script, which passes `--no-upgrade` so an apply never upgrades packages behind
your back.

## What stays in Homebrew

Command-line tools that ship prebuilt binaries for macOS and Linux live in the
mise global config (`mise/config.toml`) instead, so the same set installs on
every profile, including `arch`, which has no Homebrew. The Brewfiles keep only
what mise cannot provide well:

- libraries and system plumbing: `zsh` and its plugins, `bash`, `git`,
  `gnupg`, `coreutils`, `make`, `wget`, codecs and image libraries
- services and databases: `mysql`, `postgresql@*`, `valkey`, `ollama`,
  `herdr`, `fluent-bit`, `logstash`, `unbound`
- tools without cross-platform release binaries: `btop` (no macOS build),
  `skopeo`, `kanidm`, `krr`, `t-rec`, `tdf`, `htop`, `mtr`, `nmap`
- Homebrew-specific tools such as `taproom`, plus `mise` itself
- in `Brewfile.macos`: casks and macOS-only formulas such as `container` and
  `age-plugin-se`
