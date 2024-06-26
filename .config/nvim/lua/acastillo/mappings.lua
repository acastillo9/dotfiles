local keymap = vim.keymap

vim.g.mapleader = " "

-- Navigate vim panes better
keymap.set("n", "<c-k>", ":wincmd k<CR>")
keymap.set("n", "<c-j>", ":wincmd j<CR>")
keymap.set("n", "<c-h>", ":wincmd h<CR>")
keymap.set("n", "<c-l>", ":wincmd l<CR>")

-- Do things without affecting the registers
keymap.set("n", "x", '"_x')
keymap.set("n", "<Leader>P", '"0P')
keymap.set("v", "<Leader>P", '"0p')
keymap.set("n", "<Leader>C", '"_C')
keymap.set("v", "<Leader>C", '"_C')
keymap.set("n", "<Leader>D", '"_D')
keymap.set("v", "<Leader>D", '"_D')

keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Move cursor down" })
keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Move cursor up" })
keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
keymap.set("n", "<leader>q", "<cmd>confirm q<cr>", { desc = "Quit" })
keymap.set("n", "<leader>n", "<cmd>enew<cr>", { desc = "New File" })
keymap.set("n", "<C-s>", "<cmd>w!<cr>", { desc = "Force write" })
keymap.set("n", "<C-q>", "<cmd>q!<cr>", { desc = "Force quit" })
keymap.set("n", "|", "<cmd>vsplit<cr>", { desc = "Vertical Split" })
keymap.set("n", "\\", "<cmd>split<cr>", { desc = "Horizontal Split" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode" })
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })
keymap.set("n", "<leader>nn", ":set invrelativenumber<CR>", { desc = "Toggle relative numbers" })
keymap.set("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })

keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })
