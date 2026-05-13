---
name: e-drive-cleanup-20260513
description: E 槽清理工作紀錄：已刪項目、保留項目、待確認項目、磁碟現況
metadata:
  type: project
---

# E 槽清理工作紀錄（2026-05-13）

## 背景
教練委託清理 E 槽 `待刪除/` 資料夾，前任 Claude 桌面版已做初步評估，本次由軍師大腦（Windows 站）接手執行。

## E 槽現況
- 總容量：954 GB
- 清理前：640 GB 已用，314 GB 可用（68%）
- 清理後：629 GB 已用，326 GB 可用（66%）
- 本次釋放：約 11 GB

## 已刪除項目（2026-05-13 執行）

| 檔案 | 路徑 | 大小 |
|------|------|------|
| Win10_21H2_Chinese(Traditional)_x64.iso | `E:\待刪除\SOFTWARE_MISC\` | 5.5 GB |
| 038-87170-061.dmg | `E:\待刪除\SOFTWARE_MISC\` | 88 MB |
| 038-87199-051.dmg | `E:\待刪除\SOFTWARE_MISC\` | 2.7 GB |
| 038-87260-065.dmg | `E:\待刪除\SOFTWARE_MISC\` | 90 MB |
| NVIDIA_GeForce_RTX_3050_Ti_Laptop_GPU_win10_amd64-730234.dbb | `E:\待刪除\SOFTWARE_MISC\` | 646 MB |
| NVIDIA_GeForce_RTX_3050_Ti_Laptop_GPU_win10_amd64-795765.dbb | `E:\待刪除\SOFTWARE_MISC\` | 1.2 GB |
| NVIDIA_GeForce_RTX_3050_Ti_Laptop_GPU_win10_amd64-3341468.dbb | `E:\待刪除\SOFTWARE_MISC\` | 1.2 GB |

## 保留項目（教練決定暫不刪，空間夠用）

| 項目 | 大小 | 原因 |
|------|------|------|
| ThinPC_110415_EVAL_x86fre.iso | 1.5 GB | 空間夠，暫留 |
| Win11_24H2_Chinese_Traditional_x64.iso | 5.4 GB | 最新 Win11，建議保留當救援碟 |
| office 2021Retail.img | 4.6 GB | 待確認是否還在用 |
| winpe.wim | 1.1 GB | 系統救援用，建議保留 |
| NVIDIA_GeForce_RTX_3050_Ti_Laptop_GPU_win10_amd64-1242531.dbb | 1.2 GB | 最新版，保留 |
| PowerDirector 16 安裝包 × 5 | 4.6 GB | 空間夠，暫留 |

## 待下次處理的項目

| 項目 | 路徑 | 大小 | 備註 |
|------|------|------|------|
| VIDEOS_待確認/ | `E:\待刪除\` | 243 GB | 教練講課影片，多數已上傳 YouTube，計畫移至儲存硬碟 |
| 易数一键还原_程式本體 | `E:\待刪除\` | 37 KB | 可刪 |
| FonePaw Temp | `E:\待刪除\` | 5 KB | iPhone 救援暫存，可刪 |
| 根目錄舊腳本 | `E:\待刪除\` | 9 MB | 可刪 |
| 空殼資料夾 | `E:\待刪除\` | 24 KB | 可刪 |

## 重要發現：前任分析修正

前任 Claude 桌面版提到「3 個 C 槽完整備份 .pbd（82 GB）」，**實際不存在**。

真相：
- `SOFTWARE_MISC` 裡面是**驅動程式備份**（.dbb、.dbx 格式），不是系統映像
- 真正的 C 槽系統備份是 `E:\易數一鍵還原Windows系统備份（不要删除）\`（67 GB，2026-04-18 最新），資料夾名稱標注不要刪，**不可動**

## 下次繼續的建議順序

1. 確認 Office 2021 是否還在用 → 決定 img 去留
2. 把 `VIDEOS_待確認/`（243 GB）整批移到外接硬碟或儲存槽
3. 刪除剩餘小項目（易数程式本體、FonePaw、舊腳本、空殼資料夾）
