require "user.options"

vim.pack.add {
  'https://github.com/nordtheme/vim',

  'https://github.com/nvim-mini/mini.pick',

  -- CMP & LSP
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/hrsh7th/cmp-nvim-lsp',
  'https://github.com/hrsh7th/cmp-buffer',
  'https://github.com/hrsh7th/cmp-path',
  'https://github.com/hrsh7th/nvim-cmp',
}

vim.cmd.colorscheme("nord")

local mini = require("mini.pick")
mini.setup()

vim.keymap.set('n', '<C-p>', '<cmd>:Pick files<cr>')

local cmp = require 'cmp'

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'buffer' },
  })
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
vim.lsp.config('*', {
  capabilities = capabilities
})

vim.lsp.enable({'lua_ls', 'nixd'})

