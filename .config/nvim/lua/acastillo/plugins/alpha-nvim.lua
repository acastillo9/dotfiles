return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Set header
    dashboard.section.header.val = {
      "      ",
      "     ",
      "                                               ,▄▄R▀▀█████████▓▓▄,",
      "                                           ,Æ▀▀└▄▄▓█████████████████▄",
      "                                        ▄▓▀▀▀▀▀████████████████████████",
      "                         ,╓▄▄,       ,▓█═─.╒▓████████████▀▀▀▀▀▀▀▀███████▄",
      "                     ,▓██████████▄ ╓█▀▀▀▀███▓███████▀╙─            ╙█████▌",
      "                    ▓▓▄▄▓███████████▄, ╓██▓██████▀─                  ╙████▌",
      "                   █─ ┌▄▓████▀─ ▓▀╙└╙▀█████████└                      └████",
      "                  ╫▀▀▀▀█████¬ ,██▄▄,╔██▓█████└          ╓▄═╗¥▄,        ╙███⌐",
      "                  █  ██████─ ,█╙ ─╙████████▌       ,▄Æ▓████▀└└└└¬       ███⌐",
      "                 j█▀▀▀█████ ┌██▄▄▄█▓▓██████    ,▄▓█▀▓███▓█─             ███─",
      "                 ▐⌐ ▐█▓▓███ █▌  ╙██████████████▀▀,▓███╣▀▐▀              ███",
      "                 ▐█▀██████████ █████████████╟▀ `▄█████└,▌              ▐██▌",
      "                 █▌ ▄▓█████¬███████████████    ▄█████ ▄▀      ▄       ▄███",
      "             ▓   ╟███████▀ ▐▀└     ┌╨█╞╫╫▌█   ▐███▀▄#▀        ╙█▄▄▄▄▓███▀",
      "             ╟█▓▄ ╙╙╙╬▀█  ² Ç       ╓`    ▄▀▄██▀▄█▌              ╙╙▀╙└",
      "              ▌▀█╬    ╙█▌   ▀   ,▄▀█▌  ,╓▄▓██████████▓m",
      "               ╗─█ w   ╟    ▄ ─▓█▓▌█    █████████████▀═ç",
      "                ╙▀█▄▌  ╞ /  ╚╙██▄▄m    ]▌╫████████████▄",
      "                   └█▌ ╫ └    ██▌     ▄█ ▐▌█████╣███████,",
      "                    ▐▌ ▌   ,  ╙▌▀▄J▓█▌╙  ]█╫████▌██████╙█▌",
      "                    ▐▌ ▌   ╟   ╙µ  └█▀ , ██▓████▌███████µ ▀╖",
      "                    ▐▌ ⌐  ,   └▌▌█ ▓└ ▄█████████▐██▌██└██",
      "                    ▐▌j   ,┐L  ╚ ██,╥██████████▓█▌██╫█  █",
      "                    ▓▌▐µ▓██▀    ▐█╓█████████████▀ ╞▌█─  █",
      "                    ╙▀███▀─   ▄███████████╣███▀└  ╝    /",
      "                     ▓└██  ▄▓▀]███████▀█▀▓█▀╙    `",
      "                     └▀▀██▀█╒▄███████ ╫▌██",
      "                        ╙▓▄█████████▀ ╙▓▌",
      "                         ╙█████╬████   █",
      "                          ╙█╣████████  ▌",
      "                           █ ▀█████µ ▀-└",
      "                          ,`   ▀███",
      "                                 ██",
      "                                  ─▌",
      "     ",
      "                                         _       ",
      "                         ___ ___ ___ _ _|_|_____ ",
      "                        |   | -_| . | | | |     |",
      "                        |_|_|___|___|\\_/|_|_|_|_|",
      "                                                 ",
    }

    -- Set menu
    dashboard.section.buttons.val = {
      dashboard.button("e", "  > New File", "<cmd>ene<CR>"),
      dashboard.button("SPC e", "  > Toggle file explorer", "<cmd>Neotree toggle<CR>"),
      dashboard.button("SPC ff", "󰱼  > Find File", "<cmd>Telescope find_files<CR>"),
      dashboard.button("SPC fw", "  > Find Word", "<cmd>Telescope live_grep<CR>"),
      dashboard.button("SPC wr", "󰁯  > Restore Session For Current Directory", "<cmd>SessionRestore<CR>"),
      dashboard.button("q", "  > Quit NVIM", "<cmd>qa<CR>"),
    }

    -- Send config to alpha
    alpha.setup(dashboard.opts)

    -- Disable folding on alpha buffer
    vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
  end,
}
