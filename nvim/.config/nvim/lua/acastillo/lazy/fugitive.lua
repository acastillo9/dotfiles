return {
  "tpope/vim-fugitive",
  config = function()
    vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
    vim.keymap.set("n", "<leader>go", "<cmd>diffget //2<CR>")
    vim.keymap.set("n", "<leader>gt", "<cmd>diffget //3<CR>")
    vim.keymap.set("n", "<leader>gb", ":Git blame<CR>")

    local acastillo_fugitive_group = vim.api.nvim_create_augroup("ACastillo_Fugitive", {})
    vim.api.nvim_create_autocmd("BufWinEnter", {
      group = acastillo_fugitive_group,
      pattern = "*",
      callback = function()
        if vim.bo.ft ~= "fugitive" then
          return
        end

        local bufnr = vim.api.nvim_get_current_buf()
        local opts = { buffer = bufnr, remap = false }
        vim.keymap.set("n", "<leader>gP", function()
          vim.cmd.Git('push')
        end, opts)

        -- rebase always
        vim.keymap.set("n", "<leader>gp", function()
          vim.cmd.Git({ 'pull', '--rebase' })
        end, opts)

        -- NOTE: It allows me to easily set the branch i am pushing and any tracking
        -- needed if i did not set the branch up correctly
        vim.keymap.set("n", "<leader>gu", ":Git push -u origin ", opts);
      end,
    })
  end
}
