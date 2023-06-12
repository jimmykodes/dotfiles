local M = {
  'akinsho/bufferline.nvim',
  dependencies = 'nvim-tree/nvim-web-devicons',
  event = { "BufReadPre", "BufAdd", "BufNew", "BufReadPost" },
  lazy = false,
}

function M.config()
  require("bufferline").setup()
end

return M

