return {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = {
          "vim", "it", "describe", "before_each", "after_each", "bit",
        },
      },
      workspace = {
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
}
