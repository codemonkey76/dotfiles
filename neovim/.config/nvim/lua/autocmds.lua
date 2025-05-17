-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'lua',
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.expandtab = true
    vim.bo.smartindent = true
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'sh', 'bash', 'zsh' },
  callback = function()
    vim.bo.expandtab = true -- Use spaces instead of tabs
    vim.bo.shiftwidth = 4 -- Indent width
    vim.bo.tabstop = 4 -- Tab character width
    vim.bo.softtabstop = 4 -- Insert 4 spaces when pressing Tab
  end,
})
