-- blink.cmp: markdownファイルで補完を無効化
return {
  {
    "saghen/blink.cmp",
    opts = {
      enabled = function()
        -- markdownファイルでは補完を無効化
        return vim.bo.filetype ~= "markdown"
      end,
    },
  },
}
