# Claude × GPT 工作流

讓 Claude（Mac 桌面版的程式碼模式）用這台電腦的 Codex 叫 GPT 生圖，並幫你建立「我的業務資料庫」。Codex 用的是 ChatGPT 登入，不需要 OpenAI API 金鑰。

完整教學：https://vt-ai-workshop.pages.dev/

## 需要

- Mac、Claude 付費方案（使用程式碼模式）
- ChatGPT 桌面版，登入 ChatGPT Plus 以上方案（裡面內建 Codex）

## 安裝與設定

外掛由 VT Workshop 工作台（小鎮）發給團隊的夥伴，不從 GitHub 安裝。

1. 用 LINE 登入小鎮：https://vt-ai-workshop.pages.dev/hub/
2. 到「工坊」最下面的「第一次用」，按「安裝工作流外掛」。Claude 會開好新對話並填好指令，按 Enter 送出就好。

指令裡有一個一次性的配對碼（30 分鐘內有效）。Claude 用它向小鎮拿一把下載外掛的鑰匙，存在你電腦的 `~/.vt-workshop/plugin-headers.json`，之後更新外掛都靠它，不用再登入。離開團隊後這把鑰匙就失效。

Claude 會自動：找出舊版教學留下的東西（有的話先問你要沿用還是搬到備份）→ 找到 Codex → 確認生圖功能 → 確認 ChatGPT 登入（沒登入會給你網址和代碼）→ 在桌面建立「我的業務資料庫」→ 生一張測試圖 → 用表格回報 → 幫你打開每天用的對話（資料夾是「我的業務資料庫」，輸入框先填好一句試畫的話）。你只需要在瀏覽器輸入一次登入代碼，以及在 Claude 詢問時按「允許」。

## 之前照舊版教學做過？

一樣到小鎮的工坊按「安裝工作流外掛」就好。Claude 會先掃描舊版留下的資料夾、規則檔、舊技能、OpenAI API 腳本和金鑰設定，沿用你已經建好的資料夾；要清掉的東西每一類都會先問你，再搬到資料庫的 `_to_delete/舊版設定_<日期>/`，不會直接刪除。外掛已經裝好的話，也可以說「幫我整理舊版設定」（或輸入 `/gpt-workflow:migrate`）。

## 之後怎麼用

- 生圖：直接說「用 GPT 畫一張…」，或輸入 `/gpt-workflow:gpt-image`。
- 出問題：說「幫我檢查設定」，或輸入 `/gpt-workflow:check`。
- 重新設定：輸入 `/gpt-workflow:setup`。
- 網頁加動畫：說「用動畫存儲區的 #02」或「網頁加一個渠道環繞的動畫」，或輸入 `/gpt-workflow:motion`。動畫清單在教學頁的「動畫存儲區」，會不定時更新，每次用都是最新版。

## 內容

| 位置 | 用途 |
|---|---|
| `skills/setup/` | 第一次設定＋測試生圖 |
| `skills/gpt-image/` | 用 Codex 叫 GPT 生圖 |
| `skills/check/` | 檢查與排錯對照表 |
| `skills/migrate/` | 整理舊版教學留下的東西，沿用已建好的資料夾 |
| `skills/motion/` | 從動畫存儲區套用現成動畫到網頁 |
| `skills/hubspot/` | 說一句 log hubspot，把剛做的事記到 HubSpot；也負責檢查 Chrome 的 Claude 擴充功能 |
| `skills/hub/` | 連上 VT Workshop 工作台（小鎮）：說到「小鎮」就會貼板子、找提案、找動畫、存 HubSpot 連結 |
| `skills/playbook/` | 說一句要做什麼（開發信、簡報、會後整理、報價單…），先從小鎮讀團隊的做法再照著做；要先連上小鎮 |
| `scripts/` | 找 Codex、檢查、生圖、建資料庫、掃描舊版痕跡、打開每天用的對話的腳本 |
| `templates/` | 資料庫的 README_索引.md 與 CLAUDE.md 範本 |

## 工作台
跟 Claude 說「找同產業做過的提案」「貼到廣場」就能查板子、貼板子，第一次要在瀏覽器按一下「允許」。說「打開工作台」會開 https://vt-ai-workshop.pages.dev/hub/ 。

## 更新
外掛會自己更新：新版發出來之後，下一次開 Claude 對話、送出第一句話後的十分鐘內會在背景更新，再下一次開對話就用到新版。想馬上更新，到工作台小鎮入口的「外掛更新站」按「一鍵更新」。更新紀錄看 [CHANGELOG.md](CHANGELOG.md)。

## 分享你做的工具
跟 Claude 說「幫我把這個工具發給 Rex，由他整合上線」。Claude 會先列出要傳的檔案給你確認，傳出去之後由 Rex 審過、放進外掛，全隊都能用。進度在小鎮工坊的「分享你做的工具」。
