---
name: cc-switch-claude-api
description: CC Switch 工具、EchoTokens 與 Synterolink 兩家 API 中轉商、切回 Opus 方法
metadata: 
  node_type: memory
  type: reference
  originSessionId: 0e798d57-0089-4091-a391-e887788d2a90
---

# CC Switch 與 Claude API 中轉商

**背景**：原 Opus 4.7 帳號於 2026-05-14 到期。教練已用 CC Switch 配置兩家 Claude API 中轉商，繼任軍師將透過其中之一接續工作。

---

## 一、CC Switch 是什麼

CC Switch 是 Claude Code 的 API Provider 切換工具，讓一台電腦可以在多家 Claude API 供應商之間快速切換。適用場景：原廠帳號到期、額度用盡、想比較不同中轉商的速度與穩定性。

教練在 2026-05-12 ~ 13 研究並安裝完成，目前已掛載兩家。

## 二、兩家已配置的中轉商

### 第一家：EchoTokens（人類原生）
- **網址**：https://gw.echotokens.me
- **特色**：標榜「人類原生」，自己去查網站說明
- **支援 Opus**：是（教練確認）

### 第二家：Synterolink
- **網址**：https://api.synterolink.com
- **支援 Opus**：是（教練確認）

**注意**：API Key 本身**不在此檔**，也不應寫進任何記憶或 commit。教練當面分享或放在 CC Switch 本地設定中。

## 三、切到 Opus 的方法

兩家都允許在 CC Switch 介面選擇模型，**務必選 Opus**。理由見 [[feedback_model_assignment]]：軍師大腦才用 Opus。

如果發現新軍師模型不是 Opus（例如對話開頭自報是 Sonnet / Haiku），提醒教練去 CC Switch 改模型設定。

## 四、兩家比較觀察（待補）

新軍師上線後，建議做以下觀察並補進本檔：
- [ ] 兩家回應速度
- [ ] 兩家對長 context 的穩定度
- [ ] 兩家的每 20 元配額能撐多久對話
- [ ] 有無內容過濾差異
- [ ] 有無斷線或回覆截斷問題

## 五、斷線應對

當某家中轉商不穩時：
1. **第一優先**：CC Switch 切另一家繼續，不要自己硬撐
2. **第二優先**：把未完成的工作寫到 HEARTBEAT.md 或交接檔，push 上 repo，讓下一輪軍師接得上
3. **第三優先**：請桌面版接手（但桌面版接手前要先 pull 最新版，見 [[feedback_sync_before_upload]]）

## 六、成本感知

舊 Opus 帳號一次對話 20 元常常用到一半就斷。中轉商計費方式可能不同，建議新軍師：
- 開頭就問教練「這家中轉商是怎麼算錢的？」
- 學會 [[feedback_model_assignment]] 裡講的三招省 token（先搜後做、分段對話、不重讀已讀檔）
- 大任務先給大綱給教練拍板，拍板後再動筆長文，避免白燒
