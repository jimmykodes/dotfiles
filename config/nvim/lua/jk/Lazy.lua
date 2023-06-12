local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup("jk.plugins", {
  install = { coloscheme = { "onedarker" } },
  defaults = { lazy = true },
})

-- local plugins = {
--   {
--     "folke/lazy.nvim",
--     tag = "stable"
--   },
--   -- breadcrumbs -- requires LSP config
--   --  {
--   --    "SmiteshP/nvim-navic",
--   --    config = function()
--   --      require("lvim.core.breadcrumbs").setup()
--   --    end,
--   --    event = "User FileOpened",
--   --    enabled = lvim.builtin.breadcrumbs.active,
--   --  },
-- }
