return {
  -- neo-treeを無効化
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },

  -- oil.nvimを追加
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false, -- ディレクトリを開いた時にすぐ使えるように
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
      { "<leader>e", "<cmd>Oil<cr>", desc = "Explorer (Oil)" },
    },
    opts = {
      default_file_explorer = true, -- netrwを置き換える
      view_options = {
        show_hidden = true,
      },
      keymaps = {
        ["q"] = "actions.close",
        ["<C-h>"] = false, -- ウィンドウ移動を優先
        ["<C-l>"] = false,
        ["<C-r>"] = "actions.refresh",
      },
    },
  },
}
