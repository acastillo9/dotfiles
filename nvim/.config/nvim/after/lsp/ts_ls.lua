local inlay_hints = {
  includeInlayParameterNameHints = "all",
  includeInlayParameterNameHintsWhenArgumentMatchesName = false,
  includeInlayFunctionParameterTypeHints = true,
  includeInlayVariableTypeHints = true,
  includeInlayPropertyDeclarationTypeHints = true,
  includeInlayFunctionLikeReturnTypeHints = true,
  includeInlayEnumMemberValueHints = true,
}

return {
  init_options = {
    preferences = {
      disableSuggestions = true,
    },
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = vim.fn.expand(
          "$MASON/packages/vue-language-server/node_modules/@vue/typescript-plugin"
        ),
        languages = { "vue" },
      },
    },
  },
  settings = {
    typescript = { inlayHints = inlay_hints },
    javascript = { inlayHints = inlay_hints },
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
}
