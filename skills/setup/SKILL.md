---
name: setup
description: 第一次設定「Claude × GPT 工作流」：找到 Codex、確認 ChatGPT 登入、建立「我的業務資料庫」、生一張測試圖確認能用。使用者說「幫我完成設定」「初始設定」「設定 GPT 生圖」「建立業務資料庫」時使用。
---

# 第一次設定

外掛資料夾＝這份 SKILL.md 往上兩層的資料夾，下面寫作 `<外掛>`；`<Codex>` 是第 1 步查到的 Codex 完整路徑。

使用者不熟終端機：所有指令都由你執行。需要使用者動手或做決定時，先用一句話說要做什麼，等回覆再繼續。生圖一律用這台 Mac 的 Codex（ChatGPT 登入）：不要改用 OpenAI API、不要寫呼叫 API 的腳本、不要跟使用者要 API 金鑰。

1. **檢查**：執行 `bash "<外掛>/scripts/doctor.sh"`，照結果處理，處理完再跑一次，直到 Codex、生圖功能、登入都正常（資料庫在第 2 步建）：
   - Codex 未找到：請使用者安裝 ChatGPT 桌面版（https://chatgpt.com/download/ ，需要 ChatGPT Plus 以上方案），打開並登入後告訴你。
   - 生圖功能未開啟：執行 `"<Codex>" features enable image_generation`。
   - 未登入：在背景執行 `"<Codex>" login --device-auth`，從輸出找出網址和代碼給使用者（15 分鐘內有效），並說明畫面上「別人給你代碼就取消」的提醒是正常的，因為是使用者自己要登入。這個程序要在背景一直跑到使用者說好；代碼過期就重跑。
2. **建資料庫**：執行 `bash "<外掛>/scripts/build_db.sh"`。它會在桌面建立「我的業務資料庫」、README_索引.md 和 CLAUDE.md，已經有的資料夾和檔案不會被覆蓋。
3. **測試生圖**：在背景執行 `bash "<外掛>/scripts/test_image.sh"`（約 1–2 分鐘），完成後用 Read 打開 `~/Desktop/我的業務資料庫/06_提案簡報_客戶專案/_範例客戶/_素材/gpt/test.png` 給使用者看。失敗時照 check 技能（`<外掛>/skills/check/SKILL.md`）的對照表處理，再測一次。
4. **回報**：用表格列出 Codex 位置、登入、資料庫、測試圖，每項是「完成」或「需要你處理」。最後提醒使用者：點左上「＋ 新增」，資料夾選「我的業務資料庫」開新對話，之後每天都從這裡開始；要圖片時直接說「用 GPT 畫…」。
