return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    require('bufferline').setup {
      options = {
        mode = 'buffers',
        diagnostics = 'nvim_lsp',
        separator_style = 'slant',
        always_show_bufferline = true,
        show_buffer_close_icons = false,
        show_close_icon = false,
      },
    }

    local map = vim.keymap.set
    local opts = { silent = true, noremap = true }

    -- Keymaps
    map('n', '<leader>q', '<cmd>bdelete<CR>', vim.tbl_extend('force', opts, { desc = '[Q]uit buffer' }))
    map('n', '<leader>Q', '<cmd>bdelete!<CR>', vim.tbl_extend('force', opts, { desc = '[Q]uit! buffer' }))
    map('n', '<Tab>', '<cmd>BufferLineCycleNext<CR>', vim.tbl_extend('force', opts, { desc = 'Next buffer' }))
    map('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<CR>', vim.tbl_extend('force', opts, { desc = 'Previous buffer' }))
  end,
}
