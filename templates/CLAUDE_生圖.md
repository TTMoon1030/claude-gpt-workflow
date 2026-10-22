## 4. 需要圖片時：用 Codex 叫 GPT 生成
- 一律用 gpt-workflow 外掛的 gpt-image 技能，它會用這台電腦的 Codex（ChatGPT 登入）生圖。
- Codex 位置：<Codex 位置>
- 不要改用 OpenAI API、不要寫呼叫 API 的腳本、不要跟我要 API 金鑰。
- 技能沒有出現時的做法：在客戶資料夾的 `_素材/gpt/` 寫 `prompt.txt`（每張的檔名、尺寸、風格，並寫明畫面不要有任何文字和 logo），然後在背景執行：
  `cd <輸出資料夾> && "<Codex 位置>" exec --skip-git-repo-check -s workspace-write -C <輸出資料夾> - < prompt.txt`
- 生圖前先跑 `"<Codex 位置>" login status`。沒登入就在背景執行 `"<Codex 位置>" login --device-auth`，把網址和代碼給我，等我說好了再繼續；我說先不登入，就把這張圖暫停，不要改用其他方式。
