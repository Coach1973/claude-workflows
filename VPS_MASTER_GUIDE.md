# VPS_MASTER_GUIDE.md — 終端機一讀就能上手的 VPS 完全指南

> 整合來源：VPS_DEPLOYMENT_PROTOCOL / VPS_CAPABILITY_VERIFICATION / LEARNINGS_VPS_CAPABILITY / HANDOFF_VPS_Knowledge_Sync
> 最後更新：2026-05-01

---

## 一、SSH 連線方式

```bash
# 直接 SSH 進 VPS（需先安裝 sshpass：brew install sshpass）
sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200

# 執行 VPS Docker 容器內的 OpenClaw 指令（不進入互動 Shell）
sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200 \
  "docker exec openclaw openclaw [指令]"

# 直接執行 Docker 容器內的 bash 指令
sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200 \
  "docker exec openclaw bash -c '[bash指令]'"
```

| 項目 | 值 |
|------|-----|
| VPS IP | 43.245.60.200 |
| SSH 用戶 | root |
| SSH 密碼 | 9kdxvQN2 |
| Docker 容器名稱 | openclaw |
| OpenClaw 執行方式 | Docker 容器 |

---

## 二、VPS 架構定位

```
大樹教練私有大腦（Mac mini）
├── 吸收每日流水帳、大量日誌
├── 提煉濃縮成 SOP 與守則
└── 保留：memory/、IDENTITY.md、feedback_*.md

VPS 體驗版（對外開放）
├── 角色：第一線公關/客服
├── 只保留：SOUL.md（公版）、USER.md（公版）
└── 禁止：memory/、IDENTITY.md、教練私密設定
```

**VPS 的小龍蝦能力邊界（鐵律）：**
- ✅ 文字對話、商業建議、海餅乾守則
- ❌ 無法操作用戶的本機電腦
- ❌ 無語音糾偏（那是大樹教練專屬的 Mac 功能）
- ❌ 無 session_status Token 成本回報

---

## 三、VPS 常用指令速查

```bash
# 查看 Docker 容器狀態
sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200 \
  "docker ps | grep openclaw"

# 重啟 Gateway
sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200 \
  "docker exec openclaw openclaw gateway restart"

# 查看 VPS workspace 檔案列表
sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200 \
  "docker exec openclaw ls /home/node/.openclaw/workspace/"

# 從 Mac 傳檔案到 VPS（scp）
sshpass -p '9kdxvQN2' scp -o StrictHostKeyChecking=no \
  /Users/bymyway/.openclaw/workspace/SOUL.md \
  root@43.245.60.200:/tmp/
# 再複製進容器
sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200 \
  "docker cp /tmp/SOUL.md openclaw:/home/node/.openclaw/workspace/SOUL.md"

# 查看 VPS openclaw.json
sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200 \
  "docker exec openclaw cat /home/node/.openclaw/openclaw.json"
```

---

## 四、VPS 上目前已完成的工作（歷史記錄）

| 時間 | 工作內容 | 結果 |
|------|----------|------|
| 2026-04-18 | VPS 記憶庫清洗——刪除 memory/、IDENTITY.md、feedback_*.md | ✅ 完成 |
| 2026-04-18 | 確立內外網隔離架構（Mac=私有大腦，VPS=公版體驗）| ✅ 架構定案 |
| 2026-04-19 | 記錄 VPS 能力邊界（無 exec、無 session_status、無語音糾偏）| ✅ 寫入 LEARNINGS |
| 2026-04-22 | 調查 TTS 與圖片生成功能（VPS 上 messages.tts 區塊不存在）| ⚠️ 待開啟 |
| 2026-04-22 | 建立知識同步機制（seabiscuit_case_studies.md 已建）| ✅ 完成 |
| 2026-04-22 | 多用戶長期記憶隔離架構規格設計（VPS_Memory_Architecture_Spec.md）| 📋 設計完，待實裝 |
| 2026-05-01 | 小龍蝦大腦重整（SOUL.md 精簡、CORE_RULES v2.3）| ✅ Mac 端完成，VPS 端待同步 |

---

## 五、VPS 待辦事項（下次接手必看）

- [ ] **同步最新 SOUL.md 到 VPS**（今日 Mac 端已更新，VPS 尚未同步）
- [ ] **開啟 VPS TTS 功能**：在 VPS openclaw.json 加入 `messages.tts.enabled: true` 並重啟 gateway
- [ ] **圖片生成功能**：確認 VPS 的 auth-profiles.json 有無 minimax-portal 設定
- [ ] **多用戶隔離架構**（VPS_Memory_Architecture_Spec.md 規格）待實裝

---

## 六、VPS 知識同步指令（Mac → VPS）

```bash
# 腳本位置
~/.openclaw/workspace/scripts/vps_memory_sync.sh

# 手動同步 SOUL.md（公版）到 VPS
sshpass -p '9kdxvQN2' scp -o StrictHostKeyChecking=no \
  /Users/bymyway/.openclaw/workspace/SOUL.md \
  root@43.245.60.200:/tmp/ && \
sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200 \
  "docker cp /tmp/SOUL.md openclaw:/home/node/.openclaw/workspace/SOUL.md"
```
