---
name: c-drive-cleanup-20260513
description: C 槽健康檢查紀錄（2026-05-13）：掃描結果、已清項目、未清項目、RAM 分析
metadata: 
  node_type: memory
  type: project
  originSessionId: dcd75e3a-c8c5-4e42-afa8-314c6638eae5
---

# C 槽健康檢查紀錄（2026-05-13）

## 磁碟概況
- **總容量：** 310 GB
- **剩餘空間：** 140 GB（清理後約 142 GB）
- **已使用：** 170 GB → 清理後約 168 GB

---

## 本次掃描過的路徑（下次可跳過重掃）

| 路徑 | 當時大小 | 備註 |
|------|----------|------|
| `C:\Users\bymyw\AppData\Local\Temp` | 1.8 GB | ✅ 已清，剩 257 MB（部分被程式鎖住） |
| `C:\Windows\Temp` | ~0 MB | 本來就空 |
| `C:\Users\bymyw\AppData\Local\Google\Chrome` | 6.8 GB | 全是 Chrome 資料 |
| `C:\Users\bymyw\AppData\Local\Google\Chrome\...\Cache` | 470 MB | ⏸ 未清（Chrome 執行中） |
| `C:\Users\bymyw\AppData\Local\Google\Chrome\...\Code Cache` | 311 MB | ⏸ 未清（Chrome 執行中） |
| `C:\Users\bymyw\AppData\Local\Google\Chrome\...\Service Worker` | 387 MB | ⏸ 未清（Chrome 執行中） |
| `C:\Users\bymyw\AppData\Local\Microsoft\Edge` | 1.1 GB | 未清，Edge 快取 |
| `C:\Users\bymyw\AppData\Local\Microsoft\WinGet\Packages` | 746 MB | ✅ 已清（安裝包暫存） |
| `C:\Users\bymyw\AppData\Local\Microsoft\OneDrive` | 661 MB | 未動（同步資料） |
| `C:\Users\bymyw\AppData\Local\Microsoft\Office` | 613 MB | 未動（Office 快取） |
| `C:\Users\bymyw\AppData\Local\Microsoft\FontCache` | 108 MB | 未動（字型快取） |
| `C:\Users\bymyw\AppData\Local\Programs` | 2.3 GB | 未動（安裝的程式本體） |
| `C:\Users\bymyw\AppData\Local\Perplexity\Comet` | 3.5 GB | 未動（Comet 瀏覽器主體） |
| `C:\Users\bymyw\AppData\Local\npm-cache` | 49 MB | ✅ 已清 |
| `C:\Users\bymyw\.npm` | 53 MB | ✅ 已清 |
| `C:\Users\bymyw\AppData\Roaming` | 5.4 GB | 未掃細項（各 App 設定） |
| `C:\Users\bymyw\Downloads` | ~0 MB | 基本是空的 |

---

## 已清理項目（本次釋放 ~2.35 GB）

| 項目 | 釋放空間 |
|------|----------|
| AppData\Local\Temp | ~1.5 GB |
| WinGet Packages | 746 MB |
| npm-cache + .npm | 102 MB |
| **合計** | **~2.35 GB** |

---

## 未清項目與原因

| 項目 | 原因 |
|------|------|
| Chrome 快取（~1.2 GB） | Chrome 執行中，檔案被鎖；教練決定留著（對速度有幫助） |
| Edge 快取（1.1 GB） | 未處理 |
| Comet 快取（含在 3.5 GB 內） | 教練主力瀏覽器，不刪 |
| AppData\Roaming（5.4 GB） | 未掃細項，下次可繼續 |

---

## RAM 分析（40 GB 總量，當時剩 13 GB）

| 程式 | RAM 佔用 | 說明 |
|------|----------|------|
| comet.exe ×6 | ~1.65 GB | Perplexity Comet 瀏覽器，多 process 正常 |
| chrome.exe（多個） | ~1.2 GB+ | Chrome 多分頁 |
| LINE.exe | 800 MB | |
| MsMpEng.exe | 387 MB | Windows Defender，必要 |
| dwm.exe | 339 MB | 桌面視窗管理，必要 |
| claude.exe ×2 | ~515 MB | Claude 桌面版 |
| explorer.exe ×2 | ~628 MB | 正常 |
| LogiOverlay.exe | 270 MB | Logitech 滑鼠驅動 |
| Zoom.exe | 258 MB | 沒開會時可關 |

**Comet 身份確認：** `C:\Users\bymyw\AppData\Local\Perplexity\Comet\Application\comet.exe`，Perplexity AI 的 Chromium 核心瀏覽器，教練主力使用中。

---

## 下次繼續可做的事

1. **Chrome 快取**（~1.2 GB）：關掉 Chrome 後叫我清，或在 Chrome 設定內清
2. **Edge 快取**（1.1 GB）：如果沒在用 Edge 可清
3. **AppData\Roaming**（5.4 GB）：掃細項，找可清的 App 快取
4. **Windows 磁碟清理（cleanmgr）**：系統更新殘留、縮圖快取

**Why:** 教練主動要求 C 槽健檢，建立基準線，避免下次重掃浪費時間。
**How to apply:** 下次教練說「繼續清 C 槽」，直接從「未清項目」接手，不用重跑全掃。
