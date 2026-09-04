-- ============================================================================
-- KEYMAPS
-- ============================================================================

vim.keymap.set('n', '<leader>e', '<cmd>:Explore<cr>')
vim.keymap.set('n', '<leader>h', '<cmd>nohlsearch<cr>')
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- Diagnostics
vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next diagnostic" })
vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Previous diagnostic" })

vim.keymap.set("n", "]e", function()
  vim.diagnostic.jump({
    count = 1,
    severity = vim.diagnostic.severity.ERROR,
    float = true,
  })
end, { desc = "Next error" })

vim.keymap.set("n", "[e", function()
  vim.diagnostic.jump({
    count = -1,
    severity = vim.diagnostic.severity.ERROR,
    float = true,
  })
end, { desc = "Previous error" })

vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic float" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })
