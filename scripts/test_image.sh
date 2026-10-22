#!/bin/bash
# 生一張測試圖，確認 Codex 生圖能用。成功時印出圖片路徑。
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="${1:-$HOME/Desktop/我的業務資料庫}"
OUT="$ROOT/06_提案簡報_客戶專案/_範例客戶/_素材/gpt"
mkdir -p "$OUT"
rm -f "$OUT/test.png"
cat > "$OUT/prompt_test.txt" <<'P'
請用內建的圖片生成工具畫一張圖，存成目前資料夾裡的 test.png（如果工具存到別的地方，請複製過來）。只畫這一張，不要建立或修改其他檔案。

尺寸 1024x1024。扁平向量插畫：一台打開的筆電，螢幕上是一張彩色插畫，旁邊一個圓圓的小機器人在揮手。紫色系、淺色背景、乾淨留白。畫面不要有任何文字和 logo。
P
bash "$HERE/gen_image.sh" "$OUT" "$OUT/prompt_test.txt"
if [ -s "$OUT/test.png" ]; then
  echo "測試結果：成功 $OUT/test.png"
else
  echo "測試結果：失敗，資料夾裡沒有 test.png（看上面 Codex 的訊息，或對照 check 技能）"
  exit 1
fi
