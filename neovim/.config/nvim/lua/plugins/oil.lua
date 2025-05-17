return {
  'stevearc/oil.nvim',
  opts = {
    default_file_explorer = true,
    skip_confirm_for_simple_edits = true,
  },
  keys = {
    {
      '<leader>e',
      function()
        local oil = require 'oil'

        local bufname = vim.api.nvim_buf_get_name(0)
        if bufname:match '^oil://' then
          vim.cmd 'bd'
        else
          vim.cmd 'Oil'
        end
      end,
      desc = 'Toggle Oil [E]xplorer',
    },
  },
}
