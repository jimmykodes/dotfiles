local lspconfig = require('lspconfig')

local M = {
	servers = {
		"docker_compose_language_service",
		"dockerls",
		"gopls",
		"golangci_lint_ls",
		"html",
		"lua_ls",
		"pyright",
		"tsserver",
		"yamlls",
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
end

return M
