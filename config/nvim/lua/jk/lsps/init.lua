local lspconfig = require('lspconfig')
local wk = require("which-key")

local M = {
	servers = {
		"pyright",
		"tsserver",
		"lua_ls",
		"golangci_lint_ls",
		"gopls",
	},
	opts = {
		gopls = {
			settings = {
				gopls = {
					usePlaceholders = true,
					gofumpt = true,
					codelenses = {
						generate = true,
						gc_details = false,
						test = true,
						tidy = true,
					},
				},
			},
		}
	}
}

function M.setup()
	for _, svr in ipairs(M.servers) do
		lspconfig[svr].setup(M.opts[svr] or {})
	end

	require("jk.lsps.null_ls").setup()
	require("jk.lsps.autocmd").setup()

	require("gopher").setup()
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
	}, { prefix = "<leader>", buffer = bufnr })
end

return M
