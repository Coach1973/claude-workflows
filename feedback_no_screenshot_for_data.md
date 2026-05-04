---
name: 禁止用截圖讀取系統資訊
description: 查進程、記憶體、系統狀態一律用終端指令，不用截圖
type: feedback
originSessionId: fc769ef4-d5d8-4036-a479-2b86be5d88b8
---
優先用 ps、top、vm_stat、launchctl、lsof 等指令直接讀取系統資訊，不要用截圖去看 Activity Monitor 或其他 UI。

**Why:** 截圖會消耗流量，而且我住在 Mac 裡面有最高讀取權限，根本不需要靠截圖來看系統狀態。截圖只適合「確認畫面視覺呈現」這種情境。

**How to apply:** 任何涉及進程、記憶體、CPU、磁碟、網路狀態的查詢，第一步永遠是終端指令，不是截圖。
