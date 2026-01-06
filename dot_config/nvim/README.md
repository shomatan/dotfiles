# Neovim設定

LazyVimベースのNeovim設定です。

## キーバインド

### カスタムキーバインド

| キー | 動作 | プラグイン |
|------|------|-----------|
| `-` | 親ディレクトリを開く | Oil |
| `<leader>e` | Explorer (Oil) | Oil |
| `q` | Oilを閉じる | Oil |
| `<leader>aa` | Claude Codeを開く | Sidekick |

### LazyVimデフォルト（よく使うもの）

#### ファイル操作
| キー | 動作 |
|------|------|
| `<leader>ff` | ファイル検索 |
| `<leader>fg` | 文字列検索（grep） |
| `<leader>fr` | 最近開いたファイル |
| `<leader><leader>` | バッファ内ファイル検索 |

#### バッファ操作
| キー | 動作 |
|------|------|
| `<S-h>` | 前のバッファ |
| `<S-l>` | 次のバッファ |
| `<leader>bb` | バッファ一覧 |
| `<leader>bd` | バッファを閉じる |
| `<C-^>` | 直前のバッファに戻る |

#### ウィンドウ操作
| キー | 動作 |
|------|------|
| `<C-h/j/k/l>` | ウィンドウ移動 |
| `<leader>-` | 水平分割 |
| `<leader>\|` | 垂直分割 |

#### LSP
| キー | 動作 |
|------|------|
| `gd` | 定義へジャンプ |
| `gr` | 参照一覧 |
| `K` | ホバー情報 |
| `<leader>ca` | コードアクション |
| `<leader>cr` | リネーム |

#### その他
| キー | 動作 |
|------|------|
| `<leader>gg` | Lazygit |
| `<leader>xx` | 診断一覧 (Trouble) |
| `<leader>qs` | セッション保存 |
| `<leader>qr` | セッション復元 |

## プラグイン構成

- **Oil.nvim**: ファイルエクスプローラー（neo-tree無効化）
- **Sidekick.nvim**: Claude Code連携
- **Flutter-tools.nvim**: Flutter/Dart開発環境
