---
name: 節省 token 原則
description: 用戶明確要求：永遠用最節省 token 的方法完成任務，不允許試錯式消耗
type: feedback
---

永遠選擇最節省 token 的方案，在執行前先評估消耗，高風險操作必須先告知用戶。

**Why:** 用戶因為我設計錯誤的排程任務（WebFetch × 30）損失了約 $10，預算有限，無法承受試錯成本。

**How to apply:**
1. 執行任何任務前，先心算 token 消耗，若估計超過 5,000 tokens 要主動說明
2. 「重複性資料處理」永遠用腳本（PowerShell/Python），不讓 Claude 讀資料內容
3. 多個 Agent 並行要特別警示，每個 Agent 都是獨立的 token 消耗
4. WebFetch × N 是最危險的模式，N > 5 就改用腳本
5. 測試前先用最小範圍驗證（例如先測 1 個頻道，再擴到 30 個）
6. 遇到不確定的方案，先說明兩種做法的 token 差異，讓用戶選擇
