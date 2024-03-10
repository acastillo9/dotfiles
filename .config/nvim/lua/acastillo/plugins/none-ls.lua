return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
  },
  config = function()
    local null_ls = require("null-ls")

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    local none_ls_settings = require("neoconf").get("none_ls", {
      sources = {
        diagnostics = {
          builtins = {},
          extras = { "eslint_d" },
        },
        formatters = {
          builtins = { "stylua", "prettier" },
          extras = {},
        },
      },
      format_on_save = false,
    })

    local sources = {}
    for category, settings in pairs(none_ls_settings.sources) do
      local null_ls_category = category == "formatters" and "formatting" or category

      -- Handle built-in sources
      for _, source in ipairs(settings.builtins) do
        local built_in_source = null_ls.builtins[null_ls_category][source]
        if built_in_source then
          table.insert(sources, built_in_source)
        end
      end

      -- Handle extra sources
      for _, source in ipairs(settings.extras) do
        local extra_source = require("none-ls." .. null_ls_category .. "." .. source)
        if extra_source then
          table.insert(sources, extra_source)
        end
      end
    end

    null_ls.setup({
      sources = sources,
      -- configure format on save
      on_attach = function(current_client, bufnr)
        if none_ls_settings.format_on_save and current_client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = lint_augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = lint_augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({
                filter = function(client)
                  -- only use null-ls for formatting instead of lsp server
                  return client.name == "null-ls"
                end,
                bufnr = bufnr,
              })
            end,
          })
        end
      end,
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", vim.lsp.buf.format, { desc = "Format file" })
  end,
}
