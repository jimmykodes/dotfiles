local lspconfig = require('lspconfig')
local wk = require("which-key")

local M = {}

function M.setup()
	lspconfig.pyright.setup {}
	lspconfig.tsserver.setup {}
	lspconfig.lua_ls.setup {}
	lspconfig.golangci_lint_ls.setup {}
	lspconfig.gopls.setup {
    on_attach = function(client, bufnr)
			require("gopher").setup({})
      local _, _ = pcall(vim.lsp.codelens.refresh)
      local map = function(mode, lhs, rhs, desc)
        if desc then
          desc = desc
        end
        vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc, buffer = bufnr, noremap = true })
      end
      map("n", "<leader>Gi", "<cmd>GoInstallDeps<Cr>", "Install Go Dependencies")
      map("n", "<leader>Gt", "<cmd>GoMod tidy<cr>", "Tidy")
      map("n", "<leader>Ga", "<cmd>GoTestAdd<Cr>", "Add Test")
      map("n", "<leader>GA", "<cmd>GoTestsAll<Cr>", "Add All Tests")
      map("n", "<leader>GE", "<cmd>GoTestsExp<Cr>", "Add Exported Tests")
      map("n", "<leader>Gg", "<cmd>GoGenerate<Cr>", "Go Generate")
      map("n", "<leader>Gf", "<cmd>GoGenerate %<Cr>", "Go Generate File")
      map("n", "<leader>Gc", "<cmd>GoCmt<Cr>", "Generate Comment")
      map("n", "<leader>Ge", "<cmd>GoIfErr<Cr>", "If err")
      map("n", "<leader>DT", "<cmd>lua require('dap-go').debug_test()<cr>", "Debug Test")
    end,
    settings = {
      gopls = {
        usePlaceholders = true,
        gofumpt = true,
        codelenses = {
          generate = false,
          gc_details = true,
          test = true,
          tidy = true,
        },
      },
    },
  }

	-- Use LspAttach autocommand to only map the following keys
	-- after the language server attaches to the current buffer
	vim.api.nvim_create_autocmd('LspAttach', {
		group = vim.api.nvim_create_augroup('UserLspConfig', {}),
		callback = function(ev)
			-- Enable completion triggered by <c-x><c-o>
			vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'


			local opts = { buffer = ev.buf }
			vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
			wk.register({
				g = {
					D = { vim.lsp.buf.declaration, "Go to Declarations" },
					d = { vim.lsp.buf.definition, "Go to Definition" },
					I = { vim.lsp.buf.implementation, "Go to Implementation" },
					r = { vim.lsp.buf.references, "Go to References" },
					s = { vim.lsp.buf.signature_help, "Show Signature help" },
				}
			}, opts)
			wk.register({
				l = {
					name = "lsp",
					w = {
						name = "workspace",
						a = { vim.lsp.buf.add_workspace_folder, "Add Folder" },
						r = { vim.lsp.buf.remove_workspace_folder, "Remove Folder" },
						l = { function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "List Folders" },
					},
					a = { vim.lsp.buf.code_action, "Code Actions", mode = { 'n', 'v' } },
					d = { vim.lsp.buf.type_definition, "Type Definition" },
					r = { vim.lsp.buf.rename, "Rename" },
					f = { function() vim.lsp.buf.format { async = true } end, "Format" },
				},
			}, { prefix = "<leader>", buffer = ev.buf })
		end,
	})
end

return M
