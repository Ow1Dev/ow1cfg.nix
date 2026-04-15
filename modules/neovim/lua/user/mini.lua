local mini = require("mini.pick")
mini.setup()

local icons = require "mini.icons"
icons.setup()
icons.tweak_lsp_kind()

require('mini.comment').setup()

vim.keymap.set('n', '<C-p>', '<cmd>:Pick files<cr>')
