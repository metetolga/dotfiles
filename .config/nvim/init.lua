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
opts.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
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

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  install = { colorscheme = { "catppuccin" } },
  {
    'nmac427/guess-indent.nvim',
    config = function() require('guess-indent').setup({})  end,
  },
	{
		'numToStr/Comment.nvim',
		opts = {}
	},
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {}
	},
  {
    'catppuccin/nvim',
    name = 'catppuccin', 
    priority = 1000, 
    opts = {
      flavour = 'mocha', 
      integrations = {
        lualine = true, 
        treesitter = true,
      },
    },
    config = function(plugin, opts) -- function(plugin, options) signature 
      print(plugin.name) -- just a demo
      require('catppuccin').setup(opts)
      vim.cmd.colorscheme "catppuccin"
    end
  },
  { 
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter', 
    dependencies = { 'nvim-lua/plenary.nvim' }, 
    opts = { signs = false }
  },
})
