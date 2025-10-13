return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        intelephense = {
          settings = {
            intelephense = {
              files = {
                maxSize = 50000000,
              },
            },
          },
          handlers = {
            ["textDocument/publishDiagnostics"] = function(err, result, ctx)
              -- Filter out unused symbol diagnostics for variables starting with underscore
              if result and result.diagnostics then
                result.diagnostics = vim.tbl_filter(function(diagnostic)
                  local message = diagnostic.message or ""
                  return not message:match("Symbol '%$_[^']*' is declared but not used%.")
                end, result.diagnostics)
              end
              vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx)
            end,
          },
        },
      },
    },
  },
}
