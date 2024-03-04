return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")
    local format_settings = {
      lsp_fallback = true,
      timeout_ms = 500,
    }
    local default_settings = {
      formatters_by_ft = {
        css = { "prettier" },
        html = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        json = { "prettier" },
        lua = { "stylua" },
        markdown = { "prettier" },
        svelte = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        yaml = { "prettier" },
        vue = { "prettier" },
      },
      format_on_save = false, -- false by default
    }

    -- get conform configuration from workspace if exists
    local conform_settings = require("neoconf").get("conform", default_settings)

    conform.setup({
      formatters_by_ft = conform_settings.formatters_by_ft,
      format_on_save = conform_settings.format_on_save,
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format(format_settings)
    end, { desc = "Format file" })
  end,
}
