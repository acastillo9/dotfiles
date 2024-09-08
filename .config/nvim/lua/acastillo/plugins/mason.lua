return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
    local mason_tool_installer = require("mason-tool-installer")

    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_uninstalled = "✗",
          package_pending = "⟳",
        },
      },
    })

    mason_lspconfig.setup({
      ensure_installed = {
        "cssls",
        "emmet_ls",
        "html",
        "lua_ls",
        "svelte",
        "tailwindcss",
        "ts_ls",
        "volar",
      },
      automatic_installation = true,
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "eslint_d",
        "prettier",
        "stylua",
      },
    })
  end,
}
