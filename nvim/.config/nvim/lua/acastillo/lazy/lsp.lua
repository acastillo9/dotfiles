return {
	"hrsh7th/cmp-nvim-lsp",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/lazydev.nvim", opts = {} },
		"j-hui/fidget.nvim",
		"b0o/schemastore.nvim",
	},
	config = function()
		require("fidget").setup({})

		-- Per-server overrides live at `after/lsp/<name>.lua` so they load last
		-- in rtp order and win over nvim-lspconfig defaults. Servers without a
		-- file use defaults.
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		vim.lsp.config("*", { capabilities = capabilities })
	end,
}
