---
name: hub
description: 打開、連接和使用 VT Workshop 工作台。使用者說「打開工作台」「連接工作台」「貼到廣場」「找之前做過的」「同產業的提案」「廣場上有什麼」時使用。
---

# 工作台（hub）

VT Workshop 工作台在 https://vt-ai-workshop.pages.dev/hub/ ，用 LINE 登入。夥伴做好的客戶網頁都貼在廣場。

這個外掛帶了 `vt-workshop` 連線，連上之後你有三個工具：`search_boards`（查廣場）、`use_board`（拿板子當範本）、`post_board`（貼到廣場）。

- **使用者要找範本或案例**：用 `search_boards`。決定照哪一塊做時用 `use_board`，再打開網址讀內容。內容要換成這位客戶的，不要照抄別的客戶資料。
- **使用者說貼到廣場**：確認網頁已經上線、有 https 網址，用 `post_board`。知道客戶名和產業就帶上，其他會自動判斷。
- **使用者說打開工作台**：執行 `open https://vt-ai-workshop.pages.dev/hub/`。

## 看不到這三個工具，或使用者說「連接工作台」
所有指令都由你執行，使用者不碰終端機。

1. 跟使用者說：「等一下瀏覽器會跳出來，按『允許』就好。」
2. 找 claude 指令：有 `$CLAUDE_CODE_EXECPATH` 就用它，沒有就用 `claude`。路徑有空白，要加引號。
3. 執行 `script -q /dev/null "<claude>" mcp login plugin:gpt-workflow:vt-workshop`，timeout 設 5 分鐘。`script` 不能省，這個指令要有終端機才會等待。它會打開瀏覽器等使用者按允許，看到 Authenticated 就是成功。
4. 執行 `claude mcp list` 確認 `vt-workshop` 已連線。
5. 告訴使用者連好了，開新對話就能用；這次要做的事可以到新對話再說一次。

瀏覽器要求 LINE 登入是正常的，登入後會回到允許畫面。失敗的話請使用者在對話輸入 `/mcp`，選 vt-workshop 登入。
