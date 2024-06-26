-- vim options
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.relativenumber = true
vim.opt.wrap = true

-- general
lvim.log.level = "info"
lvim.format_on_save = {
  enabled = true,
  pattern = "*",
  timeout = 1000,
}

lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
lvim.keys.normal_mode["<S-TAB>"] = "<C-o>"

-- -- Use which-key to add extra bindings with the leader-key prefix
lvim.builtin.which_key.setup.plugins.registers = true

lvim.builtin.which_key.vmappings["w"] = {
  name = "Wrap",
  ["'"] = { [["pc'<C-r>p'<Esc>]], "Single Quote" },
  ['"'] = { [["pc"<C-r>p"<Esc>]], "Double Quote" },
  ['('] = { [["pc(<C-r>p)<Esc>]], "Parens" },
  ['{'] = { [["pc{<C-r>p}<Esc>]], "Braces" },
  ['['] = { [["pc[<C-r>p]<Esc>]], "Brackets" },
}

lvim.builtin.which_key.vmappings["t"] = {
  c = { ":'<,'>StrmanCamel<cr>", "Camel Case" },
  p = { ":'<,'>StrmanPascal<cr>", "Pascal Case" },
  s = { ":'<,'>StrmanSnake<cr>", "Snake Case" },
  k = { ":'<,'>StrmanKebab<cr>", "Kebab Case" },
  S = { ":'<,'>StrmanScreamingSnake<cr>", "Screaming Snake Case" },
  K = { ":'<,'>StrmanScreamingKebab<cr>", "Screaming Kebab Case" },
}

lvim.builtin.which_key.mappings["o"] = { "<cmd>NvimTreeFocus<cr>", "Explorer Focus" }
lvim.builtin.which_key.mappings["W"] = { "<cmd>noautocmd w<cr>", "Save without formatting" }
lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["T"] = {
  name = "Transform",
  ["'"] = { [["pdi"h2xi'<C-r>p'<Esc>]], "Single Quote" },
  ['"'] = { [["pdi'h2xi"<C-r>p"<Esc>]], "Double Quote" },
  ["("] = {
    name = "Paren -> _",
    ["{"] = { [["pdi(h2xi{<C-r>p}<Esc>]], "Paren -> Brace" },
    ["["] = { [["pdi(h2xi[<C-r>p]<Esc>]], "Paren -> Bracket" },
  },
  ["{"] = {
    name = "Brace -> _",
    ["("] = { [["pdi{h2xi(<C-r>p)<Esc>]], "Brace -> Paren" },
    ["["] = { [["pdi{h2xi[<C-r>p]<Esc>]], "Brace -> Bracket" },
  },
  ["["] = {
    name = "Bracket -> _",
    ["("] = { [["pdi[h2xi(<C-r>p)<Esc>]], "Bracket -> Paren" },
    ["{"] = { [["pdi[h2xi{<C-r>p}<Esc>]], "Bracket -> Brace" },
  },
}

lvim.builtin.which_key.mappings["t"] = {
  name = "Terminal",
  j = { ":ToggleTerm 1<cr>", "Terminal 1" },
  k = { ":ToggleTerm 2<cr>", "Terminal 2" },
  l = { ":ToggleTerm 3<cr>", "Terminal 3" },
  v = {
    name = "Vertical",
    j = { ":ToggleTerm 1 direction=vertical<cr>", "Terminal 1" },
    k = { ":ToggleTerm 2 direction=vertical<cr>", "Terminal 2" },
    l = { ":ToggleTerm 3 direction=vertical<cr>", "Terminal 3" },
  },
  h = {
    name = "Horizontal",
    j = { ":ToggleTerm 1 direction=horizontal<cr>", "Terminal 1" },
    k = { ":ToggleTerm 2 direction=horizontal<cr>", "Terminal 2" },
    l = { ":ToggleTerm 3 direction=horizontal<cr>", "Terminal 3" },
  },
  f = {
    name = "Float",
    j = { ":ToggleTerm 1 direction=float<cr>", "Terminal 1" },
    k = { ":ToggleTerm 2 direction=float<cr>", "Terminal 2" },
    l = { ":ToggleTerm 3 direction=float<cr>", "Terminal 3" },
  },
}
-- -- Change theme settings
vim.o.termguicolors = true
-- lvim.colorscheme = "tyranitar"
lvim.colorscheme = "system76"

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

-- Automatically install missing parsers when entering buffer
lvim.builtin.treesitter.auto_install = true

-- -- always installed on startup, useful for parsers without a strict filetype
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "css",
  "rust",
  "yaml",
  "go",
  "gomod",
  "hcl",
  "joker",
}

vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "azure_pipelines_language_server" })

-- make sure server will always be installed even if the server is in skipped_servers list
lvim.lsp.installer.setup.ensure_installed = {
  "arduino_language_server",
  "jsonls",
  "gopls",
}

require("lspconfig")["arduino_language_server"].setup({
  cmd = { "arduino-language-server", "-cli-config", "$HOME/Library/Arduino15/arduino-cli.yaml" }
})


-- configure Joker language support
vim.filetype.add({
  extension = {
    jk = "joker"
  }
})

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.joker = {
  install_info = {
    url = "https://github.com/jimmykodes/tree-sitter-joker",
    files = { "src/parser.c" },
    branch = "main",
  }
}

-- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "goimports" },
  { command = "gofumpt" },
  { command = "autopep8", args = { "--max-line-length", "120" } }
}

-- set additional linters
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { command = "shellcheck", filetypes = { "zsh" } },
  { command = "cspell" },
}

-- code actions
local code_actions = require "lvim.lsp.null-ls.code_actions"
code_actions.setup {
  { name = "cspell", }
}

lvim.plugins = {
  { "lunarvim/colorschemes" },
  {
    "ggandor/lightspeed.nvim",
    event = "BufRead",
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require "lsp_signature".on_attach() end,
  },
  {
    'stevearc/dressing.nvim',
    opts = {},
  },
  {
    'sourcegraph/sg.nvim',
  },
  "towolf/vim-helm",
  "olexsmir/gopher.nvim",
  "leoluz/nvim-dap-go",

  "jimmykodes/strman.nvim",
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = "zsh",
  callback = function()
    -- let treesitter use bash highlight for zsh files as well
    require("nvim-treesitter.highlight").attach(0, "bash")
  end,
})

-- Cody
local function setupCody()
  local ok, cody = pcall(require, "sg")
  if not ok then
    return
  end
  cody.setup()
end

setupCody()


-- Dap
local function setupDapGo()
  local dap_ok, dapgo = pcall(require, "dap-go")
  if not dap_ok then
    return
  end

  dapgo.setup()
end

local function setupLspGo()
  vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "gopls" })

  local lsp_manager = require "lvim.lsp.manager"
  lsp_manager.setup("golangci_lint_ls", {
    on_init = require("lvim.lsp").common_on_init,
    capabilities = require("lvim.lsp").common_capabilities(),
  })
  lsp_manager.setup("gopls", {
    on_attach = function(client, bufnr)
      require("lvim.lsp").common_on_attach(client, bufnr)
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
    on_init = require("lvim.lsp").common_on_init,
    capabilities = require("lvim.lsp").common_capabilities(),
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
  })

  local status_ok, gopher = pcall(require, "gopher")
  if not status_ok then
    return
  end
  gopher.setup({
    commands = {
      go = "go",
      gomodifytags = "gomodifytags",
      gotests = "gotests",
      impl = "impl",
      iferr = "iferr",
    },
  })
end

setupDapGo()
setupLspGo()
