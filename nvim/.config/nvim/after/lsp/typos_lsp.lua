return {
  settings = {
    typos = {
      enable = true,
      dictionaries = { "en_US", "es_ES" },
      dictionary_path = vim.fn.expand("~/.config/nvim/dictionaries"),
    },
  },
  filetypes = { "markdown", "text", "gitcommit" },
}
