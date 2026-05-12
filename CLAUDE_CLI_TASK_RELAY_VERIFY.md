# CLAUDE_CLI_TASK_RELAY_VERIFY.md

> **建立**：2026-05-09 凌晨（軍師大腦交付）
> **執行者**：Mac mini 上的 Claude Code CLI（終端機）
> **目的**：驗證 relay 系統是否還活著（指揮所考古 B 階段第 1 步）
> **預估時間**：5 分鐘

---

## 為什麼要做這件事

5/6 之後 relay 沒有新測試紀錄。我們不知道現在跑不跑得起來。
這是「補缺」之前最該先確認的事——基礎活著，後面才有戲。

---

## 任務內容（請按順序執行，每步驟都把輸出貼回 terminal-notes）

### 第 1 步：檢查 cron 是否在跑

```bash
crontab -l | grep -i "relay\|openclaw" || echo "NO_CRON_FOUND"
```

通過條件：看到 relay_poll 相關行
未通過：cron 沒設，這就是 relay 沒持續運轉的根因

### 第 2 步：檢查 RELAY_QUEUE.json 最後修改時間

```bash
ls -la /Users/bymyway/.openclaw/workspace/shared-context/RELAY_QUEUE.json
```

紀錄 mtime，跟今天比一下差幾天。

### 第 3 步：檢查最近的 relay_output

```bash
ls -lat /Users/bymyway/.openclaw/workspace/terminal-notes/relay_output*.md | head -5
```

看最新一筆是哪天。

### 第 4 步：實際 ping 一次（最關鍵）

```bash
cd /Users/bymyway/.openclaw/workspace
./scripts/relay_claude_task.sh "請回覆：軍師 ping 通了"
```

等 30 秒後查 terminal-notes 看有沒有新輸出：

```bash
sleep 30
ls -lat /Users/bymyway/.openclaw/workspace/terminal-notes/relay_output*.md | head -3
tail -20 /Users/bymyway/.openclaw/workspace/terminal-notes/relay_output_$(date +%Y%m%d).md
```

通過條件：看到「軍師 ping 通了」的回應
未通過：relay 系統死了，需要重建

### 第 5 步：把結果回寫給軍師

把 1-4 步的輸出整理成一份 markdown，存到：

```
/Users/bymyway/.openclaw/workspace/terminal-notes/RELAY_HEALTH_CHECK_2026-05-09.md
```

格式：

```markdown
# Relay 健康檢查 — 2026-05-09

## 結論
[活著 / 半死不活 / 全死]

## 詳細
- cron：[結果]
- 佇列檔案 mtime：[結果]
- 最近 output：[結果]
- ping 測試：[結果]

## 軍師下一步建議
[如果活著 → 進入第 2 步補缺；如果死了 → 先重啟 cron]
```

完成後 commit + push，軍師會在 GitHub 上看到。

---

## 終端機注意事項

1. 全程不需要動 RELAY_QUEUE.json 的 schema、不要重寫 relay_poll.py
2. 如果發現 cron 沒跑，先不要自己加——回報軍師，等教練拍板
3. 中間任何一步壞了，停下來回報，不要硬幹

---

軍師大腦於 2026-05-09 凌晨交付
