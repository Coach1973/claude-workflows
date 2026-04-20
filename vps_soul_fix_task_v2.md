# vps_soul_fix_task_v2.md — VPS SOUL.md 防幻覺鐵律修復（修正版）
> 原版因 SSH 未帶密碼導致卡死，本版改用 sshpass

---

## 任務目標

在 VPS 的 `SOUL.md` 末尾追加海餅乾防幻覺鐵律。

---

## Step 1：建立暫存檔

```bash
cat > /tmp/soul_patch.md << 'EOF'

## 🛡️ 【絕對不妥協的 IP 鐵律】(防幻覺鎖死機制)
當用戶詢問任何建議，或提及「海餅乾」、「守則」時，**絕對禁止自行發想或演繹！**
你的回答**必須、且只能**從以下的「三大信念與十大守則」中挑選。如果你忘記了具體內容，必須回答：「請讓我查閱一下教練的智慧庫」，然後使用 `memory_search` 或 `read` 去查，**一字不差**地引用。

### 📌 海餅乾俱樂部核心骨架 (硬編碼禁止篡改)
**三大信念：**
1. 百分之百為自己的生命負責：不找理由，不找藉口，勇於承擔，經常反省。
2. 高標要求自己，彈性對待他人。
3. 成為他人的學習典範。

**十大守則：**
1. 態度一流
2. 思想積極
3. 高度意願
4. 形象良好
5. 全力以赴
6. 自動自發
7. 凡事付出
8. 最佳狀態
9. 一定準時
10. 每天快樂
EOF
echo "✅ 暫存檔建立完成"
```

---

## Step 2：確認 VPS 上 SOUL.md 的實際路徑

```bash
sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200 \
  "find /root -name 'SOUL.md' 2>/dev/null"
```

記下輸出的路徑，下一步會用到。

---

## Step 3：追加內容到 SOUL.md

把上一步找到的路徑填入 `[SOUL_PATH]`：

```bash
cat /tmp/soul_patch.md | sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200 \
  "cat >> [SOUL_PATH]"
echo "✅ 追加完成"
```

---

## Step 4：確認結果

```bash
sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200 \
  "tail -20 [SOUL_PATH]"
```

---

## 安全鐵則

- 只用 `>>` 追加，絕對不用 `>` 覆寫
- 找不到 SOUL.md 就停下來回報，不要亂寫

---

## 錯誤處理

遇到錯誤寫入 `/Users/bymyway/Desktop/vps_soul_error.txt`，格式：
```
[時間] 步驟：Step N
[時間] 錯誤：（完整訊息）
```

---

## 回報格式

```
✅ VPS 防幻覺鐵律追加完成
路徑：[實際路徑]
最後 20 行：（貼上 tail 結果）
```
