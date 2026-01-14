-- Flutter/Dart開発環境
return {
  {
    "akinsho/flutter-tools.nvim",
    ft = { "dart" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
      "mfussenegger/nvim-dap",
    },
    config = function()
      -- Dartアダプターを登録
      local dap = require("dap")
      dap.adapters.dart = {
        type = "executable",
        command = "flutter",
        args = { "debug_adapter" },
      }

      -- VSCodeのlaunch.jsonを読み込み、デフォルト値を補完
      dap.configurations.dart = {}  -- 既存設定をクリア（重複防止）
      require("dap.ext.vscode").load_launchjs(nil, { dart = { "dart" } })
      if dap.configurations.dart then
        for _, config in ipairs(dap.configurations.dart) do
          if not config.program then
            config.program = vim.fn.getcwd() .. "/lib/main.dart"
          end
          if not config.cwd then
            config.cwd = vim.fn.getcwd()
          end
          -- argsをtoolArgsに変換（flutter runコマンドに渡すため）
          if config.args and not config.toolArgs then
            config.toolArgs = config.args
            config.args = nil
          end
        end
      end

      require("flutter-tools").setup({
        flutter_lookup_cmd = "mise where flutter",
        ui = {
          border = "rounded",
        },
        decorations = {
          statusline = {
            app_version = true,
            device = true,
          },
        },
        debugger = {
          enabled = true,
          run_via_dap = true,
        },
        widget_guides = {
          enabled = true,
        },
        closing_tags = {
          enabled = true,
          prefix = "// ",
        },
        lsp = {
          color = {
            enabled = true,
          },
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            analysisExcludedFolders = {
              vim.fn.expand("$HOME/.pub-cache"),
            },
            renameFilesWithClasses = "prompt",
            enableSnippets = true,
            updateImportsOnRename = true,
          },
        },
      })

      -- Flutter キーバインド (<leader>df 系)
      vim.keymap.set("n", "<leader>dfr", ":FlutterRestart<CR>", { desc = "Flutter Restart" })
      vim.keymap.set("n", "<leader>dfl", ":FlutterReload<CR>", { desc = "Flutter Reload (Hot)" })
      vim.keymap.set("n", "<leader>dfq", ":FlutterQuit<CR>", { desc = "Flutter Quit" })
      vim.keymap.set("n", "<leader>dfd", ":FlutterDevices<CR>", { desc = "Flutter Devices" })
      vim.keymap.set("n", "<leader>dfe", ":FlutterEmulators<CR>", { desc = "Flutter Emulators" })
      vim.keymap.set("n", "<leader>dfo", ":FlutterOutlineToggle<CR>", { desc = "Flutter Outline" })
      vim.keymap.set("n", "<leader>dft", ":FlutterDevTools<CR>", { desc = "Flutter DevTools" })
    end,
  },

  -- Dart treesitter パーサー追加
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "dart" })
      end
    end,
  },

}
