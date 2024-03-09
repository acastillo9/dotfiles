return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  build = ":Copilot auth",
  event = "InsertEnter",
  opts = {
    suggestion = { enabled = false },
    panel = { enabled = false },
  },
  config = function(_, opts)
    local copilot_enabled = require("neoconf").get("copilot_enabled", true)
    if not copilot_enabled then
      return
    end
    require("copilot").setup(opts)
  end,
}
