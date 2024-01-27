local opts = { silent = true }
local keymap = vim.keymap.set

keymap("", "<Space>", "<Nop>", opts)

-- NORMAL
-- Navigate windows
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)


-- INSERT
-- faster escape?
keymap("i", "j;", "<ESC>", opts)

-- VISUAL
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- PLUGINS
-- Comments
keymap("n", "<leader>/", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", opts)
keymap("x", "<leader>/", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", opts)

-- NvimTree
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)
keymap("n", "<leader>o", ":NvimTreeFocus<CR>", opts)

-- Telescope
-- keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)
-- keymap("n", "<leader>ft", ":Telescope live_grep<CR>", opts)
-- keymap("n", "<leader>fp", ":Telescope projects<CR>", opts)
-- keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts)

local wk = require("which-key")
wk.register({
	f = {
		name = "Find",
		f = { "<cmd>Telescope find_files<CR>", "Files" },
	},
	h = { "<cmd>nohlsearch<CR>" },
	c = { ":bd<CR>", "Close Buffer" },
	w = { ":w<CR>", "Save" },
	q = { ":q<CR>", "Quit"},
	x = { ":x<CR>", "Save and Quit" },
	["/"] = { "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", "Comment" },
}, { prefix = "<leader>" })

keymap("n", "<leader>ks", "<cmd>lua require 'jk.plugins.toggleterm'.k9s()<cr>", opts)
