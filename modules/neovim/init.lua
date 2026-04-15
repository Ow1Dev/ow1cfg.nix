vim.pack.add {
  'https://github.com/nordtheme/vim',
  'https://github.com/nvim-lualine/lualine.nvim',

  'https://github.com/nvim-mini/mini.pick',

  -- Treesitter
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
	},

  -- CMP & LSP
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/hrsh7th/cmp-nvim-lsp',
  'https://github.com/hrsh7th/cmp-buffer',
  'https://github.com/hrsh7th/cmp-path',
  'https://github.com/hrsh7th/nvim-cmp',
}

vim.cmd.colorscheme("nord")

require "user.options"
require "user.mini"
require "user.lualine"
require "user.lsp"
require "user.treesitter"
