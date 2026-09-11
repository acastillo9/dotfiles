# AGENTS.md

Personal dotfiles repo managed with GNU stow. There is no build, test, or lint step — this is plain config, not a software project.

## Layout & installation

- Each top-level directory is a stow package whose contents mirror `$HOME`. No install script or README exists; symlinks are created manually with `stow` (e.g. `stow nvim`). Don't invent an installer.
- Two package shapes coexist:
  - Home-level dotfiles at the package root: `zshrc/.zshrc`, `tmux/.tmux.conf`, `aerospace/.aerospace.toml`
  - XDG config under `.config/<app>/`: `nvim`, `ghostty`, `hypr`, `i3`, `waybar`, `rofi`, `polybar`, `picom`, `starship`
- `obsidian/.obsidian/plugins/` is gitignored (`obsidian/.obsidian/.gitignore`), so third-party plugin sources are not tracked.

## Conventions

- Theme is Catppuccin Mocha across the repo (rofi, ghostty, waybar, nvim). Match it when editing color/theme files.

## Neovim (`nvim/`)

- Read `nvim/.config/nvim/CLAUDE.md` before touching Neovim config — it documents the architecture, plugins, and keymaps in detail.
- Plugin specs live in `nvim/.config/nvim/lua/acastillo/lazy/` and are auto-imported by `lazy_init.lua`; any `.lua` file there is picked up. To disable a plugin, rename with a `.disabled`/`.off` suffix (e.g. `noob.lua.off`, `jsonls.lua.disabled`) — lazy.nvim only loads `.lua` files.
- `nvim/.config/nvim/lazy-lock.json` is a lazy.nvim-generated lockfile — do not hand-edit it.
