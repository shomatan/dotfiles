-- Telescope設定
return {
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      local actions = require("telescope.actions")
      opts.defaults = opts.defaults or {}
      opts.defaults.mappings = opts.defaults.mappings or {}
      opts.defaults.mappings.i = opts.defaults.mappings.i or {}
      opts.defaults.mappings.n = opts.defaults.mappings.n or {}

      -- Enterでタブを開く、Ctrl+tで現在のウィンドウで開く
      opts.defaults.mappings.i["<CR>"] = actions.select_tab
      opts.defaults.mappings.n["<CR>"] = actions.select_tab
      opts.defaults.mappings.i["<C-t>"] = actions.select_default
      opts.defaults.mappings.n["<C-t>"] = actions.select_default

      return opts
    end,
  },
}
