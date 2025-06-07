return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "j-hui/fidget.nvim",
    "zbirenbaum/copilot-cmp",
  },
  config = function()
    local cmp = require('cmp')
    local copilot_cmp = require("copilot_cmp")
    local cmp_lsp = require("cmp_nvim_lsp")
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      cmp_lsp.default_capabilities()
    )

    require("fidget").setup({})
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
    })

    local lspconfig = require('lspconfig')

    lspconfig.eslint.setup({
      capabilities = capabilities,
      on_attach = function(_, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          command = "EslintFixAll",
        })
      end,
    })

    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      settings = {
        Lua = {
          runtime = { version = "Lua 5.1" },
          diagnostics = {
            globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
          }
        }
      }
    })

    lspconfig.ts_ls.setup({
      capabilities = capabilities,
      filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
        "vue",
      },
    })

    lspconfig.rust_analyzer.setup({
      capabilities = capabilities,
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = {
            command = "clippy",
          },
        },
      },
    })

    lspconfig.vuels.setup({
      capabilities = capabilities,
      filetypes = { "vue" },
    })

    lspconfig.cssls.setup({
      capabilities = capabilities,
      filetypes = { "css", "scss", "less" },
    })

    lspconfig.astro.setup({
      capabilities = capabilities,
      filetypes = { "astro" },
    })

    lspconfig.emmet_ls.setup({
      capabilities = capabilities,
      filetypes = { "html", "css", "javascript", "typescript", "vue", "astro" },
    })

    lspconfig.html.setup({
      capabilities = capabilities,
      filetypes = { "html" },
    })

    lspconfig.jsonls.setup({
      capabilities = capabilities,
      filetypes = { "json", "jsonc" },
    })

    lspconfig.svelte.setup({
      capabilities = capabilities,
      filetypes = { "svelte" },
    })

    lspconfig.tailwindcss.setup({
      capabilities = capabilities,
      filetypes = { "html", "css", "javascript", "typescript", "vue", "astro" },
    })

    lspconfig.typos_lsp.setup({
      capabilities = capabilities,
      filetypes = { "markdown", "text" },
      settings = {
        typos = {
          enable = true,
          dictionaries = { "en_US", "es_ES" },
          dictionary_path = "~/.config/nvim/dictionaries",
        },
      },
    })

    copilot_cmp.setup()

    local cmp_select = { behavior = cmp.SelectBehavior.Select }
    cmp.setup({
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
      }),
      sources = cmp.config.sources({
        { name = "copilot" },
        { name = 'nvim_lsp' },
        { name = 'luasnip' }, -- For luasnip users.
      }, {
        { name = 'buffer' },
      })
    })

    local signs = { Error = " ", Warn = " ", Hint = "󰌵 ", Info = "󰋼 " }
    vim.diagnostic.config({
      virtual_text = {
        prefix = "●",
        spacing = 2,
      },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = signs.Error,
          [vim.diagnostic.severity.WARN] = signs.Warn,
          [vim.diagnostic.severity.INFO] = signs.Info,
          [vim.diagnostic.severity.HINT] = signs.Hint,
        },
      },
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    })
  end
}
