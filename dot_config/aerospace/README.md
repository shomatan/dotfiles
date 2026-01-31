# AeroSpace設定

macOS向けのタイル型ウィンドウマネージャー [AeroSpace](https://nikitabobko.github.io/AeroSpace/) の設定です。

## 基本設定

- ログイン時自動起動: 有効
- ギャップ: なし（0px）
- ワークスペース: 10個（1-9, 0）
- レイアウト: tiles（タイル型）
- キーマッピング: qwerty

## キーバインド

### ワークスペース操作

| キー | 動作 |
|------|------|
| `Ctrl + 1-9, 0` | ワークスペース切替 |
| `Ctrl + Shift + 1-9, 0` | ウィンドウをワークスペースに移動 |
| `Ctrl + Cmd + Tab` | 前のワークスペースに戻る |
| `Ctrl + Cmd + Shift + Tab` | ワークスペースを次のモニターに移動 |

### フォーカス移動（Vim風）

| キー | 動作 |
|------|------|
| `Ctrl + Cmd + h` | 左のウィンドウにフォーカス |
| `Ctrl + Cmd + j` | 下のウィンドウにフォーカス |
| `Ctrl + Cmd + k` | 上のウィンドウにフォーカス |
| `Ctrl + Cmd + l` | 右のウィンドウにフォーカス |

### ウィンドウ移動

| キー | 動作 |
|------|------|
| `Ctrl + Cmd + Shift + h` | ウィンドウを左に移動 |
| `Ctrl + Cmd + Shift + j` | ウィンドウを下に移動 |
| `Ctrl + Cmd + Shift + k` | ウィンドウを上に移動 |
| `Ctrl + Cmd + Shift + l` | ウィンドウを右に移動 |

### レイアウト操作

| キー | 動作 |
|------|------|
| `Ctrl + Cmd + /` | 水平/垂直分割切替 |
| `Ctrl + Cmd + ,` | アコーディオンレイアウト切替 |

### サイズ変更

| キー | 動作 |
|------|------|
| `Ctrl + Cmd + -` | ウィンドウを縮小 |
| `Ctrl + Cmd + =` | ウィンドウを拡大 |

### サービスモード（`Ctrl + Cmd + ;`）

サービスモードに入ると、以下の操作が可能です。

| キー | 動作 |
|------|------|
| `r` | レイアウトリセット（フラット化） |
| `f` | フローティング/タイル切替 |
| `Backspace` | 他のウィンドウを全て閉じる |
| `Ctrl + Cmd + Shift + h` | 左のウィンドウと結合 |
| `Ctrl + Cmd + Shift + j` | 下のウィンドウと結合 |
| `Ctrl + Cmd + Shift + k` | 上のウィンドウと結合 |
| `Ctrl + Cmd + Shift + l` | 右のウィンドウと結合 |
| `Esc` | メインモードに戻る（設定リロード） |

## CLIコマンド

よく使うコマンド:

```bash
# 現在のワークスペースを表示
aerospace list-workspaces --focused

# 全ウィンドウ一覧を表示
aerospace list-windows --all

# 設定をリロード
aerospace reload-config
```
