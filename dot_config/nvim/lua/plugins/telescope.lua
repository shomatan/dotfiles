-- Telescope設定
return {
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      local actions = require("telescope.actions")

      -- ファイル選択系のpickerのみ: Enterで新しいタブ、Ctrl+tで現在ウィンドウ
      local file_picker_mappings = {
        i = {
          ["<CR>"] = actions.select_tab,
          ["<C-t>"] = actions.select_default,
        },
        n = {
          ["<CR>"] = actions.select_tab,
          ["<C-t>"] = actions.select_default,
        },
      }

      opts.pickers = opts.pickers or {}
      opts.pickers.find_files = { mappings = file_picker_mappings }
      opts.pickers.git_files = { mappings = file_picker_mappings }
      opts.pickers.oldfiles = { mappings = file_picker_mappings }
      opts.pickers.buffers = { mappings = file_picker_mappings }

      return opts
    end,
  },
}
