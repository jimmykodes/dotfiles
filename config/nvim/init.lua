vim.g.mapleader = " "

require "jk.Lazy"
require "jk.options"


local keymaps = require "jk.keymaps"
keymaps.setup()

local lspconfig = require('lspconfig')
lspconfig.pyright.setup {}
lspconfig.tsserver.setup {}
lspconfig.gopls.setup {}
lspconfig.lua_ls.setup {}


local wk = require("which-key")
-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    vim.keymap.set('n', 'K', vim.lsp.buf.hover, {silent=true})

    local opts = { buffer = ev.buf }
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
