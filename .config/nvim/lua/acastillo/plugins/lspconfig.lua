return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    "folke/neoconf.nvim",
  },
  config = function()
    local lspconfig = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local keymap = vim.keymap

    local neoconf = require("neoconf")
    neoconf.setup()

    local opts = { noremap = true, silent = true }

    local on_attach = function(_, bufnr)
      opts.buffer = bufnr

      opts.desc = "Show LSP references"
      keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

      opts.desc = "Go to declaration"
      keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

      opts.desc = "Show LSP definitions"
      keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

      opts.desc = "Show LSP implementations"
      keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

      opts.desc = "Show LSP type definitions"
      keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

      opts.desc = "See available code actions"
      keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

      opts.desc = "Smart rename"
      keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

      opts.desc = "Show buffer diagnostics"
      keymap.set("n", "<leader>bd", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

      opts.desc = "Show line diagnostics"
      keymap.set("n", "<leader>ld", vim.diagnostic.open_float, opts)

      opts.desc = "Go to previous diagnostic"
      keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

      opts.desc = "Go to next diagnostic"
      keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

      opts.desc = "Show documentation"
      keymap.set("n", "K", vim.lsp.buf.hover, opts)

      opts.desc = "Restart LSP"
      keymap.set("n", "<leader>rs", "<cmd>LspRestart<CR>", opts)
    end

    local capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

    local signs = { Error = " ", Warn = " ", Hint = "󰌵 ", Info = "󰋼 " }

    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- find a typescript to use for volar, try to use the one installed on the project otherwise use the global installed
    local util = require("lspconfig.util")
    local function get_typescript_server_path(root_dir)
      local global_ts = "/opt/homebrew/lib/node_modules/typescript/lib"
      local found_ts = ""
      local function check_dir(path)
        found_ts = util.path.join(path, "node_modules", "typescript", "lib")
        if util.path.exists(found_ts) then
          return path
        end
      end
      if util.search_ancestors(root_dir, check_dir) then
        return found_ts
      else
        return global_ts
      end
    end

    local servers = {
      bashls = {
        capabilities = capabilities,
        on_attach = on_attach,
      },
      cssls = {
        capabilities = capabilities,
        on_attach = on_attach,
      },
      emmet_ls = {
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = {
          "html",
          "typescriptreact",
          "javascriptreact",
          "css",
          "sass",
          "scss",
          "less",
          "svelte",
          "vue",
          "astro",
        },
      },
      html = {
        capabilities = capabilities,
        on_attach = on_attach,
      },
      lua_ls = {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = {
                vim.fn.expand("$VIMRUNTIME/lua"),
                vim.fn.expand("$XDG_CONFIG_HOME") .. "/nvim/lua",
              },
            },
          },
        },
      },
      svelte = {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)

          vim.api.nvim_create_autocmd("BufWritePost", {
            pattern = { "*.js", "*.ts" },
            callback = function(ctx)
              if client.name == "svelte" then
                client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
              end
            end,
          })
        end,
      },
      tailwindcss = {
        capabilities = capabilities,
        on_attach = on_attach,
      },
      tsserver = {
        capabilities = capabilities,
        on_attach = on_attach,
        init_options = {
          plugins = {
            {
              name = "@vue/typescript-plugin",
              location = "/opt/homebrew/lib/node_modules/@vue/typescript-plugin",
              languages = { "javascript", "typescript", "vue" },
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
          "vue",
        },
      },
      volar = {
        capabilities = capabilities,
        on_attach = on_attach,
        on_new_config = function(new_config, new_root_dir)
          new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
        end,
      },
      jsonls = {
        capabilities = capabilities,
        on_attach = on_attach,
      },
      astro = {
        capabilities = capabilities,
        on_attach = on_attach,
      },
    }

    for server, config in pairs(servers) do
      lspconfig[server].setup(config)
    end
  end,
}
