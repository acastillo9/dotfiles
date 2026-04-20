-- LSP configuration

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
          if
              filetype == "javascript"
              or filetype == "typescript"
              or filetype == "javascriptreact"
              or filetype == "typescriptreact"
          then
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

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("acastillo-lsp-attach", {}),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end

    local bufnr = ev.buf
    local opts = { buffer = bufnr, remap = false }

    -- set keybindings
    vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover" }))
    vim.keymap.set(
      { "n", "v" },
      "<leader>ca",
      vim.lsp.buf.code_action,
      vim.tbl_extend("force", opts, { desc = "Code action" })
    )
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
    vim.keymap.set({ "n", "v" }, "<leader>cf", function()
      vim.lsp.buf.format({ async = true })
    end, vim.tbl_extend("force", opts, { desc = "Format code" }))
    vim.keymap.set("n", "<leader>W", function()
      vim.api.nvim_clear_autocmds({ group = format_group, buffer = bufnr })
      vim.cmd.write()
      create_format_on_save_autocmd(bufnr)
    end, vim.tbl_extend("force", opts, { desc = "Write without formatting", silent = true }))
    vim.keymap.set(
      "n",
      "<leader>wa",
      vim.lsp.buf.add_workspace_folder,
      vim.tbl_extend("force", opts, { desc = "Add workspace folder" })
    )
    vim.keymap.set(
      "n",
      "<leader>wr",
      vim.lsp.buf.remove_workspace_folder,
      vim.tbl_extend("force", opts, { desc = "Remove workspace folder" })
    )
    vim.keymap.set("n", "<leader>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, vim.tbl_extend("force", opts, { desc = "List workspace folders" }))
    vim.keymap.set(
      "n",
      "<leader>cd",
      vim.diagnostic.open_float,
      vim.tbl_extend("force", opts, { desc = "Show line diagnostics" })
    )
    vim.keymap.set(
      "n",
      "<leader>cq",
      vim.diagnostic.setloclist,
      vim.tbl_extend("force", opts, { desc = "Diagnostics to loclist" })
    )
    vim.keymap.set("n", "[d", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
    vim.keymap.set("n", "]d", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
    vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", vim.tbl_extend("force", opts, { desc = "Restart LSP" }))

    -- Enable completion
    if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, bufnr) then
      vim.lsp.inline_completion.enable(true, { bufnr = bufnr })

      vim.keymap.set(
        "i",
        "<C-F>",
        vim.lsp.inline_completion.get,
        { desc = "LSP: accept inline completion", buffer = bufnr }
      )
      vim.keymap.set(
        "i",
        "<C-G>",
        vim.lsp.inline_completion.select,
        { desc = "LSP: switch inline completion", buffer = bufnr }
      )
    end

    if client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      vim.keymap.set("n", "<leader>ch", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
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

-- Diagnostic configuration
local severity = vim.diagnostic.severity

vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    spacing = 2,
    source = "if_many",
    severity = {
      min = severity.WARN,
    },
  },
  signs = {
    text = {
      [severity.ERROR] = " ",
      [severity.WARN] = " ",
      [severity.HINT] = "󰠠 ",
      [severity.INFO] = " ",
    },
  },
})
