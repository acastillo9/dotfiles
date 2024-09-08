return {
  "linrongbin16/lsp-progress.nvim",
  config = function()
    require("lsp-progress").setup({
      format = function(client_messages)
        local sign = ""
        if #client_messages > 0 then
          return sign .. " LSP" .. table.concat(client_messages, " ")
        end
        if #vim.lsp.get_clients() > 0 then
          return sign
        end
        return ""
      end,
    })
  end,
}
