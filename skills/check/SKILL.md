---
name: check
description: GPT 生圖失敗或設定有問題時使用：找不到 Codex、Not logged in、額度用完、圖沒出現在資料夾、Claude 要 OpenAI API 金鑰。使用者說「生圖失敗」「幫我檢查設定」「為什麼不能畫圖」時使用。
---

# 檢查與排錯

`<外掛>`＝有 `scripts/` 資料夾的那一層，也就是這份 SKILL.md 所在資料夾的上上一層（從 GitHub 安裝的是 `…/gpt-workflow/<版本>/`）；`<Codex>` 是 doctor.sh 印出的 Codex 路徑。

先執行 `bash "<外掛>/scripts/doctor.sh"`，再照下表處理。指令都由你執行；需要使用者動手時，先用一句話說要做什麼。不要改用 OpenAI API，也不要跟使用者要 API 金鑰。

| 看到的狀況 | 處理方式 |
|---|---|
| Codex：未找到 | 請使用者安裝並登入 ChatGPT 桌面版（https://chatgpt.com/download/ ），裝好後再檢查一次。 |
| 生圖功能：未開啟 | 執行 `"<Codex>" features enable image_generation`。 |
| 登入：未登入、Not logged in | 在背景執行 `"<Codex>" login --device-auth`，把網址和代碼給使用者，等使用者說好再檢查。 |
| 資料庫或 CLAUDE.md 缺少 | 執行 `bash "<外掛>/scripts/build_db.sh"`，原有檔案不會被覆蓋。 |
| Codex 訊息提到 usage limit、rate limit、quota | Codex 額度用完了。請使用者等額度重置（訊息裡通常有時間），或改天再畫。 |
| Codex 訊息提到 plan、upgrade、not available | 帳號方案不能生圖，需要 ChatGPT Plus 以上。 |
| 跑完了但資料夾裡沒有圖 | 到 `~/.codex/generated_images/` 找最新的圖複製過去；下次 prompt 寫明「存成目前資料夾裡的 檔名.png」。 |
| 你（Claude）想寫 OpenAI API 腳本或要金鑰 | 不要這樣做，改用 gpt-image 技能（`<外掛>/skills/gpt-image/SKILL.md`）。 |
| 之前照舊版教學做過，有兩套設定、兩個資料夾或舊技能 | 照 migrate 技能（`<外掛>/skills/migrate/SKILL.md`）整理，舊東西會搬到備份，不會刪除。 |
| Claude 每一步都問要不要允許 | 正常，這是 Claude 執行指令前的確認，按「允許」就好。 |

處理完再跑一次 doctor.sh。最後用表格回報每一項的狀態。
