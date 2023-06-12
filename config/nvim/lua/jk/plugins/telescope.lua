local M = {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  -- dependencies = { "telescope-fzf-native.nvim" },
  lazy = true,
  cmd = "Telescope",
}

function M.config()
  require("telescope").setup()
end

return M
