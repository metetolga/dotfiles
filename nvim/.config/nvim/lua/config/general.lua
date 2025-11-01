vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opts = vim.opt

vim.schedule(function()
	opts.clipboard = "unnamedplus"
end)

opts.breakindent = true
opts.mouse = "a"
opts.number = true
opts.relativenumber = true
opts.showmode = false
opts.undofile = true
opts.ignorecase = true
opts.smartcase = true
opts.signcolumn = "yes"
opts.updatetime = 250
opts.timeoutlen = 300
opts.splitright = true
opts.splitbelow = true
opts.list = true
opts.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opts.inccommand = "split"
opts.scrolloff = 5
opts.confirm = true
opts.tabstop = 2
opts.shiftwidth = 2
opts.softtabstop = 2
opts.expandtab = true
vim.g.python3_host_prog=vim.fn.expand("~/.virtualenvs/neovim/bin/python3")

local map = function(mod, l, r, opts)
	opts = opts or {}
	vim.keymap.set(mod, l, r, opts)
end
local keymap_opts = { silent = true }

map("i", "jj", "<ESC>", keymap_opts)
map("n", "<Esc>", "<cmd>nohlsearch<CR>", keymap_opts)
map("t", "<Esc><Esc>", "<C-\\><C-n>", keymap_opts)

map("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
map("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
map("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
map("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

map("v", "<", "<gv")
map("v", ">", ">gv")

vim.api.nvim_create_autocmd("TextYankPost", { -- :help event
	desc = "Highlight when yanking text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ timeout = 300 })
	end,
})
