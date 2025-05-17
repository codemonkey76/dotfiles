return {
  -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        print 'Running reformat'
        local conform = require 'conform'
        local bufnr = vim.api.nvim_get_current_buf()

        local formatters = conform.list_formatters_for_buffer(bufnr)
        if formatters and #formatters > 0 then
          conform.format {
            bufnr = bufnr,
            async = true,
            lsp_fallback = true,
            timeout_ms = 1000,
          }
        else
          print 'Running fallback'
          vim.cmd 'normal! gg=G'
          vim.notify('No formatter available, falling back to gg=G', vim.log.levels.INFO)
        end
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      else
        return {
          timeout_ms = 500,
          lsp_format = 'fallback',
        }
      end
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      -- Conform can also run multiple formatters sequentially
      -- python = { "isort", "black" },
      --
      -- You can use 'stop_after_first' to run the first available formatter from the list
      -- javascript = { "prettierd", "prettier", stop_after_first = true },
    },
  },
}
