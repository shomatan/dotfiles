return {
  {
    "folke/sidekick.nvim",
    event = "VeryLazy",
    opts = {
      nes = { enabled = false }, -- Copilot LSP 不要
      cli = {
        name = "claude",
        mux = { enabled = false }, -- tmux/zellij 不要
        tools = {
          claude = { cmd = { "claude", "--dangerously-skip-permissions" } },
        },
      },
    },
    keys = {
      { "<leader>aa", function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end, desc = "Open Claude Code" },
    },
  },
}
