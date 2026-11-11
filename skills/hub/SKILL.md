---
name: hub
description: 打開、連接和使用 VT Workshop 工作台，夥伴都叫它「小鎮」。使用者說到小鎮時使用，例如「貼到小鎮」「貼入小鎮」「存到小鎮」「從小鎮找…」「照小鎮那一塊做」「打開小鎮」；說「打開工作台」「連接工作台」「貼到廣場」「找之前做過的」「同產業的提案」「廣場上有什麼」時也使用。
---

# 工作台（hub）

VT Workshop 工作台在 https://vt-ai-workshop.pages.dev/hub/ ，用 LINE 登入。夥伴都叫它「小鎮」：小鎮、廣場、工作台指的是同一個地方。夥伴做好的客戶網頁都貼在廣場。

這個外掛帶了 `vt-workshop` 連線，連上之後你有這些工具：`search_boards`（查廣場）、`use_board`（拿板子當範本）、`playbook`（讀團隊的做法）、`post_board`（貼到廣場）、`hubspot_link`（客戶的 HubSpot 連結）、`hubspot_logged`。

## 使用者說到「小鎮」時

| 使用者說 | 你要做的 |
|---|---|
| 把某個網址貼到小鎮、貼入小鎮 | 確認網頁已經上線、是 https 網址，用 `post_board`。知道客戶名和產業就帶上。 |
| 從小鎮找某產業或某客戶的提案、範本、Demo 頁、上手指南 | 用 `search_boards`。產業、情境講得出來就帶 `industry`、`scene`，其他放 `query`。 |
| 從小鎮找某個功能的功能展示 | 兩邊都找：用 `search_boards` 帶功能名查，先看情境是「Demo 頁」「應用情境」的；再照 motion 技能（`<外掛>/skills/motion/SKILL.md`）從動畫庫找講同一個功能的動畫。各列出最接近的幾個，附網址。 |
| 從小鎮找某個主題的動畫 | 照 motion 技能做：讀動畫庫清單，挑最接近的，問要不要放進正在做的網頁。 |
| 照小鎮上某一塊做一份給某客戶 | 先 `search_boards` 找到那一塊，用 `use_board` 記一次參考並拿到網址，打開讀內容，再做一份新的。內容要換成這位客戶的，不要照抄別的客戶資料。 |
| 把某客戶的 HubSpot 連結存到小鎮 | 用 `hubspot_link` 帶 `customer` 和 `url`。只存連結，不寫備註。 |
| log hubspot、記到 HubSpot | 照 hubspot 技能（`<外掛>/skills/hubspot/SKILL.md`）做。 |
| 幫某客戶寫開發信、做簡報、Demo 前研究、會後整理、報價單、走期表、交接表，或找開發名單 | 照 playbook 技能（`<外掛>/skills/playbook/SKILL.md`）做：先用 `playbook` 工具讀團隊的做法，再照著做。 |
| 打開小鎮 | 執行 `open https://vt-ai-workshop.pages.dev/hub/`。 |

`<外掛>`＝這份 SKILL.md 所在資料夾的上上一層。

看不到上面的工具，或工具回說要登入、要授權、連不上：先照最下面「連接工作台」那一節重新連上，再繼續。不要改用別的方法去查小鎮的資料，例如直接讀資料庫或抓網頁，那樣不會記參考次數，資料也可能不完整。

## 一般用法

- **使用者要找範本或案例**：用 `search_boards`。決定照哪一塊做時用 `use_board`，再打開網址讀內容。內容要換成這位客戶的，不要照抄別的客戶資料。
- **使用者說貼到廣場**：確認網頁已經上線、有 https 網址，用 `post_board`。知道客戶名和產業就帶上，其他會自動判斷。
- **使用者說打開工作台**：執行 `open https://vt-ai-workshop.pages.dev/hub/`。

## 連接工作台：看不到上面的工具，或使用者說「連接工作台」「連上小鎮」
所有指令都由你執行，使用者不碰終端機。

1. 跟使用者說：「等一下瀏覽器會跳出來，按『允許』就好。」
2. 找 claude 指令：有 `$CLAUDE_CODE_EXECPATH` 就用它，沒有就用 `claude`。路徑有空白，要加引號。
3. 執行 `script -q /dev/null "<claude>" mcp login plugin:gpt-workflow:vt-workshop`，timeout 設 5 分鐘。`script` 不能省，這個指令要有終端機才會等待。它會打開瀏覽器等使用者按允許，看到 Authenticated 就是成功。
4. 執行 `claude mcp list` 確認 `vt-workshop` 已連線。
5. 告訴使用者連好了，開新對話就能用；這次要做的事可以到新對話再說一次。

瀏覽器要求 LINE 登入是正常的，登入後會回到允許畫面。失敗的話請使用者在對話輸入 `/mcp`，選 vt-workshop 登入。
