---
name: confluence-adf-edit
description: Confluence の既存ページを更新する手順。MCP の updateConfluencePage は body 全文置換で他者の編集を潰すため、REST v2 + ADF の差分編集で当てる。ページの一部を直す、表の行を足す、節を削る、値を書き換えるといった依頼で使用する。50k 文字超のページは MCP では取得自体がトークン上限に達するため必須。
---

# Confluence ページの差分編集

## 原則

既存ページの部分更新は、**サイズを問わず ADF の差分編集で行う**。

MCP の `updateConfluencePage` は body 全文をパラメータで受け取る。取得から送信までの間に他者（人間のエディタの Autosave を含む）が編集していると、その版が消える。数万字を毎回書き直すコストも掛かる。

MCP を使ってよいのは次の 2 つだけ。

- ページの新規作成
- 構成を丸ごと書き換える場合（差分より全文のほうが短い）

## 手順

以下、`$PAGE` はページ ID とする。

### 1. 認証

**API トークンを新たに発行する必要はない。** MCP の Atlassian サーバーへ接続済みなら、その OAuth アクセストークンが macOS Keychain の `Claude Code-credentials` に入っており、Confluence REST v2 へそのまま通る。

```bash
TOK=$(security find-generic-password -s "Claude Code-credentials" -w | python3 -c '
import sys, json, time
out = ""
for k, v in json.load(sys.stdin)["mcpOAuth"].items():
    if "atlassian" not in k.lower():
        continue
    if "write:page:confluence" not in (v.get("scope") or ""):
        continue
    if (v.get("expiresAt") or 0) / 1000 <= time.time():
        continue
    out = v["accessToken"]
print(out)
')
[ -n "$TOK" ] || echo "有効なトークンがない。MCP の Atlassian サーバーへ接続し直す"
```

`mcpOAuth` には期限切れのエントリや `accessToken` が空のエントリが同居する。**キー名を決め打ちせず、`write:page:confluence` を持ち期限内のものを選ぶ。** 上のスニペットがそれをしている。

トークンは 1 時間程度で切れる。切れたら MCP を再接続して取り直す。`refreshToken` も入っているが、自前で回すより繋ぎ直すほうが早い。

エンドポイントはサイト URL ではなく `api.atlassian.com` を使う。cloudId は毎回引く。

```bash
CLOUD=$(curl -s -H "Authorization: Bearer $TOK" \
  https://api.atlassian.com/oauth/token/accessible-resources \
  | python3 -c 'import sys,json;print(json.load(sys.stdin)[0]["id"])')
BASE="https://api.atlassian.com/ex/confluence/$CLOUD/wiki"
```

**この OAuth トークンは v1 REST に通らない。** `/wiki/rest/api/...` は 401 を返す。granular scope が v2 だけを対象にしているためで、取得も検算も `/wiki/api/v2/...` で書く。

API トークンを使う経路も残っている。MCP を繋いでいない環境ではこちらになる。`~/.atlassian/credentials.env` に `ATLASSIAN_EMAIL` と `ATLASSIAN_API_TOKEN` を置き（トークンは https://id.atlassian.com/manage-profile/security/api-tokens で発行する）、以下の `-H "Authorization: Bearer $TOK"` を `-u "$ATLASSIAN_EMAIL:$ATLASSIAN_API_TOKEN"` に、`$BASE` を `https://<サイト名>.atlassian.net/wiki` に読み替える。この経路はリダイレクトが返るので `curl` に `-L` を付ける。

### 2. 取得

```bash
curl -s -H "Authorization: Bearer $TOK" \
  "$BASE/api/v2/pages/$PAGE?body-format=atlas_doc_format" -o cur.json
```

ADF が Confluence Cloud の native 表現である。`storage`（XHTML）も取れるが変換なので、往復させるとマクロや表の属性が落ちうる。**編集は ADF で行い、storage は検算の表示にだけ使う。**

`body.atlas_doc_format.value` は ADF を JSON 文字列として持つ。`json.loads` してから触る。

### 3. 編集

`adf_edit.py` を作業ディレクトリへコピーして import する。置換と削除は件数が想定と合わなければ止まるので、黙って 0 件成功する事故が起きない。

```python
import adf_edit as ae

doc = ae.load("cur.json")

ae.replace_text(doc, "実績 12 件", "実績 18 件", expected=1)
ae.drop_section(doc, "旧仕様のメモ")
ae.drop_paragraph(doc, "→ここは要確認")
ae.swap_table(doc, "項目状態備考", ae.table(
    ["項目", "状態", "備考"], [300, 200, 900],
    [["取込バッチ", "稼働中", "`processed=5`。日次で走る"]],
))
ae.insert_after_section(doc, "現況", [ae.heading("補足", 3), ae.para("`code`、**強調**、[リンク](https://example.com) が使える")])
ae.audit(doc)
ae.save(doc, "new.json")
```

主なヘルパー。

- `replace_text(doc, old, new, expected)`：text ノード単位の完全一致置換
- `drop_section(doc, 見出し語)`：見出しから同レベル以下の次の見出しまでを削除
- `drop_paragraph(doc, 本文)`：表のセル内も含めて段落を削除
- `swap_table(doc, ヘッダ連結文字列, 新table)`：表を丸ごと差し替え。目印はヘッダ行のセルを連結した文字列
- `add_rows(表ノード, 目印の行, 行データ)`：既存行の構造を複製して行を足す
- `insert_after_section(doc, 見出し語, ノード列)`：節の末尾へ挿入
- `table` / `para` / `heading` / `panel` / `status`：ノード組み立て。セル文字列は `` `code` ``、`**強調**`、`[text](url)` を解釈する
- `audit(doc)`：日本語の地の文に残った 2 倍ダッシュと中黒を報告する

### 4. 送信

version は取得直後の番号に 1 を足す。**PUT の直前にもう一度現在の version を引く**（編集している間に Autosave が入る）。

`title` は省略できない。**人間がページ名を変えていることがあるので、直前に引いた値を使う。** `cur.json` の古い title を使い回すと、こちらの知らないリネームを巻き戻す。

```bash
curl -s -H "Authorization: Bearer $TOK" "$BASE/api/v2/pages/$PAGE" -o head.json
python3 - <<'PY'
import json, os
head = json.load(open("head.json"))
json.dump({"id": os.environ["PAGE"], "status": "current", "title": head["title"],
 "body": {"representation": "atlas_doc_format", "value": open("new.json").read()},
 "version": {"number": head["version"]["number"] + 1, "message": "<変更の要約>"}},
 open("put.json", "w"), ensure_ascii=False)
PY
curl -s -X PUT -H "Authorization: Bearer $TOK" -H 'Content-Type: application/json' \
  --data-binary @put.json "$BASE/api/v2/pages/$PAGE"
```

### 5. 検算

storage 表現からタグを剥がして diff を取る。意図した箇所だけが変わったことを目で確認する。v2 の GET は `version` を取れるので、旧版と新版を並べられる。

```bash
dump() { curl -s -H "Authorization: Bearer $TOK" \
  "$BASE/api/v2/pages/$PAGE?body-format=storage&version=$1" \
 | python3 -c "
import sys,json,re,html
s=json.load(sys.stdin)['body']['storage']['value']
s=re.sub(r'<[^>]+>','\n',s); s=html.unescape(s)
print('\n'.join(l.strip() for l in s.split('\n') if l.strip()))"; }
diff <(dump 45) <(dump 46)
```

## 版履歴を見る

MCP には版一覧がない。人間の編集が挟まったかを調べるときは REST を使う。

```bash
curl -s -H "Authorization: Bearer $TOK" "$BASE/api/v2/pages/$PAGE/versions?limit=6"
```

`message` が `Autosaved` の版は、人間がエディタを開いたまま作業している印である。**その状態で全文置換を送ると相手の編集が消える。**差分編集でも、相手のエディタが古い本文を保持したまま次の Autosave を出すと巻き戻る。長い編集セッション中は、エディタを閉じてもらってから書く。

## 罠

- **text ノードの分割**：`replace_text` は 1 つの text ノード内でしか一致しない。太字やコードのマークで文が割れていると当たらない。`expected` が合わずに止まるので、その場合は対象を短く取り直す。
- **長い needle が先**：一方が他方の部分文字列になっているときは長いほうを先に処理する。順序を誤ると二重置換になる。
- **`drop_section` は top-level だけ**：節の削除は本文直下の見出しを前提にする。表のセル内の見出しは扱わない。
- **`title` 省略で 400**：PUT の payload に title を入れ忘れると失敗する。
- **絵文字や `<` を含む本文**：ADF は JSON なのでエスケープを気にしなくてよい。storage を直接編集する方式に戻らない理由のひとつ。
- **v1 REST は 401**：MCP の OAuth トークンで `/wiki/rest/api/...` を叩くと落ちる。v2 に無い機能を使いたくなったら、API トークン経路に切り替える。

## 文面の規範

日本語の本文を書き足すときは `japanese-tech-writing` に従う。`audit()` は記号の残りを機械的に洗い出すだけなので、冗長の排除と太字の抑制は自分で点検する。
