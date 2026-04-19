return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local nvim_treesitter = require("nvim-treesitter")

      nvim_treesitter.install({ "lua", "javascript", "typescript", "rust", "html", "css", "scss", "angular", "astro",
        "svelte",
        "vue", "json", "jsdoc", "bash" })
    end
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'VeryLazy',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      max_lines = 3,
      min_window_height = 20,
    },
    keys = {
      {
        '[C',
        function()
          require('treesitter-context').go_to_context()
        end,
        desc = 'go to context',
      },
    },
  },
}
