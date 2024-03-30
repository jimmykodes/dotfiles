local icons = require("jk.icons")

local M = {
	components = {
		mode = {
			"mode",
			fmt = function(name, _)
				if name == "INSERT" then
					return "I"
				elseif name == "NORMAL" then
					return "N"
				elseif name == "COMMAND" then
					return "C"
				else
					return "V"
				end
			end
		},
		lsp = {
			function()
				local buf_clients = vim.lsp.get_active_clients { bufnr = 0 }
				if #buf_clients == 0 then
					return "LSP Inactive"
				end

				local buf_client_names = {}

				-- add client
				for _, client in pairs(buf_clients) do
					if client.name ~= "null-ls" then
						table.insert(buf_client_names, client.name)
					end
				end

				-- TODO: How do I get this info?
				-- -- add formatter
				-- local buf_ft = vim.bo.filetype
				-- local formatters = require "lvim.lsp.null-ls.formatters"
				-- local supported_formatters = formatters.list_registered(buf_ft)
				-- vim.list_extend(buf_client_names, supported_formatters)
				--
				-- -- add linter
				-- local linters = require "lvim.lsp.null-ls.linters"
				-- local supported_linters = linters.list_registered(buf_ft)
				-- vim.list_extend(buf_client_names, supported_linters)

				local unique_client_names = vim.fn.uniq(buf_client_names)

				local language_servers = "LSPs: " .. table.concat(unique_client_names, ", ")

				return language_servers
			end,
			color = { gui = "bold" },
		},

		treesitter = {
			-- green if treesitter installed for buffer type, otherwise red.
			-- useful for determining when I'll need to run `:TSInstall` since
			-- I'm not doing anything automagic on buffer entry
			function()
				return icons.ui.Tree
			end,
			color = function()
				local buf = vim.api.nvim_get_current_buf()
				local ts = vim.treesitter.highlighter.active[buf]
				return { fg = ts and not vim.tbl_isempty(ts) and 'green' or 'red' }
			end,
		},
	}
}

M.opts = {
	options = {
		icons_enabled = true,
		theme = 'auto',
		component_separators = { left = icons.ui.DividerLeft, right = icons.ui.DividerRight },
		section_separators = { left = icons.ui.BoldDividerLeft, right = icons.ui.BoldDividerRight },
		disabled_filetypes = {
			"alpha",
			"statusline",
			"winbar"
		},
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = true,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		}
	},
	sections = {
		lualine_a = { M.components.mode },
		lualine_b = { 'branch', 'diff', 'diagnostics' },
		lualine_c = { M.components.treesitter },
		lualine_x = { 'filetype', M.components.lsp },
		lualine_y = { 'progress' },
		lualine_z = { 'location' }
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {},
		lualine_x = { 'location' },
		lualine_y = {},
		lualine_z = {}
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {}
}



function M.setup()
	require("lualine").setup(M.opts)
end

return M
