# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A personal Neovim configuration managed as part of a dotfiles repo. The config lives at `nvim/.config/nvim/` and is symlinked to `~/.config/nvim/` via stow (or similar). Target: Neovim 0.11+ (uses `vim.lsp.config` / `vim.lsp.enable`, `vim.diagnostic.jump`, `vim.hl.on_yank`).

## Architecture

Entry point: `init.lua` → `lua/acastillo/init.lua`, which loads in order:
1. `options.lua` — vim options
2. `mappings.lua` — global keymaps (`<Space>` leader)
3. `autocmds.lua` — yank highlight, trailing-whitespace stripping (skips markdown/diff/gitcommit/mail), treesitter enablement for a known filetype list
4. `lazy_init.lua` — bootstraps lazy.nvim and auto-imports all specs from `lua/acastillo/lazy/`

Plugin specs live in `lua/acastillo/lazy/`. Each file returns a lazy.nvim plugin spec table. `lazy_init.lua` uses `spec = "acastillo.lazy"`, so any `.lua` file in that directory is automatically picked up.

Convention: to temporarily disable a plugin, rename the file with a `.disabled` suffix (e.g. `foo.lua.disabled`) or delete it — lazy.nvim only picks up `.lua` files.

## Key plugins

- **snacks.nvim** (`lazy/snacks.lua`) — picker/finder, file explorer, lazygit, terminal, notifications, zen mode, scratch buffers, indent guides, scroll, statuscolumn, undo picker (`<leader>su`)
- **LSP** (`lazy/lsp.lua`) — mason + mason-lspconfig manages server installs. Servers configured: `lua_ls`, `ts_ls`, `eslint`, `rust_analyzer`, `vue_ls`, `cssls`, `tailwindcss`, `jsonls`, `html`, `emmet_ls`, `astro`, `svelte`, `typos_lsp`. Wired via `vim.lsp.config` / `vim.lsp.enable` + a single `LspAttach` autocmd.
- **nvim-cmp** (`lazy/lsp.lua`) — completion; sources: copilot > nvim_lsp > luasnip > path > buffer
- **harpoon2** (`lazy/harpoon.lua`) — file bookmarks
- **treesitter** (`lazy/treesitter.lua`) — syntax + treesitter-context
- **trouble.nvim** (`lazy/trouble.lua`) — owns `<leader>cs` (symbols), `<leader>cl` (LSP panel), `<leader>xx`/`<leader>xX` (diagnostics)
- **LuaSnip** (`lazy/snippets.lua`) — snippets with friendly-snippets
- **copilot.lua + copilot-cmp** (`lazy/copilot.lua`) — AI completions via cmp only (suggestion/panel disabled)
- **oil.nvim** (`lazy/oil.lua`) — file manager (`<leader>m`)
- **mini.icons** (`lazy/init.lua`) — icon provider; mocks `nvim-web-devicons` for plugins that require it
- Misc: `quicker.nvim` (quickfix UI), `nvim-autopairs`, `nvim-ts-autotag`, `nvim-surround`, `vim-tmux-navigator`, `catppuccin`, `noob.lua` (which-key + hardtime + precognition + vim-be-good)

## Important keymaps

**Leader** = `<Space>`

| Key | Action |
|-----|--------|
| `<leader><space>` | Smart file picker (Snacks) |
| `<leader>ff` / `<leader>fg` | Find files / git files |
| `<leader>/` | Grep |
| `<leader>e` | File explorer |
| `<leader>m` | Oil (parent dir) |
| `<leader>gg` | Lazygit (via Snacks) |
| `<c-/>` | Toggle terminal |
| `<leader>ha` / `<leader>hl` | Harpoon add / list |
| `<leader>h1-4` | Harpoon jump to slot |
| `gd` / `gD` / `gR` / `gI` / `gy` | LSP go-to (via Snacks picker) |
| `K` | LSP hover |
| `<C-S>` | Signature help (insert mode, Neovim 0.11 default) |
| `<leader>ca` | Code action |
| `<leader>cr` | Rename symbol |
| `<leader>cf` | Format (async) |
| `<leader>W` | Write without formatting |
| `<leader>cd` | Show diagnostics float |
| `[d` / `]d` | Prev / next diagnostic (`vim.diagnostic.jump`) |
| `<leader>cs` / `<leader>cl` | Trouble symbols / LSP panel |
| `<leader>xx` / `<leader>xX` | Trouble diagnostics (all / buffer) |
| `<leader>su` | Undo history picker (Snacks) |
| `<leader><leader>` | Source current file |

## Format on save

Format-on-save is set up per-buffer via the `LspAttach` autocmd when a client that supports `textDocument/formatting` attaches. JS/TS files prefer `eslint`/`ts_ls`; HTML/CSS/JSON exclude `ts_ls`. `<leader>W` writes once without triggering the format autocmd.

## Adding a new plugin

Create a new file in `lua/acastillo/lazy/` returning a valid lazy.nvim spec — it's auto-loaded. No need to register it anywhere else.
