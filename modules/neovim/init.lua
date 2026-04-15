vim.pack.add {
  'https://github.com/AlexvZyl/nordic.nvim',
  'https://github.com/nvim-lualine/lualine.nvim',

  'https://github.com/nvim-mini/mini.nvim',

  -- Treesitter
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
	},

  -- CMP & LSP
  'https://github.com/neovim/nvim-lspconfig',
}

vim.cmd.colorscheme("nordic")

require "user.options"
require "user.mini"
require "user.lualine"
require "user.lsp"
require "user.treesitter"
