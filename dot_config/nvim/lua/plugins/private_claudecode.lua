return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" }, -- ターミナル表示にsnacks.nvimを使用
    event = "VeryLazy",
    opts = {
      -- ターミナル設定
      terminal = {
        split_side = "right", -- 右側splitで表示
        split_width_percentage = 0.30,
      },
      -- Claude Code起動時のコマンドライン引数
      terminal_cmd = "claude --dangerously-skip-permissions",
    },
    keys = {
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Claude切り替え" },
      { "<leader>af", "<cmd>ClaudeCodeOpen<cr>", desc = "Claudeフォーカス" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "再開" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "継続" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "モデル選択" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "バッファ追加" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", desc = "選択範囲送信", mode = "v" },
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "差分受け入れ" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "差分拒否" },
    },
  },
}
