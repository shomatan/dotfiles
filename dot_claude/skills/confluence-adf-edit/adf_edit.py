"""Confluence ページの ADF を差分編集するヘルパー。

使い方:
    import adf_edit as ae
    doc = ae.load("cur.json")
    ae.replace_text(doc, "旧", "新", expected=1)
    ae.swap_table(doc, "項目状態備考", ae.table(headers, widths, rows))
    ae.save(doc, "new.json")

置換・削除は件数が想定と合わなければ SystemExit で止める。
黙って 0 件成功することを防ぐため、expected は必ず指定する。
"""

import copy
import json
import re
import sys

# --- 入出力 ----------------------------------------------------------------


def load(path):
    """`?body-format=atlas_doc_format` のレスポンス JSON から ADF を取り出す。"""
    src = json.load(open(path))
    return json.loads(src["body"]["atlas_doc_format"]["value"])


def save(doc, path):
    json.dump(doc, open(path, "w"), ensure_ascii=False)


def walk(node, cb):
    cb(node)
    for child in node.get("content", []) or []:
        walk(child, cb)


def flat(node):
    """ノード配下の text を連結する。表なら全セルが繋がった 1 本の文字列になる。"""
    out = []
    walk(node, lambda n: out.append(n["text"]) if n.get("type") == "text" else None)
    return "".join(out)


# --- インライン記法 --------------------------------------------------------


def runs(s):
    """`code` と **strong** を解釈して text ノード列にする。"""
    out = []
    for part in re.split(r"(`[^`]+`|\*\*[^*]+\*\*)", s):
        if not part:
            continue
        if part.startswith("`") and part.endswith("`"):
            out.append({"type": "text", "text": part[1:-1], "marks": [{"type": "code"}]})
        elif part.startswith("**") and part.endswith("**"):
            out.append({"type": "text", "text": part[2:-2], "marks": [{"type": "strong"}]})
        else:
            out.append({"type": "text", "text": part})
    return out


def para(s=""):
    return {"type": "paragraph", "content": runs(s)} if s else {"type": "paragraph"}


def heading(s, level=2):
    return {"type": "heading", "attrs": {"level": level}, "content": runs(s)}


def panel(s, kind="info"):
    """kind: info / note / success / warning / error"""
    return {"type": "panel", "attrs": {"panelType": kind}, "content": [para(s)]}


def status(label, color="green"):
    """color: neutral / purple / blue / red / yellow / green"""
    return {
        "type": "status",
        "attrs": {"text": label, "color": color, "style": "bold"},
    }


def table(headers, widths, rows, width=1800):
    """headers/rows のセルは runs() の記法が使える文字列。"""

    def cell(kind, s, w):
        return {"type": kind, "attrs": {"colwidth": [w]}, "content": [para(s)]}

    content = [
        {
            "type": "tableRow",
            "content": [cell("tableHeader", f"**{h}**", w) for h, w in zip(headers, widths)],
        }
    ]
    for row in rows:
        content.append(
            {"type": "tableRow", "content": [cell("tableCell", c, w) for c, w in zip(row, widths)]}
        )
    return {
        "type": "table",
        "attrs": {"isNumberColumnEnabled": False, "layout": "default", "width": width},
        "content": content,
    }


# --- 編集操作 --------------------------------------------------------------


def replace_text(doc, old, new, expected):
    """text ノード単位の完全一致置換。マークで分割された文字列は跨げない。"""
    hits = []

    def cb(n):
        if n.get("type") == "text" and old in n["text"]:
            n["text"] = n["text"].replace(old, new)
            hits.append(1)

    walk(doc, cb)
    if len(hits) != expected:
        sys.exit(f"NG replace {old[:50]!r}: expected {expected} got {len(hits)}")
    print(f"ok  replace {len(hits)}x  {old[:60]}")


def find_index(doc, pred, label):
    hits = [i for i, n in enumerate(doc["content"]) if pred(n)]
    if len(hits) != 1:
        sys.exit(f"NG {label}: matched {len(hits)}")
    return hits[0]


def drop_section(doc, needle):
    """見出し <needle> から、同レベル以下の次の見出しまでを削除する。"""
    top = doc["content"]
    idx = None
    for i, n in enumerate(top):
        if n.get("type") == "heading" and needle in flat(n):
            idx = i
            break
    if idx is None:
        sys.exit(f"NG section not found: {needle}")
    level = top[idx]["attrs"]["level"]
    end = idx + 1
    while end < len(top):
        n = top[end]
        if n.get("type") == "heading" and n["attrs"]["level"] <= level:
            break
        end += 1
    del top[idx:end]
    print(f"ok  drop section ({end - idx} nodes)  {needle}")
    return idx


def drop_paragraph(doc, text):
    """本文が text と完全一致する段落を、どの階層からでも取り除く。"""
    removed = []

    def cb(n):
        content = n.get("content")
        if not content:
            return
        keep = []
        for c in content:
            if c.get("type") == "paragraph" and flat(c).strip() == text:
                removed.append(1)
                continue
            keep.append(c)
        n["content"] = keep

    walk(doc, cb)
    if not removed:
        sys.exit(f"NG paragraph not found: {text!r}")
    print(f"ok  drop paragraph {len(removed)}x  {text[:40]}")


def swap_table(doc, head, new_table):
    """flat() が head で始まる表を丸ごと差し替える。head はヘッダ行の連結文字列。"""
    i = find_index(doc, lambda n: n.get("type") == "table" and flat(n).startswith(head), f"table {head}")
    doc["content"][i] = new_table
    print(f"ok  swap table  {head[:40]}")


def add_rows(table_node, anchor_row_text, rows):
    """anchor 行の直後に、同じ構造の行を足す。colwidth は anchor から引き継ぐ。"""
    template = None
    for row in table_node["content"]:
        if anchor_row_text in flat(row):
            template = row
    if template is None:
        sys.exit(f"NG anchor row: {anchor_row_text!r}")
    idx = table_node["content"].index(template)
    for offset, cells in enumerate(rows, start=1):
        new_row = copy.deepcopy(template)
        for cell, value in zip(new_row["content"], cells):
            cell["content"] = [para(value)]
        table_node["content"].insert(idx + offset, new_row)
    print(f"ok  add {len(rows)} rows after {anchor_row_text[:30]}")


def insert_after_section(doc, needle, nodes):
    """見出し <needle> の節（表やパネルを含む）の直後へ挿入する。"""
    top = doc["content"]
    idx = None
    for i, n in enumerate(top):
        if n.get("type") == "heading" and needle in flat(n):
            idx = i
    if idx is None:
        sys.exit(f"NG anchor heading: {needle}")
    at = idx + 1
    while at < len(top) and top[at].get("type") in ("table", "panel", "paragraph"):
        at += 1
    top[at:at] = nodes
    print(f"ok  insert {len(nodes)} nodes at {at}")
    return at


def audit(doc, forbidden=("——", "—", "・")):
    """japanese-tech-writing で禁じた記号が地の文に残っていないか報告する。

    コードブロックと inline code は規範の対象外なので見ない。
    """
    hits = []

    def scan(node):
        if node.get("type") == "codeBlock":
            return
        if node.get("type") == "text":
            if any(m.get("type") == "code" for m in node.get("marks", []) or []):
                return
            for token in forbidden:
                if token in node["text"]:
                    hits.append((token, node["text"][:70]))
        for c in node.get("content", []) or []:
            scan(c)

    scan(doc)
    for token, text in hits:
        print(f"    残 {token}  {text}")
    if not hits:
        print("ok  audit clean")
    return hits
