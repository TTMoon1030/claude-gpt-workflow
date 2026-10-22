#!/bin/bash
# 建立「我的業務資料庫」：資料夾、README_索引.md、CLAUDE.md。
# 用法：build_db.sh [資料庫位置]（預設 ~/Desktop/我的業務資料庫）
# 已經有的資料夾和檔案不會被覆蓋；舊的 CLAUDE.md 沒有生圖做法時，只在最後補上那一段。

HERE="$(cd "$(dirname "$0")/.." && pwd)"
ROOT="${1:-$HOME/Desktop/我的業務資料庫}"

mkdir -p "$ROOT"/{01_價格方案,02_產品模組簡報,03_API開發文件,04_合作客戶案例/logo素材,05_提案簡報_範本參考,_scripts,_to_delete} \
         "$ROOT"/06_提案簡報_客戶專案/_範例客戶/_素材/{gpt,backend,mock,_raw} || exit 1
echo "資料夾：已建立（原有的保留不動）"

CODEX=$(bash "$HERE/scripts/find_codex.sh")
[ -n "$CODEX" ] || CODEX="（尚未找到，裝好 ChatGPT 桌面版後請 Claude 再設定一次）"
fill() { sed "s|<Codex 位置>|$CODEX|g" "$1"; }

if [ -e "$ROOT/README_索引.md" ]; then
  echo "README_索引.md：已存在，保留原檔"
else
  cp "$HERE/templates/README_索引.md" "$ROOT/README_索引.md" && echo "README_索引.md：已建立"
fi

if [ ! -e "$ROOT/CLAUDE.md" ]; then
  { cat "$HERE/templates/CLAUDE.md"; echo; fill "$HERE/templates/CLAUDE_生圖.md"; } > "$ROOT/CLAUDE.md" && echo "CLAUDE.md：已建立"
elif grep -q "Codex" "$ROOT/CLAUDE.md"; then
  echo "CLAUDE.md：已存在且有生圖做法，保留原檔"
else
  { echo; fill "$HERE/templates/CLAUDE_生圖.md"; } >> "$ROOT/CLAUDE.md" && echo "CLAUDE.md：已存在，補上生圖做法"
fi
echo "Codex 位置：$CODEX"
