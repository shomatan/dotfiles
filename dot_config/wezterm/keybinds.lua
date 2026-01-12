local wezterm = require 'wezterm'
local act = wezterm.action

local M = {}

M.keys = {
    -- ============================================
    -- リーダーキー (Ctrl+a) を使ったtmux風バインド
    -- ============================================

    -- ペイン分割
    { key = '-', mods = 'LEADER', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },       -- 縦分割
    { key = '|', mods = 'LEADER|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } }, -- 横分割
    { key = '\\', mods = 'LEADER', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },    -- 横分割（Shiftなし）

    -- ペイン移動
    { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },   -- 左のペインへ
    { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },   -- 下のペインへ
    { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },     -- 上のペインへ
    { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },  -- 右のペインへ
    { key = 'o', mods = 'LEADER', action = act.ActivatePaneDirection 'Next' },   -- 次のペインへ

    -- ペインサイズ調整
    { key = 'H', mods = 'LEADER|SHIFT', action = act.AdjustPaneSize { 'Left', 5 } },   -- 左に拡大
    { key = 'J', mods = 'LEADER|SHIFT', action = act.AdjustPaneSize { 'Down', 5 } },   -- 下に拡大
    { key = 'K', mods = 'LEADER|SHIFT', action = act.AdjustPaneSize { 'Up', 5 } },     -- 上に拡大
    { key = 'L', mods = 'LEADER|SHIFT', action = act.AdjustPaneSize { 'Right', 5 } },  -- 右に拡大

    -- ペイン操作
    { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },              -- ペインズーム切り替え
    { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } }, -- ペインを閉じる
    { key = 'q', mods = 'LEADER', action = act.PaneSelect },                       -- ペイン選択モード
    { key = 'Space', mods = 'LEADER', action = act.RotatePanes 'Clockwise' },      -- ペインを回転

    -- タブ操作
    { key = 'c', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },     -- 新しいタブを作成
    { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },           -- 次のタブへ
    { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },          -- 前のタブへ
    { key = '&', mods = 'LEADER|SHIFT', action = act.CloseCurrentTab { confirm = true } }, -- タブを閉じる

    -- タブ番号で移動 (Leader + 0-9)
    { key = '0', mods = 'LEADER', action = act.ActivateTab(0) },   -- タブ1へ
    { key = '1', mods = 'LEADER', action = act.ActivateTab(1) },   -- タブ2へ
    { key = '2', mods = 'LEADER', action = act.ActivateTab(2) },   -- タブ3へ
    { key = '3', mods = 'LEADER', action = act.ActivateTab(3) },   -- タブ4へ
    { key = '4', mods = 'LEADER', action = act.ActivateTab(4) },   -- タブ5へ
    { key = '5', mods = 'LEADER', action = act.ActivateTab(5) },   -- タブ6へ
    { key = '6', mods = 'LEADER', action = act.ActivateTab(6) },   -- タブ7へ
    { key = '7', mods = 'LEADER', action = act.ActivateTab(7) },   -- タブ8へ
    { key = '8', mods = 'LEADER', action = act.ActivateTab(8) },   -- タブ9へ
    { key = '9', mods = 'LEADER', action = act.ActivateTab(-1) },  -- 最後のタブへ

    -- コピー・ペースト
    { key = '[', mods = 'LEADER', action = act.ActivateCopyMode },                 -- コピーモードに入る
    { key = ']', mods = 'LEADER', action = act.PasteFrom 'Clipboard' },            -- ペースト

    -- その他
    { key = 'r', mods = 'LEADER', action = act.ReloadConfiguration },              -- 設定を再読み込み
    { key = ':', mods = 'LEADER|SHIFT', action = act.ActivateCommandPalette },     -- コマンドパレット
    { key = 'd', mods = 'LEADER', action = act.DetachDomain 'CurrentPaneDomain' }, -- デタッチ
    { key = 'a', mods = 'LEADER|CTRL', action = act.SendKey { key = 'a', mods = 'CTRL' } }, -- Ctrl+a を送信

    -- ============================================
    -- Mac標準のショートカット（Cmdキー）
    -- ============================================

    { key = 'c', mods = 'SUPER', action = act.CopyTo 'Clipboard' },                -- コピー
    { key = 'v', mods = 'SUPER', action = act.PasteFrom 'Clipboard' },             -- ペースト
    { key = 't', mods = 'SUPER', action = act.SpawnTab 'CurrentPaneDomain' },      -- 新しいタブ
    { key = 'w', mods = 'SUPER', action = act.CloseCurrentPane { confirm = true } }, -- 閉じる
    { key = 'n', mods = 'SUPER', action = act.SpawnWindow },                       -- 新しいウィンドウ
    { key = 'q', mods = 'SUPER', action = act.QuitApplication },                   -- アプリ終了
    { key = 'h', mods = 'SUPER', action = act.HideApplication },                   -- アプリを隠す
    { key = 'm', mods = 'SUPER', action = act.Hide },                              -- 最小化
    { key = 'f', mods = 'SUPER', action = act.Search 'CurrentSelectionOrEmptyString' }, -- 検索
    { key = 'k', mods = 'SUPER', action = act.ClearScrollback 'ScrollbackOnly' },  -- スクロールバッククリア

    -- フォントサイズ
    { key = '=', mods = 'SUPER', action = act.IncreaseFontSize },                  -- フォント拡大
    { key = '-', mods = 'SUPER', action = act.DecreaseFontSize },                  -- フォント縮小
    { key = '0', mods = 'SUPER', action = act.ResetFontSize },                     -- フォントリセット

    -- タブ切り替え（Cmd + 数字）
    { key = '1', mods = 'SUPER', action = act.ActivateTab(0) },                    -- タブ1へ
    { key = '2', mods = 'SUPER', action = act.ActivateTab(1) },                    -- タブ2へ
    { key = '3', mods = 'SUPER', action = act.ActivateTab(2) },                    -- タブ3へ
    { key = '4', mods = 'SUPER', action = act.ActivateTab(3) },                    -- タブ4へ
    { key = '5', mods = 'SUPER', action = act.ActivateTab(4) },                    -- タブ5へ
    { key = '6', mods = 'SUPER', action = act.ActivateTab(5) },                    -- タブ6へ
    { key = '7', mods = 'SUPER', action = act.ActivateTab(6) },                    -- タブ7へ
    { key = '8', mods = 'SUPER', action = act.ActivateTab(7) },                    -- タブ8へ
    { key = '9', mods = 'SUPER', action = act.ActivateTab(-1) },                   -- 最後のタブへ

    -- タブ移動
    { key = '{', mods = 'SUPER|SHIFT', action = act.ActivateTabRelative(-1) },     -- 前のタブへ
    { key = '}', mods = 'SUPER|SHIFT', action = act.ActivateTabRelative(1) },      -- 次のタブへ

    -- フルスクリーン
    { key = 'Enter', mods = 'SUPER', action = act.ToggleFullScreen },              -- フルスクリーン切り替え

    -- ============================================
    -- スクロール
    -- ============================================

    { key = 'PageUp', mods = 'SHIFT', action = act.ScrollByPage(-1) },             -- 1ページ上へ
    { key = 'PageDown', mods = 'SHIFT', action = act.ScrollByPage(1) },            -- 1ページ下へ

    -- ============================================
    -- ペイン操作（Ctrl）- Neovimと統一
    -- ============================================

    -- ペイン移動
    { key = 'h', mods = 'CTRL', action = act.ActivatePaneDirection 'Left' },
    { key = 'j', mods = 'CTRL', action = act.ActivatePaneDirection 'Down' },
    { key = 'k', mods = 'CTRL', action = act.ActivatePaneDirection 'Up' },
    { key = 'l', mods = 'CTRL', action = act.ActivatePaneDirection 'Right' },

    -- タブ移動
    { key = 'n', mods = 'CTRL', action = act.ActivateTabRelative(1) },
    { key = 'p', mods = 'CTRL', action = act.ActivateTabRelative(-1) },

    -- ============================================
    -- ペイン操作（Ctrl+Shift）
    -- ============================================

    -- ペイン分割
    { key = '-', mods = 'CTRL|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = '|', mods = 'CTRL|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },

    -- ペイン操作
    { key = 'z', mods = 'CTRL|SHIFT', action = act.TogglePaneZoomState },

    -- ============================================
    -- Git Worktree 操作
    -- ============================================
    { key = 'w', mods = 'CTRL|SHIFT', action = act.EmitEvent 'select-worktree' },  -- Worktree選択
    { key = 'c', mods = 'CTRL|SHIFT', action = act.EmitEvent 'create-worktree' },  -- Worktree作成
    { key = 'd', mods = 'CTRL|SHIFT', action = act.EmitEvent 'remove-worktree' },  -- Worktree削除
  }

M.key_tables = {
  -- ============================================
  -- コピーモード（Vim風）
  -- ============================================

  copy_mode = {
    -- モード終了
    { key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },              -- コピーモード終了
    { key = 'q', mods = 'NONE', action = act.CopyMode 'Close' },                   -- コピーモード終了
    { key = 'c', mods = 'CTRL', action = act.CopyMode 'Close' },                   -- コピーモード終了

    -- カーソル移動（Vim風）
    { key = 'h', mods = 'NONE', action = act.CopyMode 'MoveLeft' },                -- 左へ
    { key = 'j', mods = 'NONE', action = act.CopyMode 'MoveDown' },                -- 下へ
    { key = 'k', mods = 'NONE', action = act.CopyMode 'MoveUp' },                  -- 上へ
    { key = 'l', mods = 'NONE', action = act.CopyMode 'MoveRight' },               -- 右へ

    -- 単語移動
    { key = 'w', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },         -- 次の単語へ
    { key = 'b', mods = 'NONE', action = act.CopyMode 'MoveBackwardWord' },        -- 前の単語へ
    { key = 'e', mods = 'NONE', action = act.CopyMode 'MoveForwardWordEnd' },      -- 単語末尾へ

    -- 行移動
    { key = '0', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },       -- 行頭へ
    { key = '$', mods = 'NONE', action = act.CopyMode 'MoveToEndOfLineContent' },  -- 行末へ
    { key = '^', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLineContent' }, -- 最初の文字へ

    -- ページ移動
    { key = 'g', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackTop' },     -- バッファ先頭へ
    { key = 'G', mods = 'SHIFT', action = act.CopyMode 'MoveToScrollbackBottom' }, -- バッファ末尾へ
    { key = 'H', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportTop' },      -- 画面上部へ
    { key = 'M', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportMiddle' },   -- 画面中央へ
    { key = 'L', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportBottom' },   -- 画面下部へ

    -- スクロール
    { key = 'd', mods = 'CTRL', action = act.CopyMode { MoveByPage = 0.5 } },      -- 半ページ下へ
    { key = 'u', mods = 'CTRL', action = act.CopyMode { MoveByPage = -0.5 } },     -- 半ページ上へ
    { key = 'f', mods = 'CTRL', action = act.CopyMode 'PageDown' },                -- 1ページ下へ
    { key = 'b', mods = 'CTRL', action = act.CopyMode 'PageUp' },                  -- 1ページ上へ

    -- 選択
    { key = 'v', mods = 'NONE', action = act.CopyMode { SetSelectionMode = 'Cell' } },  -- 文字選択
    { key = 'V', mods = 'SHIFT', action = act.CopyMode { SetSelectionMode = 'Line' } }, -- 行選択
    { key = 'v', mods = 'CTRL', action = act.CopyMode { SetSelectionMode = 'Block' } }, -- 矩形選択
    { key = 'o', mods = 'NONE', action = act.CopyMode 'MoveToSelectionOtherEnd' }, -- 選択範囲の反対側へ

    -- コピー
    { key = 'y', mods = 'NONE', action = act.Multiple {                            -- ヤンク（コピー）
      { CopyTo = 'ClipboardAndPrimarySelection' },
      { CopyMode = 'Close' },
    }},

    -- 検索
    { key = '/', mods = 'NONE', action = act.Search 'CurrentSelectionOrEmptyString' }, -- 検索開始
    { key = 'n', mods = 'NONE', action = act.CopyMode 'NextMatch' },               -- 次の一致へ
    { key = 'N', mods = 'SHIFT', action = act.CopyMode 'PriorMatch' },             -- 前の一致へ

    -- ジャンプ
    { key = 'f', mods = 'NONE', action = act.CopyMode { JumpForward = { prev_char = false } } },  -- 文字へジャンプ
    { key = 'F', mods = 'SHIFT', action = act.CopyMode { JumpBackward = { prev_char = false } } }, -- 文字へ逆ジャンプ
    { key = 't', mods = 'NONE', action = act.CopyMode { JumpForward = { prev_char = true } } },   -- 文字の手前へジャンプ
    { key = 'T', mods = 'SHIFT', action = act.CopyMode { JumpBackward = { prev_char = true } } }, -- 文字の手前へ逆ジャンプ
    { key = ';', mods = 'NONE', action = act.CopyMode 'JumpAgain' },               -- ジャンプを繰り返す
    { key = ',', mods = 'NONE', action = act.CopyMode 'JumpReverse' },             -- 逆方向にジャンプ
  },

  -- ============================================
  -- 検索モード
  -- ============================================

  search_mode = {
    { key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },              -- 検索終了
    { key = 'Enter', mods = 'NONE', action = act.CopyMode 'PriorMatch' },          -- 前の一致へ
    { key = 'n', mods = 'CTRL', action = act.CopyMode 'NextMatch' },               -- 次の一致へ
    { key = 'p', mods = 'CTRL', action = act.CopyMode 'PriorMatch' },              -- 前の一致へ
    { key = 'r', mods = 'CTRL', action = act.CopyMode 'CycleMatchType' },          -- 検索タイプ切り替え
    { key = 'u', mods = 'CTRL', action = act.CopyMode 'ClearPattern' },            -- パターンをクリア
    { key = 'PageUp', mods = 'NONE', action = act.CopyMode 'PriorMatchPage' },     -- 前のページの一致へ
    { key = 'PageDown', mods = 'NONE', action = act.CopyMode 'NextMatchPage' },    -- 次のページの一致へ
    { key = 'UpArrow', mods = 'NONE', action = act.CopyMode 'PriorMatch' },        -- 前の一致へ
    { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'NextMatch' },       -- 次の一致へ
  },

}

return M
