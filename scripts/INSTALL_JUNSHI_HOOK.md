# 軍師接力棒強制餵食 Hook — 安裝說明

## 這個 Hook 解決什麼問題

過去 24 小時（5/15-5/16）教練在 6 個 session 裡被迫重教軍師「你是誰」共 50+ 次，
原因是新 session 沒主動讀 `JUNSHI_HANDOFF_LATEST.md`。

**這個 Hook 把「靠軍師自律」改成「靠機制強制」**：
- Claude Code 每次收到使用者訊息前自動跑 Hook
- 若訊息含暗號（開工 / 軍師 / 接續指揮所考古 / Claude 軍師），
  自動把接力棒+最新一場 session 總結餵進 context
- 每場 session 只餵一次（marker 檔防重複），不會炸 token

---

## 安裝步驟（新機器 / 還原時用）

### 1. 確認腳本在 workspace 內

```
/Users/bymyway/.openclaw/workspace/scripts/feed_junshi_handoff.sh
```

執行權限：`chmod +x` 必須有。

### 2. 在 `~/.claude/settings.json` 加 hooks 區塊

用 `jq` 安全 patch（不要手動 edit 整檔，避免破壞 env / permissions）：

```bash
cp ~/.claude/settings.json ~/.claude/settings.json.bak
/usr/bin/jq '. + {hooks: {UserPromptSubmit: [{type: "command", command: "/Users/bymyway/.openclaw/workspace/scripts/feed_junshi_handoff.sh"}]}}' \
  ~/.claude/settings.json.bak > ~/.claude/settings.json
```

### 3. 驗收（教練拍板的方法）

開新 Claude Code session（新視窗），只輸入「開工」，軍師回應第一句必須包含：
- 「我已讀完接力棒」字樣
- 當下主軸名稱
- 身份核對（模型版本）
- 雲端同步狀態（commit hash）

---

## 內部邏輯

| 條件 | 行為 |
|------|------|
| Prompt 含觸發詞 + marker 不存在 | 注入接力棒+最新 session 總結，建 marker |
| Prompt 含觸發詞 + marker 已存在 | 靜默退出（同 session 不重複餵）|
| Prompt 不含觸發詞 | 完全不動作 |

Marker 位置：`/tmp/junshi_fed_<session_id>`

重啟 Mac 後 `/tmp` 清空 → marker 也清掉 → 下次喊「開工」會重新餵。
這是設計上的「軟自動更新」。

---

## 維護

- 改觸發詞：編輯腳本內 `grep -qE "..."` 的 regex
- 改注入內容：編輯腳本內 `echo` 與 `cat` 區塊
- 撤銷 hook：`jq 'del(.hooks)'` 反向 patch settings.json

---

## 歷史

- 2026-05-16 05:41 教練拍板：「停止無限重教、開始建造強制系統」
- 2026-05-16 11:00 軍師（Claude Code CLI Opus 4.7）完成第一招 hook
