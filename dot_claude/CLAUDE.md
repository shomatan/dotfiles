# CLAUDE.md (User-level)


## 言語設定

- 日本語でコミュニケーションを行うことを優先してください
- コードコメントやドキュメントも日本語で記述してください（国際的なプロジェクトを除く）

## 応答スタイル（genshijin）

トークン消費を抑えるため、簡潔な日本語で応答すること。以下のルールに従う。

### 削除対象
- 敬語・丁寧語: です/ます/ございます → 体言止め・用言止めに変換
- クッション言葉: えーと/まあ/ちなみに/一応/基本的に
- ぼかし: 〜かもしれません/〜と思われます/おそらく
- 冗長助詞: 〜することができる → 〜できる
- 冗長接続: 〜ということになりますので → だから
- 自明な助詞: が/の/を/に/で/は/と/も — 意味が通じるなら省略
- 情報水増し: 聞かれたことだけ答える。背景説明や網羅的列挙は不要

### 保持するもの
- 技術用語・コードブロック: そのまま維持
- 固有名詞・数値: 省略しない
- コマンド・パス: 正確に記述

### 安全弁
- 破壊的操作（DELETE/DROP/rm -rf/force-push等）の確認時は通常の日本語に復帰する
- セキュリティに関わる警告も通常の日本語で記述する

## コーディングスタイル

- 簡潔で読みやすいコードを心がける
- 適切なエラーハンドリングを実装する
- コミットメッセージは日本語で記述する

## 環境

- macOS環境で開発を行っている
- Homebrewでパッケージ管理
- miseでツールバージョン管理
- zsh + Powerlevel10kを使用

## Git/GitHub設定

- コミットメッセージにCo-Authored-Byを追加しないこと
- プルリクエストに「Generated with Claude Code」のような生成した証跡を残さないこと

## ユーザー確認

- ユーザーへの確認は必ず `AskUserQuestion` ツールを使用し、選択式で提示すること
- テキストで選択肢を羅列して確認を求めてはならない
- 選択肢は2〜4個に絞り、明確な説明を付けること

## 開発ワークフロー（gstack + CE/superpowers）

gstackとCE（superpowers）を併用する。それぞれの得意領域で使い分ける。

### gstack を使う場面
- `/office-hours` — アイデアの初期検証（ビジネス・プロダクト視点）
- `/plan-ceo-review` — プロダクト判断・ビジネスレンズ
- `/plan-eng-review` — アーキテクチャのロック
- `/qa` — Playwright による自動QAテスト
- `/retro` — 週次統計・振り返り
- `/browse` — ヘッドレスブラウザ操作（Webブラウジングには常にこれを使う）
- `/ship` — リリース・PR作成
- `/cso` — セキュリティ監査

### CE（superpowers）を使う場面
- `brainstorming` — 技術設計のSocratic対話
- `writing-plans` — 2-5分単位のタスク分割による実装計画
- `subagent-driven-development` — 並列エージェントでの高速実装
- `requesting-code-review` — 14エージェント並列コードレビュー
- `test-driven-development` — RED-GREEN-REFACTORサイクル
- `finishing-a-development-branch` — マージ/PR判定

### 統合フロー（推奨）
1. `/office-hours` (gstack) → アイデア検証
2. `/plan-ceo-review` + `/plan-eng-review` (gstack) → ビジネス＆アーキテクチャ承認
3. `brainstorming` (CE) → 技術設計の深掘り
4. `writing-plans` (CE) → 実装計画
5. `subagent-driven-development` (CE) → 実装
6. レビュー: 軽量は `/review` (gstack)、重要は `requesting-code-review` (CE)
7. `/qa` (gstack) → 自動QA
8. `/ship` (gstack) → リリース
