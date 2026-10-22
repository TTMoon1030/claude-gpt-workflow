#!/bin/bash
# 找出舊版教學留下的東西。只讀取，不修改任何檔案。
# 每一項印一行「類別｜位置｜說明」，最後一行是總結。

HERE="$(cd "$(dirname "$0")" && pwd)"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
say() { echo "$1｜$2｜$3"; }
mask() { sed -E 's/sk-[A-Za-z0-9_-]+/sk-***/g' | cut -c1-140; }

scan() {
# 1. 資料庫：有 README_索引.md、06_提案簡報_客戶專案，或 CLAUDE.md 提到業務資料庫的資料夾
for top in "$HOME/Desktop" "$HOME/Documents"; do
  [ -d "$top" ] || continue
  find "$top" -maxdepth 3 \( -name 'README_索引.md' -o -name '06_提案簡報_客戶專案' \) 2>/dev/null | while IFS= read -r f; do dirname "$f"; done
  find "$top" -maxdepth 3 -name CLAUDE.md 2>/dev/null | while IFS= read -r f; do
    grep -qE '業務資料庫|06_提案簡報|Codex 位置|gpt-image' "$f" 2>/dev/null && dirname "$f"
  done
done | grep -v "/_to_delete/" | sort -u > "$TMP/db"

while IFS= read -r d; do
  [ -n "$d" ] || continue
  if [ "$d" = "$HOME/Desktop" ] || [ "$d" = "$HOME/Documents" ]; then
    say "放錯位置的設定檔" "$d" "桌面或文件最上層有 CLAUDE.md／README_索引.md，可能是在錯的資料夾做了設定"
    continue
  fi
  c="$d/CLAUDE.md"
  if [ ! -f "$c" ]; then kind="沒有 CLAUDE.md"
  elif head -3 "$c" | grep -q '^# 我的業務資料庫 — 工作規則'; then kind="舊版規則包（工作規則）"
  elif ! grep -q 'Codex' "$c"; then kind="缺少生圖做法"
  else kind="已有生圖做法"
  fi
  p=$(sed -nE 's/.*Codex 位置：[[:space:]]*`?([^`（[:space:]]+).*/\1/p' "$c" 2>/dev/null | head -1)
  if grep -q 'Codex 位置：（尚未找到' "$c" 2>/dev/null; then path="Codex 位置未填"
  elif [ -z "$p" ]; then path="沒有寫 Codex 位置"
  elif [ -x "$p" ] || command -v "$p" >/dev/null 2>&1; then path="Codex 位置有效"
  else path="Codex 位置已失效（$p）"
  fi
  files=$(find "$d" -type f ! -name '.DS_Store' ! -name 'CLAUDE.md' ! -name 'README_索引.md' ! -path '*/node_modules/*' ! -path '*/.venv/*' ! -path '*/venv/*' ! -path '*/_to_delete/*' 2>/dev/null | wc -l | tr -d ' ')
  readme=$([ -f "$d/README_索引.md" ] && echo "有索引" || echo "沒有索引")
  say "資料庫" "$d" "CLAUDE.md：$kind；$path；$readme；自己的檔案 $files 個"
done < "$TMP/db"

# 2. 資料庫裡的 OpenAI API 生圖腳本、金鑰檔、Python 環境
while IFS= read -r d; do
  [ -n "$d" ] || continue
  [ "$d" = "$HOME/Desktop" ] || [ "$d" = "$HOME/Documents" ] && continue
  grep -rlE 'api\.openai\.com|from openai|import openai|require\(.openai.\)|OPENAI_API_KEY|gpt-image-1|images\.generate' \
    --include='*.py' --include='*.js' --include='*.mjs' --include='*.ts' --include='*.sh' --include='*.ipynb' \
    --exclude-dir=node_modules --exclude-dir=.venv --exclude-dir=venv --exclude-dir=_to_delete --exclude-dir=claude-gpt-workflow "$d" 2>/dev/null | while IFS= read -r f; do
    say "OpenAI API 腳本" "$f" "舊的生圖做法，要用 API 金鑰"
  done
  find "$d" -name '.env*' -type f ! -path '*/_to_delete/*' 2>/dev/null | while IFS= read -r f; do
    grep -q 'OPENAI_API_KEY' "$f" && say "API 金鑰檔" "$f" "裡面有 OPENAI_API_KEY（內容不顯示）"
  done
  find "$d" -maxdepth 3 -type d \( -name '.venv' -o -name 'venv' \) ! -path '*/_to_delete/*' 2>/dev/null | while IFS= read -r f; do
    say "Python 環境" "$f" "可能是給 API 腳本裝的"
  done
done < "$TMP/db"

# 3. 終端機設定檔裡的 OPENAI_API_KEY
for f in "$HOME/.zshrc" "$HOME/.zprofile" "$HOME/.bash_profile" "$HOME/.bashrc" "$HOME/.profile" "$HOME/.zshenv"; do
  [ -f "$f" ] || continue
  grep -n 'OPENAI_API_KEY' "$f" 2>/dev/null | grep -v '^[0-9]*:[[:space:]]*#' | while IFS=: read -r ln _; do
    say "終端機設定" "$f 第 $ln 行" "設定了 OPENAI_API_KEY（內容不顯示）"
  done
done

# 4. 舊的生圖技能
for s in "$HOME"/.claude/skills/*/SKILL.md; do
  [ -f "$s" ] || continue
  if grep -qiE 'codex|gpt-image|生圖' "$s"; then say "舊技能（本機）" "$(dirname "$s")" "舊版教學裝的生圖技能，和外掛重複"; fi
done
for s in "$HOME"/Library/Application\ Support/Claude/local-agent-mode-sessions/skills-plugin/*/*/skills/*/SKILL.md; do
  [ -f "$s" ] || continue
  if grep -qiE 'codex' "$s" && grep -qiE 'gpt|生圖|image' "$s"; then
    name=$(basename "$(dirname "$s")")
    man="$(dirname "$(dirname "$(dirname "$s")")")/manifest.json"
    i=0; off=0
    while nm=$(plutil -extract "skills.$i.name" raw -o - "$man" 2>/dev/null); do
      [ "$nm" = "$name" ] && [ "$(plutil -extract "skills.$i.enabled" raw -o - "$man" 2>/dev/null)" = "false" ] && off=1
      i=$((i+1))
    done
    [ $off = 1 ] && continue
    say "舊技能（帳號上傳）" "$(basename "$(dirname "$s")")" "在 Claude「自訂 → 技能」上傳過的生圖技能，和外掛重複"
  fi
done

# 5. Claude 記憶裡要用 API 的筆記
for m in "$HOME"/.claude/projects/*/memory/*.md; do
  [ -f "$m" ] || continue
  hit=$(grep -nE 'OPENAI_API_KEY|OpenAI API|gpt-image-1|images\.generate|API 金鑰|API key' "$m" 2>/dev/null | grep -vE '不要|不需|不用|無需|別|免|No API|no API|without' | head -2 | mask)
  [ -n "$hit" ] && say "Claude 記憶" "$m" "$(echo "$hit" | tr '\n' ' ')"
done

# 6. Codex：每一份的位置與版本，以及目前用哪一份、用什麼登入
picked=$(bash "$HERE/find_codex.sh")
{
  type -ap codex 2>/dev/null
  ls "$HOME"/.local/bin/codex /opt/homebrew/bin/codex /usr/local/bin/codex "$HOME"/.codex/bin/codex "$HOME"/.nvm/versions/node/*/bin/codex 2>/dev/null
  find /Applications "$HOME/Applications" -path '*/bin/codex' -type f -perm -u+x 2>/dev/null
} | while IFS= read -r p; do [ -x "$p" ] && (cd "$(dirname "$p")" && echo "$(pwd -P)/$(basename "$p")"); done | sort -u > "$TMP/codex"
count=$(wc -l < "$TMP/codex" | tr -d ' ')
if [ "$count" -gt 1 ]; then
  while IFS= read -r p; do
    v=$("$p" --version 2>/dev/null | head -1)
    note="另一份 Codex，不影響使用"
    [ "$(cd "$(dirname "$picked")" 2>/dev/null && pwd -P)/$(basename "$picked")" = "$p" ] && note="目前使用這一份"
    say "Codex" "$p" "${v:-無法執行}；$note"
  done < "$TMP/codex"
fi
if [ -n "$picked" ]; then
  st=$("$picked" login status 2>&1)
  echo "$st" | grep -qi 'api key' && say "Codex 登入方式" "$picked" "目前用 API 金鑰登入，建議改成 ChatGPT 登入"
fi

# 7. 其他相關外掛（只提醒，不需處理）
if [ -f "$HOME/.claude/plugins/installed_plugins.json" ] && grep -qi 'codex' "$HOME/.claude/plugins/installed_plugins.json"; then
  say "其他外掛" "$HOME/.claude/plugins" "裝過 OpenAI 的 Codex 外掛（文字和程式用），生圖用不到，留著不影響"
fi

}

scan > "$TMP/out"
cat "$TMP/out"
n=$(grep -c "｜" "$TMP/out")
if [ "$n" = 0 ]; then echo "總結：沒有找到舊版留下的東西"; else echo "總結：找到 $n 項"; fi
