return {
  "stevearc/oil.nvim",
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    skip_confirm_for_simple_edits = true,
    watch_for_changes = true,
  },
  dependencies = {
    { "nvim-mini/mini.icons", opts = {} },
  },
  lazy = false,
}
