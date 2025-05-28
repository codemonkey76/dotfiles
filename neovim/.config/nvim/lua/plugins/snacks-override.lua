return {
  {
    "Aasim-A/scrollEOF.nvim", -- snacks_picker.lua belongs to this plugin
    keys = {
      { "<leader>gd", false }, -- unmap Snacks' git diff
      {
        "<leader>gd",
        function()
          vim.lsp.buf.definition()
        end,
        desc = "Go to LSP Definition",
      },
    },
  },
}
