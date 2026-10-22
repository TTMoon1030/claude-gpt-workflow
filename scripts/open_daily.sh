#!/bin/bash
# 在 Claude 開一個新的程式碼對話：資料夾是資料庫，輸入框先填好一句話（不會自動送出）。
# 用法：open_daily.sh [資料庫位置] [要先填好的話]
# 設 DRY_RUN=1 只印出連結，不打開。

ROOT="${1:-$HOME/Desktop/我的業務資料庫}"
MSG="${2:-用 GPT 畫一張 1536x1024 的扁平插畫：一位業務在咖啡廳用筆電和客戶視訊，紫色系，畫面不要有任何文字。存到 06_提案簡報_客戶專案/練習/_素材/gpt/。}"

enc() { osascript -l JavaScript -e 'function run(a){return encodeURIComponent(a[0])}' "$1"; }
URL="claude://code/new?folder=$(enc "$ROOT")&q=$(enc "$MSG")"

if [ "${DRY_RUN:-0}" = 1 ]; then echo "$URL"; exit 0; fi
open "$URL" && echo "已在 Claude 開好新對話（資料夾：$ROOT），輸入框已填好，按 Enter 送出"
