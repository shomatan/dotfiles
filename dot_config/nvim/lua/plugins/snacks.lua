-- snacks.nvim picker設定 (IntelliJ風統合検索)
return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          -- カスタム: Search Everywhere
          search_everywhere = {
            finder = function(opts, ctx)
              local items = {}

              -- 1. ファイル (gitファイル or 全ファイル)
              local ok, git_files = pcall(vim.fn.systemlist, "git ls-files 2>/dev/null")
              if ok and vim.v.shell_error == 0 then
                for _, file in ipairs(git_files) do
                  table.insert(items, {
                    text = file,
                    file = file,
                    category = "File",
                    icon = "",
                  })
                end
              end

              -- 2. コマンド
              for name, cmd in pairs(vim.api.nvim_get_commands({})) do
                table.insert(items, {
                  text = name .. (cmd.definition and ("  " .. cmd.definition) or ""),
                  category = "Cmd",
                  icon = "",
                  cmd = name,
                })
              end

              -- 3. キーマップ
              for _, map in ipairs(vim.api.nvim_get_keymap("n")) do
                if map.desc then
                  table.insert(items, {
                    text = map.desc .. "  [" .. map.lhs .. "]",
                    category = "Key",
                    icon = "",
                    lhs = map.lhs,
                  })
                end
              end

              return items
            end,
            format = function(item, picker)
              local ret = {}
              table.insert(ret, { item.icon .. " ", "Special" })
              table.insert(ret, { "[" .. item.category .. "] ", "Comment" })
              table.insert(ret, { item.text })
              return ret
            end,
            confirm = function(picker, item)
              picker:close()
              if not item then return end
              vim.schedule(function()
                if item.file then
                  vim.cmd("tabedit " .. vim.fn.fnameescape(item.file))
                elseif item.cmd then
                  vim.cmd(item.cmd)
                elseif item.lhs then
                  local keys = vim.api.nvim_replace_termcodes(item.lhs, true, false, true)
                  vim.api.nvim_feedkeys(keys, "m", false)
                end
              end)
            end,
          },
        },
        win = {
          input = {
            keys = {
              ["<CR>"] = { "tab", mode = { "n", "i" } },
              ["<C-t>"] = { "confirm", mode = { "n", "i" } },
            },
          },
        },
      },
    },
    keys = {
      {
        "<leader><leader>",
        function() Snacks.picker.pick("search_everywhere") end,
        desc = "Search Everywhere",
      },
    },
  },
}
