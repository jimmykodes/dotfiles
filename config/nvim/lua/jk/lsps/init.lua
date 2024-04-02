local lspconfig = require('lspconfig')
local wk = require("which-key")

local M = {
	servers = {
		"pyright",
		"tsserver",
		"lua_ls",
		"gopls",
		"golangci_lint_ls",
	},
	opts = {}
}

function M.setup()
	for _, svr in ipairs(M.servers) do
		local opts = M.opts[svr] or {}
		local default_opts = require("jk.lsps.events").get_common_opts()
		lspconfig[svr].setup(vim.tbl_deep_extend("force", default_opts, opts))
	end

	require("jk.lsps.null_ls").setup()
	require("jk.lsps.autocmd").setup()

	wk.register({
		G = {
			name = "Go",
			i = { "<cmd>GoInstallDeps<Cr>", "Install Go Dependencies" },
			t = { "<cmd>GoMod tidy<cr>", "Tidy" },
			a = { "<cmd>GoTestAdd<Cr>", "Add Test" },
			A = { "<cmd>GoTestsAll<Cr>", "Add All Tests" },
			E = { "<cmd>GoTestsExp<Cr>", "Add Exported Tests" },
			g = { "<cmd>GoGenerate<Cr>", "Go Generate" },
			f = { "<cmd>GoGenerate %<Cr>", "Go Generate File" },
			c = { "<cmd>GoCmt<Cr>", "Generate Comment" },
			e = { "<cmd>GoIfErr<Cr>", "If err" },
			T = { "<cmd>lua require('dap-go').debug_test()<cr>", "Debug Test" },
		},
	}, { prefix = "<leader>" })
end

return M
