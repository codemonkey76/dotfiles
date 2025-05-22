-- ~/.config/nvim/lua/plugins/nvim-lint.lua
return {
  "mfussenegger/nvim-lint",
  opts = {
    linters_by_ft = {
      php = {}, -- disables all PHP linters, including phpcs
    },
  },
}
