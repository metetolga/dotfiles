vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local opts = vim.opt

vim.schedule(function()
  opts.clipboard = 'unnamedplus'
end)

opts.breakindent = true
opts.mouse = 'a'
opts.number = true
opts.relativenumber = true
opts.showmode = false
opts.undofile = true
opts.ignorecase = true
opts.smartcase = true
opts.signcolumn = 'yes' -- for git signs, debug signs
opts.updatetime = 250
opts.timeoutlen = 300
opts.splitright = true
opts.splitbelow = true
opts.list = true
opts.listchars = { tab = '» ',trail = '·', nbsp = '␣' }
opts.inccommand = 'split'
opts.scrolloff = 10
opts.confirm = true
opts.tabstop = 2
opts.shiftwidth = 2
opts.softtabstop = 2
opts.expandtab = true 

vim.keymap.set('i', 'jj', '<ESC>', {silent = true})
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
--vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' }) -- idk what this do
--vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' }) -- this doesnt work

vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.api.nvim_create_autocmd('TextYankPost', { -- :help event
	desc = 'Highlight when yanking text', 
	group = vim.api.nvim_create_augroup('highlight-yank', {clear = true}), 
callback = function() vim.highlight.on_yank({timeout = 300}) end, 
})
