-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt
opt.spelllang = { "en", "cjk" }

-- ウィンドウ区切り線の設定
opt.fillchars = {
  vert = "│",
  horiz = "─",
  horizup = "┴",
  horizdown = "┬",
  vertleft = "┤",
  vertright = "├",
  verthoriz = "┼",
}

-- 背景透過設定
local function set_transparent()
  local groups = {
    "Normal",
    "NormalNC",
    "NormalFloat",
    "FloatBorder",
    "SignColumn",
    "EndOfBuffer",
    "MsgArea",
    "TelescopeNormal",
    "TelescopeBorder",
    "NeoTreeNormal",
    "NeoTreeNormalNC",
  }
  for _, group in ipairs(groups) do
    vim.api.nvim_set_hl(0, group, { bg = "NONE", ctermbg = "NONE" })
  end
  -- ウィンドウ区切り線の色（背景透過対応）
  vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#565f89", bg = "NONE" })
end

vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
  pattern = "*",
  callback = set_transparent,
})

-- 遅延後にも適用（プラグインが上書きする場合の対策）
vim.defer_fn(set_transparent, 100)
