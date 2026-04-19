# HANDOFF：VPS 智慧血肉同步機制 (Knowledge Sync)

## 任務背景
VPS 小龍蝦目前已具備「防幻覺鐵鎖」，只會回答真實的海餅乾守則。但因為缺乏「實戰案例與教練的對話精華」，導致它在面對深入問題時只能回答「無法讀取內部資料」。
我們需要將 Mac 端提煉出的智慧（血肉），定期同步給 VPS。

## 移交給 Claude 助教的任務
請 Claude 助教接手設計以下「智慧同步管線」：

1. **建立《海餅乾實戰案例庫》格式**：
   在 Mac 端建立一個專屬檔案（例如 `seabiscuit_case_studies.md`），專門存放教練口述過的 10 大守則實戰案例與管理精華。

2. **設計同步腳本 (Sync Script)**：
   寫一支腳本，讓終端機助教可以一鍵將 Mac 端的 `seabiscuit_case_studies.md` 以及 `seabiscuit_distilled_knowledge.md` 透過 SSH 傳送到 VPS (43.245.60.200) 的 workspace 中。

3. **更新 VPS SOUL.md 讀取權限**：
   修改 VPS 的 `SOUL.md`，追加一條指令：「當使用者詢問『實戰應用』、『案例』或『具體怎麼做』時，必須強制讀取 `seabiscuit_case_studies.md`，並使用裡面的真實案例來回答。」

## 產出要求
請產出上述的 `.md` 範本與 SSH 傳送指令，並整理成終端機助教可以直接執行的步驟，確保 VPS 小龍蝦的大腦能獲得「血肉」的灌注。