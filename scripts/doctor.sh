#!/bin/bash
# 檢查 Claude × GPT 工作流需要的東西，每一項印一行「項目：結果」，最後一行是總結。

HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="${1:-$HOME/Desktop/我的業務資料庫}"
ok=1

CODEX=$(bash "$HERE/find_codex.sh")
if [ -z "$CODEX" ]; then
  echo "Codex：未找到（請安裝並登入 ChatGPT 桌面版 https://chatgpt.com/download/ ）"
  echo "總結：需要處理"
  exit 1
fi
echo "Codex：$CODEX"
echo "版本：$("$CODEX" --version 2>&1 | head -1)"

if "$CODEX" features list 2>/dev/null | grep -Eq '^image_generation[[:space:]].*true[[:space:]]*$'; then
  echo "生圖功能：已開啟"
else
  echo "生圖功能：未開啟（執行 \"$CODEX\" features enable image_generation）"
  ok=0
fi

status=$("$CODEX" login status 2>&1)
if echo "$status" | grep -q "Logged in using ChatGPT"; then
  echo "登入：已用 ChatGPT 登入"
elif echo "$status" | grep -q "Logged in"; then
  echo "登入：$status（建議改用 ChatGPT 登入：\"$CODEX\" login --device-auth）"
  ok=0
else
  echo "登入：未登入（在背景執行 \"$CODEX\" login --device-auth）"
  ok=0
fi

if [ -d "$ROOT" ]; then
  echo "資料庫：$ROOT"
  if [ -f "$ROOT/CLAUDE.md" ] && grep -q "Codex" "$ROOT/CLAUDE.md"; then
    echo "CLAUDE.md：已寫入生圖做法"
  else
    echo "CLAUDE.md：缺少生圖做法（執行 build_db.sh 補上）"
    ok=0
  fi
else
  echo "資料庫：尚未建立（執行 build_db.sh）"
  ok=0
fi

if [ $ok = 1 ]; then echo "總結：全部正常"; else echo "總結：需要處理"; exit 1; fi
