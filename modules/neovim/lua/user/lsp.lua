-- Diagnostics
vim.diagnostic.config({
	virtual_lines = false,
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		focusable = false,
		header = "",
		prefix = "",
	},
})

-- CMP
require "mini.completion".setup()

-- LSP

vim.lsp.enable({
  "ts_ls",
	"lua_ls",
	"gopls",
	"nixd",
	"rust_analyzer",
})

local function lsp_on_attach(ev)
	local client = vim.lsp.get_client_by_id(ev.data.client_id)
	if not client then
		return
	end

	local bufnr = ev.buf
	local opts = { noremap = true, silent = true, buffer = bufnr }

  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gI", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set({"n", "v"}, "<leader>ca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)
end

vim.api.nvim_create_autocmd("LspAttach", { callback = lsp_on_attach })
