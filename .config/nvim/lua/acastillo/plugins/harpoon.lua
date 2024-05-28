return {
  "ThePrimeagen/harpoon",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "pockata/harpoon-highlight-current-file",
      config = true,
    },
  },
  opts = {
    settings = {
      sync_on_ui_close = true,
      save_on_toggle = true,
    },
  },
  config = function(_, opts)
    local keymap = vim.keymap
    keymap.set("n", "<leader>hm", "<cmd>lua require('harpoon'):list():add()<cr>", { desc = "Mark file with harpoon" })
    keymap.set(
      "n",
      "<leader>hl",
      "<cmd>lua require('harpoon.ui'):toggle_quick_menu(require('harpoon'):list())<cr>",
      { desc = "List harpoon marks" }
    )
    keymap.set(
      "n",
      "<leader>hn",
      "<cmd>lua require('harpoon'):list():next({ ui_nav_wrap = true })<cr>",
      { desc = "Go to next harpoon mark" }
    )
    keymap.set(
      "n",
      "<leader>hp",
      "<cmd>lua require('harpoon'):list():prev({ ui_nav_wrap = true })<cr>",
      { desc = "Go to previous harpoon mark" }
    )

    require("harpoon").setup(opts)
  end,
  branch = "harpoon2",
}
