#!/bin/bash
# 用 Codex 叫 GPT 生圖。
# 用法：gen_image.sh <輸出資料夾> <prompt.txt> [參考圖 ...]
# 圖片會存在輸出資料夾；每張大約 1 分鐘，建議在背景執行。

if [ $# -lt 2 ]; then
  echo "用法：gen_image.sh <輸出資料夾> <prompt.txt> [參考圖 ...]"
  exit 2
fi
HERE="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "$1"
OUT="$(cd "$1" && pwd)"
PROMPT="$(cd "$(dirname "$2")" && pwd)/$(basename "$2")"
shift 2
[ -f "$PROMPT" ] || { echo "找不到 prompt 檔：$PROMPT"; exit 2; }

CODEX="${CODEX:-$(bash "$HERE/find_codex.sh")}"
[ -n "$CODEX" ] || { echo "找不到 Codex，請先執行 doctor.sh"; exit 3; }

REFS=()
for r in "$@"; do
  REFS+=(-i "$(cd "$(dirname "$r")" && pwd)/$(basename "$r")")
done

MARK="$OUT/.gen_start"
touch "$MARK"
cd "$OUT" && "$CODEX" exec ${REFS[@]+"${REFS[@]}"} --skip-git-repo-check -s workspace-write -C "$OUT" - < "$PROMPT"
code=$?

echo "---- 這次新增的圖片 ----"
find "$OUT" -maxdepth 1 -type f \( -name '*.png' -o -name '*.jpg' -o -name '*.webp' \) -newer "$MARK" 2>/dev/null | while IFS= read -r f; do
  echo "$f（$(sips -g pixelWidth -g pixelHeight "$f" 2>/dev/null | awk '/pixel/{printf $2" "}')）"
done
rm -f "$MARK"
exit $code
