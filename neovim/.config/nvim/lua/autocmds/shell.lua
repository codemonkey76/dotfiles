-- Set indentation for all shell-like files
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'sh', 'bash', 'zsh' },
  callback = function()
    vim.bo.expandtab = true -- Use spaces instead of tabs
    vim.bo.shiftwidth = 4 -- Indent width
    vim.bo.tabstop = 4 -- Tab character width
    vim.bo.softtabstop = 4 -- Insert 4 spaces when pressing Tab
  end,
})

-- Detect .zshrc modular files as Zsh
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*/zshrc/*' },
  callback = function()
    vim.bo.filetype = 'zsh'
  end,
})
