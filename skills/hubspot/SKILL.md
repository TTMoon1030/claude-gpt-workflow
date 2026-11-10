---
name: hubspot
description: 把剛做的事記到 HubSpot。使用者說「log hubspot」「hubspot log」「記到 HubSpot」「寫 HubSpot 紀錄」「更新 HubSpot」時使用。根據這段對話最新做的事寫好紀錄，使用者確認後，用 Chrome 寫進這位客戶的 HubSpot 備註並儲存。
---

# 記到 HubSpot（hubspot）

使用者說一句 log hubspot，你要做完四件事：判斷客戶和內容、給他確認、寫進 HubSpot 並儲存、回報。

公司沒有開放 HubSpot 的 API，所以是用 Chrome 擴充功能 Claude in Chrome，操作使用者自己登入的 HubSpot。

## 一、判斷是哪位客戶、要記什麼

1. **客戶**：看這段對話在做誰的事，例如客戶資料夾、檔名、網頁、對話內容。看不出來，或同時有兩位以上，就問一句。
2. **內容以這段對話裡最新做的事為主**：做了什麼、產出了什麼檔案或網址、客戶說了什麼、接下來要做什麼。
3. **這段對話沒什麼內容時**，例如剛開對話就說 log hubspot：看這位客戶資料夾裡最近的檔案和你記得的進度；有搜尋過去對話的工具，就搜尋客戶名，看標題、時間和摘要，不用整段讀。只看上次寫入之後的。
4. 沒有真的發生的事不要寫。看不出來的欄位就省略，不要補。

## 二、查這位客戶的 HubSpot 紀錄網址

- 用 `hubspot_link` 帶客戶名查。查得到會給網址和上次寫入的日期。
- **還沒連過**：請使用者到 HubSpot 打開這位客戶的頁面，聯絡人、公司或交易都可以，把網址貼給你；再用 `hubspot_link` 帶 `url` 存起來。每位客戶只要一次。
- **沒有 `hubspot_link` 這個工具**，代表還沒連上工作台：這次先請使用者貼網址直接用。做完提醒他到工作台小鎮入口的更新站連上 Claude，之後就不用再貼。
- 使用者已經在訊息裡給了 HubSpot 紀錄網址，就直接用，不用再查。
- 使用者只說「把某客戶的 HubSpot 連結存到小鎮」：用 `hubspot_link` 帶 `url` 存好就結束，不用寫備註。
- 網址一定要是 `https://app….hubspot.com/contacts/…` 開頭的紀錄頁。不是就不要用，請他重貼。

## 三、給使用者確認

用下面的格式把紀錄貼在對話裡，問「這樣記可以嗎？」。等他說可以才往下；他改了，就照改完的版本。

```
客戶：<客戶名>
會寫到：<HubSpot 紀錄網址>

<M/D> <一句話標題>
對象：<誰>
做了什麼：
・…
客戶需求與疑慮：
・…
下一步：
・<誰> <做什麼> <日期>
```

寫法：

- 用短句，一則控制在 15 行以內。
- 條列一律用「・」開頭。每一行都不要用「- 」「* 」或「1. 」開頭：HubSpot 會把它自動變成清單，後面整段版面會亂掉。
- 沒有內容的段落整段拿掉。

## 四、寫進 HubSpot 並儲存

使用者確認之後才做。Claude in Chrome 的工具是 `mcp__claude-in-chrome__*`，要先載入的話一次載入需要的幾個。

1. 確認連到的是這台電腦的 Chrome：用 `list_connected_browsers` 看，連著好幾台就用 `select_browser` 選 `onThisComputer` 的那一台。
2. 開新分頁到 `<紀錄網址>?interaction=note`，等 4 秒。備註視窗會自己打開。
3. 用 `find` 找寫著「開始輸入備註」的輸入區，用它的 ref 點一下，再把確認過的內容打進去。從標題那一行開始打，不含「客戶：」「會寫到：」這兩行。
4. 按備註視窗右上角的放大鈕，截一張圖檢查：每一行都在、沒有變成清單、「對於」後面有顯示對象。有問題就改到對。
5. 按「建立備註」。
6. 確認存進去了：備註視窗關掉，而且活動時間軸最上面出現這則備註，可以用 `find` 找標題那一行。看到權限或錯誤訊息，就照原文告訴使用者，不要重按。
7. 關掉你開的分頁。有 `hubspot_logged` 工具就呼叫它，客戶名用 `hubspot_link` 回的那個。
8. 用一兩句回報：記到哪位客戶、標題是什麼。

## 不能做的事

- 使用者還沒在這段對話確認內容之前，不要按「建立備註」。
- 不要輸入帳號密碼。出現登入頁，就請使用者自己在 Chrome 登入 HubSpot，登入好再繼續。
- 只新增備註。不要改客戶資料、交易階段，也不要刪除任何東西。
- 同一步試兩次不行就停，不要一直重試。

## 做不到的時候

你沒有 `mcp__claude-in-chrome__*` 的工具，或 Chrome 還沒裝 Claude 擴充功能：先照下面「Chrome 的 Claude 擴充功能」一節帶使用者裝好，再繼續。

Chrome 連不上、找不到備註輸入區，或存不進去：把確認過的紀錄放在程式碼區塊給使用者，請他自己貼到 HubSpot，並用一句話說卡在哪。

## Chrome 的 Claude 擴充功能

log hubspot 要靠它操作 Chrome。setup 和 check 技能也照這一節檢查。指令都由你執行。

1. 檢查有沒有裝：執行 `ls ~/Library/Application\ Support/Google/Chrome/*/Extensions/fcoeoabgfenejglbffodgkkbkcdhcgfn 2>/dev/null`。有列出東西就是裝好了。
2. 沒裝的話，先確認有 Chrome：`ls -d "/Applications/Google Chrome.app"`。沒有 Chrome 就請使用者到 https://www.google.com/chrome/ 安裝，裝好再繼續。
3. 打開安裝頁：`open -a "Google Chrome" "https://chromewebstore.google.com/detail/claude/fcoeoabgfenejglbffodgkkbkcdhcgfn"`。
4. 請使用者做兩件事，做完告訴你：按「加到 Chrome」；再點 Chrome 右上角的 Claude 圖示，用和這裡同一個 Claude 帳號登入。
5. 再檢查一次。裝好了但你還是沒有 `mcp__claude-in-chrome__*` 的工具，請使用者開一個新對話再試。

這個擴充功能是 Anthropic 官方出的，你不能替使用者按安裝，也不要改用其他擴充功能。
