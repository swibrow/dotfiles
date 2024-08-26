-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

local plugins = {
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = {
      {'nvim-lua/plenary.nvim'}
    }
  }
}