---
name: visualize-long-document
description: Use when the user asks to visualize, diagram, or illustrate a document (図解して, 図示, visualize, diagram), or when a long markdown document, spec, or design doc is presented and a visual breakdown would aid comprehension. Generates a self-contained HTML file with Mermaid diagrams, structured cards, comparison tables, and timelines.
---

# 長文ドキュメントをHTMLで図解する

## 概要

長文のドキュメント・仕様書・設計書を、`/tmp/claude-diagrams/` に保存する単一のHTMLファイルとして視覚化する。Mermaid図・構造カード・比較表・タイムラインを組み合わせて、読み手が一目で全体像を掴めるようにする。

## いつ使うか

**起動条件（いずれか）:**
- ユーザーが明示的に依頼（「図解して」「visualize」「diagram」「図にして」）
- 長文のmarkdown / 仕様書 / RFC / 設計書を提示され、視覚化が理解を助けると判断できる場合

**使わない場面:**
- 短文・1〜2段落の説明（不要に重い）
- ユーザーが要約や箇条書きで十分と明示している場合
- コード単体の説明（コードブロックで十分）

## ワークフロー

1. **ドキュメントを構造分析**
   - 章立て / 主要概念 / プロセスフロー / 比較対象 / 時系列 を抽出
2. **可視化方針を決める**（次節「図解パターンの選び方」）
3. **HTMLを生成**（次節「HTMLの要件」を満たすこと）
4. **保存と通知**
   - 出力先: `/tmp/claude-diagrams/{slug}-{YYYYMMDD-HHmmss}.html`
   - `mkdir -p /tmp/claude-diagrams/` を先に実行
   - 保存後、ファイルパスと `open <path>` コマンドをユーザーに提示

## 図解パターンの選び方

| 内容の特徴 | 推奨ビジュアル |
|-----------|--------------|
| 処理の流れ・状態遷移・分岐 | Mermaid `flowchart` / `stateDiagram` |
| やり取り・呼び出し関係 | Mermaid `sequenceDiagram` |
| データ構造・継承・関連 | Mermaid `classDiagram` / `erDiagram` |
| 章立て・概念整理 | 構造カード（grid + 見出し） |
| 選択肢・Before/After・対立軸 | 2列比較カード or 表 |
| 手順・歴史・段階 | 縦タイムライン（CSSのみ） |
| キーワード・重要数値 | コールアウト（強調ボックス） |

**ひとつの図解に詰め込みすぎない。** 章ごとにセクションを分け、各セクションで最適な1〜2種類だけ使う。

## HTMLの要件

- **self-contained**: 外部依存はCDN（Tailwind, Mermaid）のみ。ローカルファイル参照はしない
- **日本語フォント**: `system-ui, -apple-system, "Hiragino Sans", "Yu Gothic", sans-serif`
- **トップに目次（TOC）** を置き、各セクションへアンカーリンク
- **印刷可**: `@media print` で背景色が消えないよう `-webkit-print-color-adjust: exact`
- **ダーク対応は不要**（ライト固定でOK、印刷・閲覧優先）
- Mermaidは `mermaid.initialize({ startOnLoad: true, theme: 'default', securityLevel: 'loose' })`
- 構成や見た目は内容に応じて自由に設計（決まったテンプレートはない）

## 出力例の構造

```
<header>      … タイトル / 出典 / 生成日時
<nav>         … TOC（章リンク）
<section>     … 概要（1段落 + 重要キーワードのコールアウト）
<section>     … 主要フロー（Mermaid flowchart）
<section>     … 概念整理（構造カードのgrid）
<section>     … 比較（2カラム or 表）
<section>     … タイムライン（必要時）
<footer>      … 出典・元ドキュメントへのリンク
```

## よくある失敗

| 失敗 | 対策 |
|------|------|
| Mermaidに長文を埋め込んで読めない図になる | ノードラベルは10〜20文字以内。詳細は近くのカードに |
| 1ページに10種類の図を詰め込む | セクション粒度で分け、各セクションで最大2種 |
| 元ドキュメントを丸ごとHTML化 | 図解は補助。本文は要点のみ抜粋 |
| ファイル名が衝突 | `slug-YYYYMMDD-HHmmss.html` 形式を必ず使う |
| `open` で開けない | macOS前提。`open` コマンドの提示はBash実行ではなくユーザーへの提案に留める |

## 実行例

ユーザー: 「このRFCを図解して」（長いmarkdownを貼付）

1. 章立てを読み取り → 「動機」「設計」「フロー」「代替案」「タイムライン」を抽出
2. `動機`→コールアウト、`設計`→構造カード、`フロー`→Mermaid flowchart、`代替案`→比較表、`タイムライン`→縦タイムライン
3. HTMLを生成し `/tmp/claude-diagrams/rfc-auth-20260502-143052.html` に保存
4. ユーザーへ: 「保存しました: `/tmp/claude-diagrams/rfc-auth-20260502-143052.html`  → `open /tmp/claude-diagrams/rfc-auth-20260502-143052.html` で開けます」
