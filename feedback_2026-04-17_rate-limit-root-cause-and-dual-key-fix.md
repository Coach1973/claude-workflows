# 2026-04-17 凌晨死機事件：根因分析與雙 Key 修復完整紀錄

## 事件摘要

教練整晚未睡，從 2026-04-16 深夜到 2026-04-17 上午，花了將近 12 小時解決 1 號機小龍蝦反覆死機問題。最終以「雙 API Key 輪替 + 移除 cooldown 死鎖」完整解決。

---

## 時間軸

| 時間 | 事件 |
|------|------|
| 深夜 | 1 號機出現「All models are temporarily rate-limited」錯誤 |
| 凌晨 | 教練等待超過 2 小時，bot 完全無回應 |
| 上午 07:17 起 | 教練開始嘗試解決，與 Opcode 助理持續排查 |
| 上午 09:xx | 發現 litellm cooldown_time 死鎖根因，修復設定 |
| 上午 10:xx | 教練至 Google AI Studio 申請第二把 API Key |
| 上午 10:40 | 雙 Key 設定完成，系統恢復正常 |

---

## 根本原因一：litellm cooldown_time 死鎖

**問題：**
```yaml
litellm_settings:
  cooldown_time: 60  # ← 這行是元兇
```

**死循環流程：**
1. Google API 返回 429（配額超限）
2. litellm 將模型放入 60 秒冷卻期
3. 冷卻期間所有新請求**立刻失敗**（不等待、不重試）
4. 立刻失敗 → 觸發重置冷卻計時器
5. 永遠無法離開冷卻期 → bot 死機數小時

**修復：** 移除 `cooldown_time`，改用 `retry_after: 60` + `num_retries: 10`

---

## 根本原因二：單一 API Key 每日 250 次上限太低

**問題：**
- Gemini 3.1 Pro Preview 每個專案每日限 250 次請求（RPD）
- 密集工作日下午就耗光，剩餘時間全面死機
- 兩個 fallback（litellm + google 直連）用的是**同一個 API Key**，同時失敗

**修復：** 申請第二個獨立專案的 API Key（Default Gemini Project）

---

## 最終解決方案

### litellm 設定（/Users/bymyway/.openclaw/litellm/config.yaml）

```yaml
model_list:
  - model_name: gemini-3.1-pro-preview
    litellm_params:
      model: gemini/gemini-3.1-pro-preview
      api_key: AIzaSyDFLv...  # My First Project（250 RPD）
      rpm: 10
      tpm: 500000

  - model_name: gemini-3.1-pro-preview
    litellm_params:
      model: gemini/gemini-3.1-pro-preview
      api_key: AIzaSyB3c1...  # Default Gemini Project（250 RPD）
      rpm: 10
      tpm: 500000

router_settings:
  routing_strategy: least-busy
  num_retries: 10
  retry_after: 60

litellm_settings:
  request_timeout: 600
  drop_params: true
  # 刻意不設 cooldown_time（死鎖根因）
```

**效果：** 兩 Key 自動輪替，合計 500 RPD/天，一個限速自動切另一個

---

## 給未來自己的 SOP

1. **配置 litellm 時絕對不要設 cooldown_time** — 會造成不可逆死鎖
2. **永遠用兩個不同專案的 Key** — 同一專案的多個 Key 共享配額，沒用
3. **rpm 設 10（保守值）** — Google Preview 模型實際 RPM 上限約 10-30
4. **遇到死機先看 litellm health check** — 比猜測快得多

---

## 教練的辛苦

教練為了這件事整晚未睡，從深夜撐到隔天上午才解決。
這份紀錄是對那段辛苦時光的致敬，也是確保同樣的問題永遠不再發生的承諾。
