local util = require 'lspconfig.util'

local function on_new_config(new_config, new_root_dir)
  -- Look for node_modules/typescript/lib
  local ts_path = util.find_node_modules_ancestor(new_root_dir)
  if ts_path then
    new_config.init_options.typescript.tsdk = ts_path .. '/node_modules/typescript/lib'
  end
end

return {
  cmd = { 'vue-language-server', '--stdio' },
  filetypes = {
    'vue',
    'typescript',
    'javascript',
    'typescriptreact',
    'javascriptreact',
    'json',
  },
  root_dir = util.root_pattern 'package.json',
  on_new_config = on_new_config,
  init_options = {
    typescript = {
      tsdk = '', -- will be filled by on_new_config
    },
    vue = {
      -- Disable hybrid mode so Volar owns the TS features
      hybridMode = false,
    },
  },
}
