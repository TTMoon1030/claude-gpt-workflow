#!/bin/bash
# 建立「我的業務資料庫」：資料夾、README_索引.md、CLAUDE.md。
# 用法：build_db.sh [資料庫位置]（預設 ~/Desktop/我的業務資料庫）
# 已經有的資料夾和檔案不會被覆蓋；舊的 CLAUDE.md 沒有生圖做法時，只在最後補上那一段；
# 裡面的 Codex 位置失效或沒填時，換成這台電腦現在的位置；有生圖做法但沒提到外掛時，補一小段。
# 改動既有的 CLAUDE.md 之前，原檔會先複製到 _to_delete/CLAUDE_修改前_<時間>.md。

HERE="$(cd "$(dirname "$0")/.." && pwd)"
ROOT="${1:-$HOME/Desktop/我的業務資料庫}"

mkdir -p "$ROOT"/{01_價格方案,02_產品模組簡報,03_API開發文件,04_合作客戶案例/logo素材,05_提案簡報_範本參考,_scripts,_to_delete} \
         "$ROOT"/06_提案簡報_客戶專案/_範例客戶/_素材/{gpt,backend,mock,_raw} || exit 1
echo "資料夾：已建立（原有的保留不動）"

CODEX=$(bash "$HERE/scripts/find_codex.sh")
[ -n "$CODEX" ] || CODEX="（尚未找到，裝好 ChatGPT 桌面版後請 Claude 再設定一次）"
fill() { sed "s|<Codex 位置>|$CODEX|g" "$1"; }
backed=0
bk() {
  [ $backed = 1 ] && return
  mkdir -p "$ROOT/_to_delete"
  f="$ROOT/_to_delete/CLAUDE_修改前_$(date +%Y%m%d-%H%M%S).md"
  cp -p "$ROOT/CLAUDE.md" "$f" && echo "CLAUDE.md：原檔先備份到 $f"
  backed=1
}

if [ -e "$ROOT/README_索引.md" ]; then
  echo "README_索引.md：已存在，保留原檔"
else
  cp "$HERE/templates/README_索引.md" "$ROOT/README_索引.md" && echo "README_索引.md：已建立"
fi

if [ ! -e "$ROOT/CLAUDE.md" ]; then
  { cat "$HERE/templates/CLAUDE.md"; echo; fill "$HERE/templates/CLAUDE_生圖.md"; } > "$ROOT/CLAUDE.md" && echo "CLAUDE.md：已建立"
elif grep -q "Codex" "$ROOT/CLAUDE.md"; then
  echo "CLAUDE.md：已存在且有生圖做法，沿用原檔"
  old=$(sed -nE 's/.*Codex 位置：[[:space:]]*`?([^`（[:space:]]+).*/\1/p' "$ROOT/CLAUDE.md" | head -1)
  if [ -x "$CODEX" ] && grep -q "Codex 位置：（尚未找到" "$ROOT/CLAUDE.md"; then
    bk; sed -i '' "s|（尚未找到，裝好 ChatGPT 桌面版後請 Claude 再設定一次）|$CODEX|g" "$ROOT/CLAUDE.md" && echo "CLAUDE.md：補上 Codex 位置"
  elif [ -x "$CODEX" ] && [ -n "$old" ] && [ "${old#/}" != "$old" ] && [ ! -x "$old" ]; then
    bk; sed -i '' "s|$old|$CODEX|g" "$ROOT/CLAUDE.md" && echo "CLAUDE.md：Codex 位置已失效，更新為 $CODEX"
  fi
  if ! grep -q "gpt-workflow" "$ROOT/CLAUDE.md"; then
    bk; { echo; fill "$HERE/templates/CLAUDE_生圖補充.md"; } >> "$ROOT/CLAUDE.md" && echo "CLAUDE.md：補上用外掛生圖、不用 API 的說明"
  fi
else
  bk; { echo; fill "$HERE/templates/CLAUDE_生圖.md"; } >> "$ROOT/CLAUDE.md" && echo "CLAUDE.md：已存在，補上生圖做法"
fi
echo "Codex 位置：$CODEX"
