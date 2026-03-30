# Neovim

## Framework

Uses [LazyVim](https://www.lazyvim.org/) — a Neovim configuration framework built on [lazy.nvim](https://github.com/folke/lazy.nvim).

## Structure

```
~/.config/nvim/
├── init.lua              # Bootstrap lazy.nvim
├── lua/
│   ├── config/
│   │   ├── lazy.lua      # Plugin manager setup
│   │   ├── options.lua   # Editor options (LazyVim defaults)
│   │   ├── keymaps.lua   # Custom keymaps (LazyVim defaults)
│   │   └── autocmds.lua  # Autocommands (LazyVim defaults)
│   └── plugins/
│       └── example.lua   # Plugin overrides and additions
```

## Plugin Customizations

Configured in `lua/plugins/example.lua`:

| Plugin | Configuration |
|--------|--------------|
| gruvbox.nvim | Color scheme |
| nvim-treesitter | Extra parsers for syntax highlighting |
| telescope.nvim | Fuzzy finder with custom layout |
| nvim-lspconfig | LSP servers (pyright, tsserver, etc.) |
| trouble.nvim | Diagnostics viewer |
| nvim-cmp | Autocompletion with emoji source |
| mason.nvim | Tool installer (stylua, shellcheck, shfmt, flake8) |
| lualine.nvim | Status line customization |

## Adding Plugins

Create a new file in `~/.config/nvim/lua/plugins/`:

```lua
-- ~/.config/nvim/lua/plugins/my-plugin.lua
return {
  "author/plugin-name",
  opts = {
    -- plugin options
  },
}
```

LazyVim will automatically pick up any lua files in the plugins directory.

## Key Commands

| Command | Action |
|---------|--------|
| `:Lazy` | Open plugin manager UI |
| `:Mason` | Open tool installer UI |
| `:LazyExtras` | Browse and enable LazyVim extras |
