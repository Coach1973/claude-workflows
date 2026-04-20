# fix_litellm_second_key_task.md — 啟用第二條 Gemini API 線路

## 問題說明
LiteLLM 設定檔中，第二條 Gemini API Key 被 `#` 注釋掉了，導致兩條線路實際上只用同一個 Key，額度用完就全趴。

## Step 1：備份現有設定
```bash
cp /Users/bymyway/.openclaw/litellm/config.yaml \
   /Users/bymyway/.openclaw/litellm/config.yaml.bak.$(date +%Y%m%d%H%M)
echo "✅ 備份完成"
```

## Step 2：取消注釋第二條 Key

```bash
python3 << 'EOF'
content = open('/Users/bymyway/.openclaw/litellm/config.yaml').read()

old = """#  - model_name: gemini-3.1-pro-preview
#    litellm_params:
#      model: gemini/gemini-3.1-pro-preview
#      api_key: AIzaSyB3c1Bie3VdaKHddH2S2JH58T1VIghwWV0  # Default Gemini Project (Paused)
#      rpm: 10
#      tpm: 500000"""

new = """  - model_name: gemini-3.1-pro-preview
    litellm_params:
      model: gemini/gemini-3.1-pro-preview
      api_key: AIzaSyB3c1Bie3VdaKHddH2S2JH58T1VIghwWV0  # Default Gemini Project (已啟用)
      rpm: 10
      tpm: 500000"""

if old in content:
    open('/Users/bymyway/.openclaw/litellm/config.yaml', 'w').write(content.replace(old, new))
    print("✅ 第二條 Key 已啟用")
else:
    print("❌ 找不到目標段落，請人工檢查")
EOF
```

## Step 3：確認修改結果
```bash
grep -A5 "AIzaSyB3c1" /Users/bymyway/.openclaw/litellm/config.yaml
```
確認該段落前面沒有 `#` 號。

## Step 4：重啟 LiteLLM Proxy
```bash
pkill -f "litellm" && sleep 3
cd /Users/bymyway/.openclaw && \
  nohup litellm --config litellm/config.yaml --port 4100 > /tmp/litellm.log 2>&1 &
sleep 5 && curl -s http://localhost:4100/health | python3 -m json.tool 2>/dev/null || echo "請確認 LiteLLM 是否正常啟動"
```

## 錯誤處理
遇到錯誤寫入 `/Users/bymyway/Desktop/litellm_fix_error.txt`，自己診斷修正。

## 回報格式
```
✅ 第二條 Gemini Key 已啟用

- 備份：✅
- config.yaml 修改：✅
- LiteLLM 重啟：✅
- Health check：（貼上結果）

現在兩條線路都在運作，每條各 250 次/天，合計 500 次。
```
