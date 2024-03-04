return {
  "rebelot/heirline.nvim",
  event = "BufEnter",
  config = function()
    local heirline = require("heirline")
    local conditions = require("heirline.conditions")
    local utils = require("heirline.utils")

    local colors = {
      blue = "#61afef",
      green = "#98c379",
      dark_grey = "#5c5c5c",
      purple = "#c678dd",
      bright_red = "#ec5f67",
      bright_yellow = "#ebae34",
    }

    local function setup_colors()
      return {
        fg = utils.get_highlight("Statusline").fg,
        bg = utils.get_highlight("Statusline").bg,
        inactive = colors.dark_grey,
        normal = colors.blue,
        insert = colors.green,
        visual = colors.purple,
        replace = colors.bright_red,
        command = colors.bright_yellow,
        terminal = colors.green,
        git_branch_fg = utils.get_highlight("Conditional").fg,
        git_added = utils.get_highlight("GitSignsAdd").fg,
        git_changed = utils.get_highlight("GitSignsChange").fg,
        git_removed = utils.get_highlight("GitSignsDelete").fg,
        diag_ERROR = utils.get_highlight("DiagnosticError").fg,
        diag_WARN = utils.get_highlight("DiagnosticWarn").fg,
        diag_INFO = utils.get_highlight("DiagnosticInfo").fg,
        diag_HINT = utils.get_highlight("DiagnosticHint").fg,
        treesitter_fg = utils.get_highlight("String").fg,
        scrollbar = utils.get_highlight("TypeDef").fg,
      }
    end

    heirline.load_colors(setup_colors())

    local ViMode = {
      init = function(self)
        self.mode = vim.fn.mode(1)
      end,
      static = {
        mode_colors = {
          n = "normal",
          i = "insert",
          v = "visual",
          V = "visual",
          ["\22"] = "visual",
          c = "command",
          s = "visual",
          S = "visual",
          ["\19"] = "visual",
          R = "replace",
          r = "inactive",
          ["!"] = "inactive",
          t = "terminal",
        },
      },
      provider = " ",
      hl = function(self)
        local mode = self.mode:sub(1, 1) -- get only the first mode character
        return { bg = self.mode_colors[mode] }
      end,
      update = {
        "ModeChanged",
        pattern = "*:*",
        callback = vim.schedule_wrap(function()
          vim.cmd("redrawstatus")
        end),
      },
    }

    local GitBranch = {
      condition = conditions.is_git_repo,
      init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
        self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
      end,
      {
        provider = function(self)
          return " " .. self.status_dict.head .. "  "
        end,
        hl = { fg = "git_branch_fg", bold = true },
      },
    }

    local Filename = {
      init = function(self)
        local filename = vim.api.nvim_buf_get_name(0)
        local extension = vim.fn.fnamemodify(filename, ":e")
        self.icon, self.icon_color =
          require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
        self.filename = filename
      end,
      utils.surround({ "", " " }, nil, {
        {
          provider = function(self)
            return self.icon .. " "
          end,
          hl = function(self)
            return { fg = self.icon_color }
          end,
        },
        {
          provider = function(self)
            local filename = vim.fn.fnamemodify(self.filename, ":.")
            if filename == "" then
              return "[No Name]"
            end
            if not conditions.width_percent_below(#filename, 0.25) then
              filename = vim.fn.pathshorten(filename)
            end
            return filename .. " "
          end,
        },
        {
          condition = function()
            local buffer = vim.bo[0]
            return not buffer.modifiable or buffer.readonly
          end,
          {
            provider = function()
              return " "
            end,
          },
        },
      }),
    }

    local GitDiff = {
      init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
      end,
      condition = function()
        local status = vim.b.gitsigns_status_dict
        return status and (status.added or 0) + (status.removed or 0) + (status.changed or 0) > 0
      end,
      utils.surround({ "", " " }, nil, {
        {
          condition = function(self)
            return self.status_dict.added > 0
          end,
          {
            provider = function(self)
              return " " .. self.status_dict.added .. " "
            end,
            hl = { fg = "git_added", bold = true },
          },
        },
        {
          condition = function(self)
            return self.status_dict.changed > 0
          end,
          {
            provider = function(self)
              return " " .. self.status_dict.changed .. " "
            end,
            hl = { fg = "git_changed", bold = true },
          },
        },
        {
          condition = function(self)
            return self.status_dict.removed > 0
          end,
          {
            provider = function(self)
              return " " .. self.status_dict.removed .. " "
            end,
            hl = { fg = "git_removed", bold = true },
          },
        },
      }),
    }

    local Diagnostics = {
      condition = conditions.has_diagnostics,
      static = {
        error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
        warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
        info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
        hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
      },
      init = function(self)
        self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
      end,
      update = { "DiagnosticChanged", "BufEnter" },
      utils.surround({ "", " " }, nil, {
        {
          condition = function(self)
            return self.errors > 0
          end,
          {
            provider = function(self)
              return " " .. self.errors .. " "
            end,
            hl = { fg = "diag_ERROR", bold = true },
          },
        },
        {
          condition = function(self)
            return self.warnings > 0
          end,
          {
            provider = function(self)
              return " " .. self.warnings .. " "
            end,
            hl = { fg = "diag_WARN", bold = true },
          },
        },
        {
          condition = function(self)
            return self.info > 0
          end,
          {
            provider = function(self)
              return "󰋼 " .. self.info .. " "
            end,
            hl = { fg = "diag_INFO", bold = true },
          },
        },
        {
          condition = function(self)
            return self.hints > 0
          end,
          {
            provider = function(self)
              return "󰌵 " .. self.hints .. " "
            end,
            hl = { fg = "diag_HINT", bold = true },
          },
        },
      }),
    }

    local Fill = {
      provider = "%=",
    }

    local MacroRecording = {
      condition = function()
        return vim.fn.reg_recording() ~= ""
      end,
      update = {
        "RecordingEnter",
        "RecordingLeave",
      },
      {
        provider = function()
          local register = vim.fn.reg_recording()
          return " " .. "@" .. register .. "  "
        end,
      },
    }

    local SearchCount = {
      condition = function()
        return vim.v.hlsearch ~= 0
      end,
      {
        provider = function()
          local search = vim.fn.searchcount()
          return " "
            .. string.format(
              "%s%d/%s%d",
              search.current > search.maxcount and ">" or "",
              math.min(search.current, search.maxcount),
              search.incomplete == 2 and ">" or "",
              math.min(search.total, search.maxcount)
            )
            .. "  "
        end,
      },
    }

    local ShowCmd = {
      condition = function()
        return vim.opt.showcmdloc:get() == "statusline"
      end,
      {
        provider = function()
          return ("%%%d.%d(%%S%%)"):format(0, 5)
        end,
      },
    }

    local LspProgress = {
      provider = require("lsp-progress").progress,
      update = {
        "User",
        pattern = "LspProgressStatusUpdated",
        callback = vim.schedule_wrap(function()
          vim.cmd("redrawstatus")
        end),
      },
    }

    local LSPActive = {
      update = { "LspAttach", "LspDetach" },
      provider = function()
        local names = {}
        for _, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
          table.insert(names, server.name)
        end
        return "[" .. table.concat(names, " ") .. "]"
      end,
    }

    local Lsp = {
      condition = conditions.lsp_attached,
      utils.surround({ "  ", "" }, nil, LspProgress),
      utils.surround({ " ", "" }, nil, LSPActive),
    }

    local Treesitter = {
      condition = function()
        local parsers = require("nvim-treesitter.parsers")
        return parsers.has_parser(parsers.get_buf_lang(vim.api.nvim_get_current_buf()))
      end,
      provider = "   TS",
      hl = { fg = "treesitter_fg" },
    }

    local Ruler = {
      provider = function()
        local line = vim.fn.line(".")
        local char = vim.fn.virtcol(".")
        return string.format("  %3d:%-2d", line, char)
      end,
    }

    local Percentage = {
      provider = function()
        local text = " %2p%%"
        local current_line = vim.fn.line(".")
        if current_line == 1 then
          text = "Top"
        elseif current_line == vim.fn.line("$") then
          text = "Bot"
        end
        return text
      end,
    }

    local Scrollbar = {
      provider = function()
        local sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }
        local curr_line = vim.api.nvim_win_get_cursor(0)[1]
        local lines = vim.api.nvim_buf_line_count(0)
        local i = math.floor((curr_line - 1) / lines * #sbar) + 1
        return string.rep(sbar[i], 2)
      end,
      hl = { fg = "scrollbar" },
    }

    heirline.setup({
      statusline = {
        hl = { fg = "fg", bg = "bg" },
        utils.surround({ "", "  " }, nil, ViMode),
        GitBranch,
        Filename,
        GitDiff,
        Diagnostics,
        Fill,
        MacroRecording,
        SearchCount,
        ShowCmd,
        Fill,
        Lsp,
        Treesitter,
        Ruler,
        Percentage,
        utils.surround({ " ", "" }, nil, Scrollbar),
        utils.surround({ "  ", "" }, nil, ViMode),
      },
      -- winbar = {
      --   init = function(self)
      --     self.bufnr = vim.api.nvim_get_current_buf()
      --   end,
      --   fallthrough = false,
      --   {
      --     condition = function()
      --       return not vim.api.nvim_get_current_win() == tonumber(vim.g.actual_curwin)
      --     end,
      --     status.component.separated_path(),
      --     status.component.file_info({
      --       file_icon = { hl = status.hl.file_icon("winbar"), padding = { left = 0 } },
      --       file_modified = false,
      --       file_read_only = false,
      --       hl = status.hl.get_attributes("winbarnc", true),
      --       surround = false,
      --       update = "BufEnter",
      --     }),
      --   },
      --   status.component.breadcrumbs({ hl = status.hl.get_attributes("winbar", true) }),
      -- },
    })
  end,
}
