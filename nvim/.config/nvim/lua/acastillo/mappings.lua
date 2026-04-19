vim.g.mapleader = " "

vim.keymap.set("n", "<leader>m", "<CMD>Oil<CR>", { desc = "Open parent directory" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines, keep cursor" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half-page down, centered" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half-page up, centered" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next match, centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Prev match, centered" })

vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yanking" })

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "Next quickfix" })
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "Prev quickfix" })
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Next loclist" })
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Prev loclist" })

vim.keymap.set("n", "<leader><leader>", "<cmd>source %<CR>", { desc = "Source current file" })

vim.keymap.set("n", "<C-w>z", "<cmd>tab split<CR>", { desc = "Zoom window in new tab" })

vim.keymap.set("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>", { desc = "Make it rain" })
