-- ~/.config/nvim/lua/plugins/conform.lua
return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      php = { "pint" },
    },
    formatters = {
      pint = {
        command = "./vendor/bin/pint",
        stdin = false,
      },
    },
  },
}
