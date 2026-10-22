#!/bin/bash
# 找出這台 Mac 上能用的 Codex，印出完整路徑；找不到時結束代碼為 1。
# 順序：ChatGPT／Codex 桌面版內建（跟著 App 自動更新，.../bin/codex 優先）→ codex 指令 → 常見安裝位置。

try() {
  if [ -x "$1" ] && "$1" --version >/dev/null 2>&1; then
    echo "$1"
    exit 0
  fi
}

while IFS= read -r p; do try "$p"; done < <(find /Applications "$HOME/Applications" -path '*/bin/codex' -type f -perm -u+x 2>/dev/null)
while IFS= read -r p; do try "$p"; done < <(find /Applications "$HOME/Applications" -name codex -type f -perm -u+x 2>/dev/null)
c=$(command -v codex 2>/dev/null) && try "$c"
for p in "$HOME/.local/bin/codex" /opt/homebrew/bin/codex /usr/local/bin/codex "$HOME/.codex/bin/codex"; do
  try "$p"
done
exit 1
