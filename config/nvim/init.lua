vim.g.mapleader = " "

require "jk.Lazy"
require "jk.options"
require "jk.keymaps"

local lspconfig = require('lspconfig')
lspconfig.pyright.setup {}
lspconfig.tsserver.setup {}
lspconfig.gopls.setup {}
lspconfig.lua_ls.setup {}


-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)

    vim.keymap.set('n', '<leader>lwa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<leader>lwr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<leader>lwl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)

    vim.keymap.set('n', '<leader>lD', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>la', vim.lsp.buf.code_action, opts)

    vim.keymap.set('n', '<leader>lf', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
