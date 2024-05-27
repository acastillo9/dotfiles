local opt = vim.opt

-- Appearance settings
-- Enable termguicolors for colorscheme compatibility (requires true color terminal like iterm2)
opt.termguicolors = true
opt.background = "dark" -- Set background to dark mode for applicable colorschemes
opt.signcolumn = "yes" -- Always show sign column to prevent text shifting
opt.cursorline = true -- Highlight the current cursor line
opt.showtabline = 0 -- Never display tabline
opt.cmdheight = 0 -- hide cmd if not used
opt.laststatus = 3 -- global statusline
opt.showcmdloc = "statusline"
opt.spell = true
opt.scrolloff = 8 -- Keep 8 lines above and below the cursor

-- Line numbering settings
opt.number = true -- Display absolute line number on the cursor line
opt.relativenumber = true -- Display relative line numbers for other lines

-- Tab & Indentation settings
opt.tabstop = 2 -- Set tab width to 2 spaces
opt.shiftwidth = 2 -- Set indentation width to 2 spaces
opt.expandtab = true -- Use spaces instead of tabs
opt.autoindent = true -- Automatically indent new lines based on the current line

-- Line wrapping settings
opt.wrap = true -- Enable line wrapping

-- Search settings
opt.ignorecase = true -- Search ignoring case
opt.smartcase = true -- Enable case-sensitive search if search pattern has mixed case

-- Backspace behavior
opt.backspace = "indent,eol,start" -- Allow backspace over indentation, end-of-line, and from insert mode start

-- Clipboard settings
opt.clipboard:append("unnamedplus") -- Use system clipboard as the default register

-- Split window settings
opt.splitright = true -- Open vertical splits to the right
opt.splitbelow = true -- Open horizontal splits below

-- File settings
opt.swapfile = false -- Disable swapfile creation
