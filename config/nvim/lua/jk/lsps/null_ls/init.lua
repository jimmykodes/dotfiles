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
			args = { "--max-line-length", "120", "$FILENAME" },
			to_stdin = true,
		},
		factory = h.formatter_factory,
	})
}

M.opts = {
	sources = {
		null_ls.builtins.formatting.goimports,
		M.autopep8,
	}
}


function M.setup()
	null_ls.setup(M.opts)
end

return M
