Claude Code関連の設定ファイルをchezmoiに同期してください。
すべての手順を自動で実行し、結果をユーザーに報告してください。

手順:
1. `.claude/scripts/sync-plugins.sh` を実行してプラグイン設定を同期する
2. `python3 .claude/scripts/sync-settings-tmpl.py` を実行してsettings.jsonを同期する
3. `chezmoi diff` で差分を確認する
4. 差分がある場合は変更内容をユーザーに報告し、コミットするか確認する
5. コミットする場合は変更ファイルをステージングしてコミットする
