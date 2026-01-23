-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- バッファが空になったらOilを開く
vim.api.nvim_create_autocmd("BufDelete", {
  callback = function()
    vim.schedule(function()
      local bufs = vim.tbl_filter(function(b)
        return vim.api.nvim_buf_is_valid(b)
          and vim.bo[b].buflisted
          and vim.api.nvim_buf_get_name(b) ~= ""
      end, vim.api.nvim_list_bufs())

      if #bufs == 0 then
        require("oil").open()
      end
    end)
  end,
})
