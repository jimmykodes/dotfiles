local null_ls = require("null-ls")
local h = require("null-ls.helpers")
local FORMATTING = null_ls.methods.FORMATTING

local M = {
	autopep8 = h.make_builtin({
		name = "autopep8",
		method = FORMATTING,
		filetypes = { "python" },
		generator_opts = {
			command = "autopep8",
			args = { "--max-line-length", "120", "-" },
			to_stdin = true,
		},
		factory = h.formatter_factory,
	})
}

M.opts = {
	sources = {
		null_ls.builtins.formatting.goimports,
		null_ls.builtins.formatting.gofumpt,
		M.autopep8,
	}
}

function M.list_registered_sources(filetype)
	local s = require "null-ls.sources"
	local available_sources = s.get_available(filetype)
	local registered = {}
	for _, source in ipairs(available_sources) do
		for method in pairs(source.methods) do
			registered[method] = registered[method] or {}
			table.insert(registered[method], source.name)
		end
	end
	return registered
end

function M.setup()
	local default_opts = require("jk.lsps.events").get_common_opts()
	null_ls.setup(vim.tbl_deep_extend("force", default_opts, M.opts))
end

return M
