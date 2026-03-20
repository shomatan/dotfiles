#!/usr/bin/env python3
"""
settings.json → settings.json.tmpl 同期スクリプト

実際の ~/.claude/settings.json の内容を chezmoi テンプレート
(dot_claude/settings.json.tmpl) に反映する。
hooks セクションの Go テンプレート構文は保持したまま、
それ以外のセクションを実ファイルの値で更新する。
"""

from __future__ import annotations

import json
import sys
from pathlib import Path


def load_actual_settings(path: Path) -> dict:
    """実際の settings.json を読み込む"""
    with open(path, encoding="utf-8") as f:
        return json.load(f)


def load_template_text(path: Path) -> str:
    """テンプレートファイルをテキストとして読み込む"""
    with open(path, encoding="utf-8") as f:
        return f.read()


def extract_hooks_section(template_text: str) -> str:
    """
    テンプレートから hooks セクションを Go テンプレート構文ごと抽出する。

    "hooks": { から始まり、Go テンプレート行 ({{ で始まる行) を無視しつつ
    JSON の波括弧の深さを追跡して、対応する閉じ括弧までを返す。
    返り値は "hooks": { ... } の部分（先頭の2スペースインデント含む）。
    """
    lines = template_text.split("\n")
    hooks_start = -1

    # "hooks": { の行を探す
    for i, line in enumerate(lines):
        stripped = line.strip()
        if stripped.startswith('"hooks"') and stripped.endswith("{"):
            hooks_start = i
            break

    if hooks_start == -1:
        raise ValueError("テンプレート内に hooks セクションが見つかりません")

    # 波括弧の深さを追跡（Go テンプレート行は無視）
    depth = 0
    hooks_end = -1

    for i in range(hooks_start, len(lines)):
        line = lines[i]
        stripped = line.strip()

        # Go テンプレート行は深さカウントに含めない
        if stripped.startswith("{{"):
            continue

        # 波括弧をカウント
        for ch in stripped:
            if ch == "{":
                depth += 1
            elif ch == "}":
                depth -= 1
                if depth == 0:
                    hooks_end = i
                    break

        if hooks_end != -1:
            break

    if hooks_end == -1:
        raise ValueError("hooks セクションの終端が見つかりません")

    # 抽出（末尾のカンマも含める）
    hooks_lines = lines[hooks_start : hooks_end + 1]
    return "\n".join(hooks_lines)


def serialize_object_value(obj: object, outer_indent: str = "  ") -> str:
    """
    オブジェクト値を JSON にシリアライズし、各行に外側のインデントを付与する。

    内部インデントは2スペース、外側インデントも2スペースで、
    合計4スペースのネストインデントになる（テンプレートのスタイルに合致）。
    最初の行（開き括弧）にはインデントを付けない（キーの後ろに続くため）。
    """
    raw = json.dumps(obj, indent=2, ensure_ascii=False)
    lines = raw.split("\n")

    # 最初の行以外に外側インデントを追加
    result_lines = [lines[0]]
    for line in lines[1:]:
        result_lines.append(outer_indent + line)

    return "\n".join(result_lines)


def serialize_scalar(value: object) -> str:
    """スカラー値を JSON としてシリアライズする"""
    return json.dumps(value, ensure_ascii=False)


def build_template(actual: dict, hooks_section: str) -> str:
    """
    実ファイルのキー順序に従って新しいテンプレートを構築する。
    hooks セクションはテンプレートから抽出したものをそのまま使用する。
    """
    lines: list[str] = ["{"]
    keys = list(actual.keys())

    for i, key in enumerate(keys):
        is_last = i == len(keys) - 1
        comma = "" if is_last else ","

        if key == "hooks":
            # テンプレートから抽出した hooks セクションを使用
            # 末尾のカンマを制御する
            section = hooks_section.rstrip()
            if comma and not section.endswith(","):
                section += ","
            elif not comma and section.endswith(","):
                section = section[:-1]
            lines.append(section)
        elif isinstance(actual[key], dict):
            # オブジェクト値：4スペースインデント + 2スペース外側インデント
            serialized = serialize_object_value(actual[key])
            lines.append(f'  "{key}": {serialized}{comma}')
        else:
            # スカラー値：インライン
            serialized = serialize_scalar(actual[key])
            lines.append(f'  "{key}": {serialized}{comma}')

    lines.append("}")
    # 末尾改行を追加
    return "\n".join(lines) + "\n"


def parse_template_as_json(template_text: str) -> dict | None:
    """
    テンプレートから hooks セクション全体をダミー値に置き換えて
    JSON としてパースする。

    Go テンプレート行を含む hooks セクションを丸ごと
    "hooks": {} に置換することで、正しい JSON を得る。
    """
    lines = template_text.split("\n")
    result_lines: list[str] = []
    i = 0

    while i < len(lines):
        stripped = lines[i].strip()

        # hooks セクションの開始を検出
        if stripped.startswith('"hooks"') and stripped.endswith("{"):
            # hooks セクションをスキップしてダミーに置換
            depth = 0
            for j in range(i, len(lines)):
                line_s = lines[j].strip()
                # Go テンプレート行は無視
                if line_s.startswith("{{"):
                    continue
                for ch in line_s:
                    if ch == "{":
                        depth += 1
                    elif ch == "}":
                        depth -= 1
                        if depth == 0:
                            # 元の行の末尾カンマを確認
                            trailing = lines[j].rstrip()
                            comma = "," if trailing.endswith(",") else ""
                            # 次の行がカンマを持つケースも確認
                            if not comma and j + 1 < len(lines):
                                next_stripped = lines[j + 1].strip()
                                if next_stripped == ",":
                                    comma = ","
                            result_lines.append(f'  "hooks": {{}}{comma}')
                            i = j + 1
                            break
                if depth == 0:
                    break
            continue

        # Go テンプレート行はスキップ
        if stripped.startswith("{{"):
            i += 1
            continue

        result_lines.append(lines[i])
        i += 1

    try:
        return json.loads("\n".join(result_lines))
    except json.JSONDecodeError:
        return None


def compute_diff_summary(
    old_template: str, actual: dict
) -> list[str]:
    """
    変更点のサマリーを生成する。
    テンプレートの既存内容と実ファイルを比較して差分を報告する。
    """
    messages: list[str] = []

    # テンプレートを JSON としてパース（hooks はダミーに置換）
    old_data = parse_template_as_json(old_template)
    if old_data is None:
        messages.append("テンプレートの JSON パースに失敗")
        return messages

    # enabledPlugins の差分
    old_plugins = set(old_data.get("enabledPlugins", {}).keys())
    new_plugins = set(actual.get("enabledPlugins", {}).keys())

    added_plugins = new_plugins - old_plugins
    removed_plugins = old_plugins - new_plugins

    if added_plugins:
        messages.append(f"追加されたプラグイン: {', '.join(sorted(added_plugins))}")
    if removed_plugins:
        messages.append(f"削除されたプラグイン: {', '.join(sorted(removed_plugins))}")
    if not added_plugins and not removed_plugins:
        messages.append("enabledPlugins: 変更なし")

    # env の差分
    old_env = set(old_data.get("env", {}).keys())
    new_env = set(actual.get("env", {}).keys())

    added_env = new_env - old_env
    removed_env = old_env - new_env

    if added_env:
        messages.append(f"追加された環境変数: {', '.join(sorted(added_env))}")
    if removed_env:
        messages.append(f"削除された環境変数: {', '.join(sorted(removed_env))}")

    # トップレベルキーの差分
    old_keys = set(old_data.keys())
    new_keys = set(actual.keys())

    added_keys = new_keys - old_keys
    removed_keys = old_keys - new_keys

    if added_keys:
        messages.append(f"追加されたキー: {', '.join(sorted(added_keys))}")
    if removed_keys:
        messages.append(f"削除されたキー: {', '.join(sorted(removed_keys))}")

    # スカラー値の変更を検出
    common_keys = old_keys & new_keys
    for key in sorted(common_keys):
        if key in ("hooks", "enabledPlugins", "env"):
            continue
        old_val = old_data.get(key)
        new_val = actual.get(key)
        if old_val != new_val:
            messages.append(f"{key}: {old_val!r} → {new_val!r}")

    return messages


def main() -> None:
    # パスをスクリプトの場所から導出
    script_dir = Path(__file__).resolve().parent
    repo_root = script_dir.parent.parent  # .claude/scripts/ → リポジトリルート

    actual_path = Path.home() / ".claude" / "settings.json"
    template_path = repo_root / "dot_claude" / "settings.json.tmpl"

    # ファイル存在チェック
    if not actual_path.exists():
        print(f"エラー: {actual_path} が見つかりません", file=sys.stderr)
        sys.exit(1)

    if not template_path.exists():
        print(f"エラー: {template_path} が見つかりません", file=sys.stderr)
        sys.exit(1)

    # 読み込み
    actual = load_actual_settings(actual_path)
    old_template = load_template_text(template_path)

    # hooks セクションを抽出
    hooks_section = extract_hooks_section(old_template)

    # 新しいテンプレートを構築
    new_template = build_template(actual, hooks_section)

    # 変更サマリーを計算
    summary = compute_diff_summary(old_template, actual)

    # 書き込み
    with open(template_path, "w", encoding="utf-8") as f:
        f.write(new_template)

    # 結果を表示
    print(f"同期完了: {actual_path} → {template_path}")
    print()

    if summary:
        print("変更点:")
        for msg in summary:
            print(f"  - {msg}")
    else:
        print("変更点なし")


if __name__ == "__main__":
    main()
