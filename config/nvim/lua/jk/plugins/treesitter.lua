local M = {
	filetypes = {
		{
			extension = {
				jk = "joker"
			}
		},
		{
			extension = {
				td = "todo"
			}
		},
	},
	parsers = {
		joker = {
			install_info = {
				url = "https://github.com/jimmykodes/tree-sitter-joker",
				files = { "src/parser.c" },
				branch = "main",
			}
		},
		todo = {
			install_info = {
				url = "https://github.com/jimmykodes/tree-sitter-todo",
				files = { "src/parser.c" },
				branch = "main",
			}
		},
	}
}

function M.setup()
	M.initFT()
	M.initParsers()

	local configs = require("nvim-treesitter.configs")

	configs.setup({
		ensure_installed = {
			"bash",
			"css",
			"dockerfile",
			"go",
			"gomod",
			"gotmpl",
			"gowork",
			"helm",
			"html",
			"javascript",
			"json",
			"lua",
			"make",
			"markdown",
			"python",
			"query",
			"terraform",
			"vim",
			"vimdoc",
			"yaml",
		},
		sync_install = false,
		highlight = { enable = true },
		indent = { enable = true },
	})
end

function M.initFT()
	for _, ft in ipairs(M.filetypes) do
		vim.filetype.add(ft)
	end
end

function M.initParsers()
	local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
	for parser, conf in pairs(M.parsers) do
		parser_config[parser] = conf
	end
end

return M
