return {
  {
    "okuuva/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },
    opts = {
      enabled = true,
      -- 保存トリガー
      trigger_events = {
        immediate_save = { "BufLeave", "FocusLost" },
        defer_save = { "InsertLeave", "TextChanged" },
      },
      -- Oil等の特定バッファを除外
      condition = function(buf)
        local filetype = vim.bo[buf].filetype
        local buftype = vim.bo[buf].buftype
        -- 除外: oil, 特殊バッファ, 読み取り専用
        if filetype == "oil" or buftype ~= "" then
          return false
        end
        if vim.fn.getbufvar(buf, "&modifiable") == 0 then
          return false
        end
        return true
      end,
      debounce_delay = 1000, -- 1秒待機
    },
  },
}
