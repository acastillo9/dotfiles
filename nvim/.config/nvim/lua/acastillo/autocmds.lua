local yank_group = vim.api.nvim_create_augroup("HighlightYank", {})
local acastillo_group = vim.api.nvim_create_augroup("ACastillo", {})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = yank_group,
  pattern = "*",
  callback = function()
    vim.hl.on_yank({
      higroup = "IncSearch",
      timeout = 40,
    })
  end,
})

local whitespace_skip = { markdown = true, diff = true, gitcommit = true, mail = true }
vim.api.nvim_create_autocmd("BufWritePre", {
  group = acastillo_group,
  callback = function(ev)
    if whitespace_skip[vim.bo[ev.buf].filetype] then
      return
    end
    local view = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})

local treesitter_fts = {
  "typescript",
  "javascript",
  "typescriptreact",
  "javascriptreact",
  "css",
  "html",
  "json",
  "lua",
  "markdown",
  "svelte",
}
vim.api.nvim_create_autocmd("FileType", {
  group = acastillo_group,
  pattern = treesitter_fts,
  callback = function(ev)
    if not pcall(vim.treesitter.start, ev.buf) then
      return
    end
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    local ok, ts = pcall(require, "nvim-treesitter")
    if ok and ts.indentexpr then
      vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})
