local M = {
  "akinsho/toggleterm.nvim",
  lazy = false,
}

function M.config() 
  require("toggleterm").setup({
    open_mapping = [[<C-\>]],
    hide_numbers = true, -- hide the number column in toggleterm buffers
    shade_terminals = false ,
    shading_factor = 2, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
    start_in_insert = true,
    insert_mappings = true, -- whether or not the open mapping applies in insert mode
    direction = "float",
    close_on_exit = true, -- close the terminal window when the process exits
    float_opts = {
      border = "curved",
    },
  })
end

return M
