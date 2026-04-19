return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "j-hui/fidget.nvim",
    "zbirenbaum/copilot.lua",
    "zbirenbaum/copilot-cmp",
    "b0o/schemastore.nvim",
  },
  config = function()
    -- Setup LSP capabilities
    local capabilities = vim.tbl_deep_extend(
      "force",
      vim.lsp.protocol.make_client_capabilities(),
      require("cmp_nvim_lsp").default_capabilities()
    )

    -- Progress indicator
    require("fidget").setup({})

    -- Setup Mason
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "vue_ls",
        "ts_ls",
        "cssls",
        "astro",
        "emmet_ls",
        "eslint",
        "html",
        "jsonls",
        "svelte",
        "tailwindcss",
        "typos_lsp"
      },
      automatic_enable = false
    })

    -- Setup diagnostics
    local signs = { Error = " ", Warn = " ", Hint = "󰌵 ", Info = "󰋼 " }

    vim.diagnostic.config({
      virtual_text = {
        prefix = "●",
        spacing = 2,
        source = "if_many",
        severity = {
          min = vim.diagnostic.severity.HINT,
        },
      },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = signs.Error,
          [vim.diagnostic.severity.WARN] = signs.Warn,
          [vim.diagnostic.severity.INFO] = signs.Info,
          [vim.diagnostic.severity.HINT] = signs.Hint,
        },
      },
      underline = {
        severity = { min = vim.diagnostic.severity.WARN },
      },
      update_in_insert = false,
      severity_sort = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = true,
        header = "",
        prefix = "",
        max_width = 80,
        max_height = 20,
      },
    })

    -- Setup completions
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    local copilot_cmp = require("copilot_cmp")

    copilot_cmp.setup()

    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body) -- For `luasnip` users.
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),

        -- Tab completion
        -- ['<Tab>'] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     cmp.select_next_item()
        --   elseif luasnip.locally_jumpable(1) then
        --     luasnip.jump(1)
        --   else
        --     fallback()
        --   end
        -- end, { 'i', 's' }),
        --
        -- ['<S-Tab>'] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     cmp.select_prev_item()
        --   elseif luasnip.locally_jumpable(-1) then
        --     luasnip.jump(-1)
        --   else
        --     fallback()
        --   end
        -- end, { 'i', 's' }),
      }),
      sources = cmp.config.sources({
        { name = "copilot",  priority = 1000 },
        { name = 'nvim_lsp', priority = 900 },
        { name = 'luasnip',  priority = 800 },
        { name = 'path',     priority = 700 },
      }, {
        { name = 'buffer', priority = 500 },
      }),
      formatting = {
        format = function(entry, vim_item)
          -- Kind icons
          local kind_icons = {
            Text = "󰉿",
            Method = "󰆧",
            Function = "󰊕",
            Constructor = "",
            Field = "󰜢",
            Variable = "󰀫",
            Class = "󰠱",
            Interface = "",
            Module = "",
            Property = "󰜢",
            Unit = "󰑭",
            Value = "󰎠",
            Enum = "",
            Keyword = "󰌋",
            Snippet = "",
            Color = "󰏘",
            File = "󰈙",
            Reference = "󰈇",
            Folder = "󰉋",
            EnumMember = "",
            Constant = "󰏿",
            Struct = "󰙅",
            Event = "",
            Operator = "󰆕",
            TypeParameter = "",
            Copilot = "",
          }

          -- Source names
          local source_names = {
            nvim_lsp = "[LSP]",
            luasnip = "[Snippet]",
            buffer = "[Buffer]",
            path = "[Path]",
            copilot = "[Copilot]",
          }

          vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
          vim_item.menu = source_names[entry.source.name]

          return vim_item
        end,
      },
    })

    -- Setup LSP servers
    local servers = {
      -- Lua Language Server
      lua_ls = {
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            diagnostics = {
              globals = {
                "vim", "it", "describe", "before_each", "after_each", "bit"
              },
            },
            workspace = {
              -- library = vim.api.nvim_get_runtime_file('', true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
            hint = {
              enable = true,
              setType = true,
            },
            format = {
              enable = true,
              defaultConfig = {
                indent_style = "space",
                indent_size = "2",
              },
            },
          },
        },
      },

      -- TypeScript/JavaScript
      ts_ls = {
        init_options = {
          preferences = {
            disableSuggestions = true,
          },
        },
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        },
        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
        },
      },

      -- ESLint
      eslint = {
        settings = {
          codeAction = {
            disableRuleComment = {
              enable = true,
              location = "separateLine"
            },
            showDocumentation = {
              enable = true
            }
          },
          codeActionOnSave = {
            mode = "all"
          },
          format = true,
          nodePath = nil,
          onIgnoredFiles = "off",
          packageManager = "npm",
          problems = {
            shortenToSingleLine = false
          },
          quiet = false,
          rulesCustomizations = {},
          run = "onType",
          useESLintClass = true,
          validate = "on",
          workingDirectory = {
            mode = "location"
          }
        },
      },

      -- Rust Analyzer
      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              runBuildScripts = true,
            },
            checkOnSave = {
              allFeatures = true,
              command = "clippy",
              extraArgs = { "--no-deps" },
            },
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
            inlayHints = {
              bindingModeHints = {
                enable = false,
              },
              chainingHints = {
                enable = true,
              },
              closingBraceHints = {
                enable = true,
                minLines = 25,
              },
              closureReturnTypeHints = {
                enable = "never",
              },
              lifetimeElisionHints = {
                enable = "never",
                useParameterNames = false,
              },
              maxLength = 25,
              parameterHints = {
                enable = true,
              },
              reborrowHints = {
                enable = "never",
              },
              renderColons = true,
              typeHints = {
                enable = true,
                hideClosureInitialization = false,
                hideNamedConstructor = false,
              },
            },
          },
        },
      },

      -- Vue Language Server
      vue_ls = {
        filetypes = { "vue" },
        init_options = {
          typescript = {
            tsdk = vim.fn.getcwd() .. "/node_modules/typescript/lib",
          },
        },
      },

      -- CSS Language Server
      cssls = {
        settings = {
          css = {
            validate = true,
            lint = {
              unknownAtRules = "ignore",
            },
          },
          scss = {
            validate = true,
            lint = {
              unknownAtRules = "ignore",
            },
          },
          less = {
            validate = true,
            lint = {
              unknownAtRules = "ignore",
            },
          },
        },
        filetypes = { "css", "scss", "less" },
      },

      -- Tailwind CSS
      tailwindcss = {
        settings = {
          tailwindCSS = {
            classAttributes = { "class", "className", "classList", "ngClass" },
            lint = {
              cssConflict = "warning",
              invalidApply = "error",
              invalidConfigPath = "error",
              invalidScreen = "error",
              invalidTailwindDirective = "error",
              invalidVariant = "error",
              recommendedVariantOrder = "warning",
            },
            validate = true,
          },
        },
        filetypes = {
          "html", "css", "scss", "javascript", "typescript",
          "javascriptreact", "typescriptreact", "vue", "astro", "svelte"
        },
      },

      -- JSON Language Server
      jsonls = {
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
        filetypes = { "json", "jsonc" },
      },

      -- HTML Language Server
      html = {
        settings = {
          html = {
            format = {
              templating = true,
              wrapLineLength = 120,
              wrapAttributes = "auto",
            },
            hover = {
              documentation = true,
              references = true,
            },
          },
        },
        filetypes = { "html" },
      },

      -- Emmet Language Server
      emmet_ls = {
        filetypes = {
          "html", "css", "scss", "javascript", "typescript",
          "javascriptreact", "typescriptreact", "vue", "astro", "svelte"
        },
      },

      -- Astro Language Server
      astro = {
        filetypes = { "astro" },
      },

      -- Svelte Language Server
      svelte = {
        filetypes = { "svelte" },
      },

      -- Typos LSP
      typos_lsp = {
        settings = {
          typos = {
            enable = true,
            dictionaries = { "en_US", "es_ES" },
            dictionary_path = vim.fn.expand("~/.config/nvim/dictionaries"),

          },
        },
        filetypes = { "markdown", "text", "gitcommit" },
      },
    }

    local format_group = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
    local highlight_group = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = true })

    local function create_format_on_save_autocmd(bufnr)
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = format_group,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
            bufnr = bufnr,
            filter = function(c)
              local filetype = vim.bo[bufnr].filetype
              if filetype == "javascript" or filetype == "typescript"
                  or filetype == "javascriptreact" or filetype == "typescriptreact" then
                return c.name == "eslint" or c.name == "ts_ls"
              end
              if filetype == "html" or filetype == "css" or filetype == "json" then
                return c.name ~= "ts_ls"
              end
              return true
            end,
          })
        end,
      })
    end

    -- Global diagnostic keymaps (do not require an LSP client)
    vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
    vim.keymap.set("n", "<leader>cq", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })
    vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end,
      { desc = "Previous diagnostic" })
    vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end,
      { desc = "Next diagnostic" })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("acastillo-lsp-attach", { clear = true }),
      callback = function(ev)
        local bufnr = ev.buf
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if not client then return end
        local opts = { buffer = bufnr, remap = false }

        vim.keymap.set("n", "K", vim.lsp.buf.hover,
          vim.tbl_extend("force", opts, { desc = "Hover" }))
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action,
          vim.tbl_extend("force", opts, { desc = "Code action" }))
        vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename,
          vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
        vim.keymap.set({ "n", "v" }, "<leader>cf", function() vim.lsp.buf.format({ async = true }) end,
          vim.tbl_extend("force", opts, { desc = "Format code" }))
        vim.keymap.set("n", "<leader>W", function()
          vim.api.nvim_clear_autocmds({ group = format_group, buffer = bufnr })
          vim.cmd.write()
          create_format_on_save_autocmd(bufnr)
        end, vim.tbl_extend("force", opts, { desc = "Write without formatting", silent = true }))
        vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder,
          vim.tbl_extend("force", opts, { desc = "Add workspace folder" }))
        vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder,
          vim.tbl_extend("force", opts, { desc = "Remove workspace folder" }))
        vim.keymap.set("n", "<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, vim.tbl_extend("force", opts, { desc = "List workspace folders" }))

        if client:supports_method("textDocument/inlayHint") then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          vim.keymap.set("n", "<leader>ch", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
              { bufnr = bufnr })
          end, vim.tbl_extend("force", opts, { desc = "Toggle inlay hints" }))
        end

        if client:supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = format_group, buffer = bufnr })
          create_format_on_save_autocmd(bufnr)
        end

        if client:supports_method("textDocument/documentHighlight") then
          vim.api.nvim_clear_autocmds({ buffer = bufnr, group = highlight_group })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = bufnr,
            group = highlight_group,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = bufnr,
            group = highlight_group,
            callback = vim.lsp.buf.clear_references,
          })
        end

        if client:supports_method("textDocument/codeLens") then
          vim.lsp.codelens.enable(true, { bufnr = bufnr })
        end
      end,
    })

    -- Shared defaults for every server
    vim.lsp.config("*", { capabilities = capabilities })
    for server_name, config in pairs(servers) do
      vim.lsp.config(server_name, config)
    end
    vim.lsp.enable(vim.tbl_keys(servers))
  end
}
