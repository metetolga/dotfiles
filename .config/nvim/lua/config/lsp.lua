-- print(vim.lsp.config('lua-ls'))
vim.lsp.enable({'lua-ls', 'pyright', 'ruff'})


vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    if client and client.name == 'ruff' then
      client.server_capabilities.hoverProvider = false
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
      vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'fuzzy', 'popup' }
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
      vim.keymap.set('i', '<C-Space>', function() vim.lsp.completion.get() end)
    end

    local map = function(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = ev.buf, desc = 'LSP: ' .. desc })
    end

    map('gd', function() vim.lsp.buf.definition({ reuse_win = true }) end, 'Go to Definition')
    map('gD', vim.lsp.buf.declaration,                         'Go to Declaration')
    map('gi', vim.lsp.buf.implementation,                      'Go to Implementation')
    map('gr', vim.lsp.buf.references,                          'Go to References')
    map('K',  vim.lsp.buf.hover,                               'Hover Docs')
    map('<leader>rn', vim.lsp.buf.rename,                      'Rename Symbol')
    map('<leader>ca', vim.lsp.buf.code_action,                 'Code Action')

    local ok, tb = pcall(require, 'telescope.builtin')
    if ok then
      map('gd', tb.lsp_definitions,        'Go to Definition (Telescope)')
      map('gi', tb.lsp_implementations,    'Go to Implementation (Telescope)')
      map('gr', tb.lsp_references,         'Go to References (Telescope)')
    end

  end,
})

vim.diagnostic.config({
  virtual_lines = {
    current_line = true,
  },
})

vim.opt.winborder = 'rounded'
