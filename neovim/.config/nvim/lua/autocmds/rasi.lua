vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'rasi', 'css' },
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.expandtab = true
    vim.bo.smartindent = true
  end,
})
