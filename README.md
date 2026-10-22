# Claude × GPT 工作流

讓 Claude（Mac 桌面版的程式碼模式）用這台電腦的 Codex 叫 GPT 生圖，並幫你建立「我的業務資料庫」。Codex 用的是 ChatGPT 登入，不需要 OpenAI API 金鑰。

完整教學：https://claude-workflow-guide.pages.dev/

## 需要

- Mac、Claude 付費方案（使用程式碼模式）
- ChatGPT 桌面版，登入 ChatGPT Plus 以上方案（裡面內建 Codex）

## 安裝與設定

最簡單：到教學頁 https://claude-workflow-guide.pages.dev/#start 按「一鍵開始設定」，Claude 會自己開好新對話並填好下面這段話，按 Enter 送出就好。

也可以手動：在 Claude 程式碼模式開一個新對話（資料夾選「桌面」），貼上這段話：

```
請幫我安裝並完成「Claude × GPT 工作流」設定。我不熟終端機，所有指令都請你執行；需要我動手時，先用一句話告訴我要做什麼，等我回覆再繼續。

1. 安裝外掛：執行 claude plugin marketplace add TTMoon1030/claude-gpt-workflow，再執行 claude plugin install gpt-workflow@claude-gpt-workflow。找不到 claude 指令的話，用 Claude 桌面版內建的：在 ~/Library/Application Support/Claude/claude-code/ 底下搜尋 claude.app/Contents/MacOS/claude（路徑有空格要加引號），用能正常執行 --version 的最新版本。
2. 裝好後，在 ~/.claude/plugins/cache/claude-gpt-workflow/ 底下搜尋 skills/setup/SKILL.md，讀它並照步驟幫我完成設定。
```

Claude 會自動：找出舊版教學留下的東西（有的話先問你要沿用還是搬到備份）→ 找到 Codex → 確認生圖功能 → 確認 ChatGPT 登入（沒登入會給你網址和代碼）→ 在桌面建立「我的業務資料庫」→ 生一張測試圖 → 用表格回報 → 幫你打開每天用的對話（資料夾是「我的業務資料庫」，輸入框先填好一句試畫的話）。你只需要在瀏覽器輸入一次登入代碼，以及在 Claude 詢問時按「允許」。

## 之前照舊版教學做過？

貼一樣的那段話就好。Claude 會先掃描舊版留下的資料夾、規則檔、舊技能、OpenAI API 腳本和金鑰設定，沿用你已經建好的資料夾；要清掉的東西每一類都會先問你，再搬到資料庫的 `_to_delete/舊版設定_<日期>/`，不會直接刪除。外掛已經裝好的話，也可以說「幫我整理舊版設定」（或輸入 `/gpt-workflow:migrate`）。

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
| `scripts/` | 找 Codex、檢查、生圖、建資料庫、掃描舊版痕跡、打開每天用的對話的腳本 |
| `templates/` | 資料庫的 README_索引.md 與 CLAUDE.md 範本 |
