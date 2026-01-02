-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- ターミナルモードから抜ける（分割キーボード向け）
vim.keymap.set('t', '<C-j><C-j>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- ターミナルモードからAIビューを閉じる
vim.keymap.set('t', '<C-j>q', '<C-\\><C-n>:q<CR>', { desc = 'Exit terminal and close window' })
