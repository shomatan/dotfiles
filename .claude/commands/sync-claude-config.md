Claude Code関連の設定ファイルをchezmoiに同期してください。

手順:
1. `chezmoi status` で `.claude/` 配下の変更を確認

2. プラグイン設定ファイルは `git add-tmpl` で追加:
   - `~/.claude/plugins/installed_plugins.json`
   - `~/.claude/plugins/known_marketplaces.json`

3. `settings.json` は専用スクリプトで同期:
   - `python3 .claude/scripts/sync-settings-tmpl.py` を実行
   - スクリプトが hooks セクションの Go テンプレート構文を保持しつつ、非テンプレート部分を実ファイルに合わせて更新する
   - 変更があれば `git add dot_claude/settings.json.tmpl` でステージング

4. `git status --short` でステージング状態を表示
