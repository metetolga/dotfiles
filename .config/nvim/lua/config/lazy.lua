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

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true },
})


-- local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- if not (vim.uv or vim.loop).fs_stat(lazypath) then
--   local lazyrepo = "https://github.com/folke/lazy.nvim.git"
--   local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
--   if vim.v.shell_error ~= 0 then
--     vim.api.nvim_echo({
--       { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
--       { out, "WarningMsg" },
--       { "\nPress any key to exit..." },
--     }, true, {})
--     vim.fn.getchar()
--     os.exit(1)
--   end
-- end
-- vim.opt.rtp:prepend(lazypath)
--
-- require('lazy').setup({
--   install = { colorscheme = { "catppuccin" } },
--   {
--     'nmac427/guess-indent.nvim',
--     config = function() require('guess-indent').setup({})  end,
--   },
-- 	{
-- 		'numToStr/Comment.nvim',
-- 		opts = {}
-- 	},
-- 	{
-- 		'nvim-lualine/lualine.nvim',
-- 		dependencies = { 'nvim-tree/nvim-web-devicons' },
--     opts = {}
-- 	},
--   {
--     'catppuccin/nvim',
--     name = 'catppuccin', 
--     priority = 1000, 
--     opts = {
--       flavour = 'mocha', 
--       integrations = {
--         lualine = true, 
--         treesitter = true,
--       },
--     },
--     config = function(plugin, opts) -- function(plugin, options) signature 
--       print(plugin.name) -- just a demo
--       require('catppuccin').setup(opts)
--       vim.cmd.colorscheme "catppuccin"
--     end
--   },
--   { 
--     'lewis6991/gitsigns.nvim',
--     opts = {
--       signs = {
--         add = { text = '+' },
--         change = { text = '~' },
--         delete = { text = '_' },
--         topdelete = { text = '‾' },
--         changedelete = { text = '~' },
--       },
--     },
--   },
--   {
--     'folke/todo-comments.nvim',
--     event = 'VimEnter', 
--     dependencies = { 'nvim-lua/plenary.nvim' }, 
--     opts = { signs = false }
--   },
-- })
--
