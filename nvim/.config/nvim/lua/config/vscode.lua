vim.g.mapleader = " "
local map = function(mode, lhs, rhs, opts)
	opts = opts or {}
	vim.keymap.set(mode, lhs, rhs, opts)
end
local opts = { silent = true }
map("i", "jj", "<ESC>", opts)
map("n", "<Esc>", "<cmd>nohlsearch<CR>", opts)
map("v", "p", "P", opts)
map("n", "u", "U", opts)
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)
vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.smartcase = true
