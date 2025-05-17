-- tsservercontext.lua
local util = require 'lspconfig.util'

local function is_volar_project(root_dir)
  local neoconf = require 'neoconf'
  return neoconf.get 'is-volar-project' or util.root_pattern('vue.config.js', 'vite.config.ts')(root_dir)
end

local function on_new_config(new_config, new_root_dir)
  local tsdk_path = util.find_node_modules_ancestor(new_root_dir)
  if tsdk_path then
    new_config.init_options = new_config.init_options or {}
    new_config.init_options.typescript = new_config.init_options.typescript or {}
    new_config.init_options.typescript.tsdk = tsdk_path .. '/node_modules/typescript/lib'
  end
end

return function(_, opts)
  if is_volar_project(vim.fn.getcwd()) then
    require('lspconfig').volar.setup {
      filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
      root_dir = util.root_pattern 'package.json',
      init_options = {
        vue = { hybridMode = false },
        typescript = { tsdk = '' }, -- will be patched
      },
      on_new_config = on_new_config,
    }

    require('typescript-tools').setup {
      server = opts,
      settings = {
        tsserver_plugins = { '@vue/typescript-plugin' },
      },
      filetypes = { 'typescript', 'javascript', 'vue' },
    }
  else
    require('typescript-tools').setup {
      server = opts,
    }
  end

  return true
end
