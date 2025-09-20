return {
  {
    "nmac427/guess-indent.nvim",
    opts = {},
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
   config = function(plugin, opts) -- function(plugin, options) signature, normally function(_, opts)
     -- print(plugin.name) 
     require('catppuccin').setup(opts)
     vim.cmd.colorscheme "catppuccin"
   end
  },
}
