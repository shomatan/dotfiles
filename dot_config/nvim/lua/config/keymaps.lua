-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- ============================================
-- WezTermとの統一キーバインド
-- Ctrl = WezTerm、Shift = Neovim
-- ============================================

-- LazyVimデフォルトを無効化
vim.keymap.del("n", "<C-h>")
vim.keymap.del("n", "<C-j>")
vim.keymap.del("n", "<C-k>")
vim.keymap.del("n", "<C-l>")
vim.keymap.del("n", "<S-h>")
vim.keymap.del("n", "<S-l>")

-- ウィンドウ移動: Shift+h/j/k/l
vim.keymap.set("n", "<S-h>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<S-j>", "<C-w>j", { desc = "Go to lower window" })
vim.keymap.set("n", "<S-k>", "<C-w>k", { desc = "Go to upper window" })
vim.keymap.set("n", "<S-l>", "<C-w>l", { desc = "Go to right window" })

-- バッファ移動: Shift+n/p
vim.keymap.set("n", "<S-n>", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-p>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })

-- LSPホバー: <leader>k（Shift+K の代わり）
vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover, { desc = "Hover documentation" })

-- ============================================
-- ターミナルモード
-- ============================================

-- ターミナルモードから抜ける（分割キーボード向け）
vim.keymap.set("t", "<C-j><C-j>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- ターミナルモードからAIビューを閉じる
vim.keymap.set("t", "<C-j>q", "<C-\\><C-n>:q<CR>", { desc = "Exit terminal and close window" })
