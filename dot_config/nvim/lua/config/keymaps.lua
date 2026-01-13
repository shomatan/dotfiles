-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- ============================================
-- WezTermとの統一キーバインド
-- Ctrl = WezTerm、Shift = Neovim
-- ============================================

-- LazyVimデフォルトを無効化（存在しない場合はスキップ）
pcall(vim.keymap.del, "n", "<C-h>")
pcall(vim.keymap.del, "n", "<C-j>")
pcall(vim.keymap.del, "n", "<C-k>")
pcall(vim.keymap.del, "n", "<C-l>")
pcall(vim.keymap.del, "n", "<S-h>")
pcall(vim.keymap.del, "n", "<S-l>")

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
vim.keymap.set("t", "<C-g><C-g>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- ターミナルモードからAIビューを閉じる
vim.keymap.set("t", "<C-q>", "<C-\\><C-n>:q<CR>", { desc = "Exit terminal and close window" })

-- ============================================
-- 行頭・行末移動
-- ============================================

-- 1で行頭（最初の非空白文字）、2で行末
vim.keymap.set({ "n", "v" }, "1", "^", { desc = "Go to first non-blank character" })
vim.keymap.set({ "n", "v" }, "2", "$", { desc = "Go to end of line" })
