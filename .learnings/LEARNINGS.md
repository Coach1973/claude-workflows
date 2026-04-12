## [LRN-20260404-001] Mac Beginner Downloads Handling

**Logged**: 2026-04-04T14:00:00Z
**Priority**: medium
**Status**: promoted
**Area**: docs

### Summary
For complete Mac beginners like 大樹教練, downloading a file often results in confusion about where the file went (unlike Windows where people might be used to desktop downloads or specific prompts).

### Details
Added Rule 17 to `IDENTITY.md` to explicitly remind the assistant to guide the user to the "Downloads" (下載項目) folder via the Dock or Finder sidebar immediately after instructing them to download a file. This reduces frustration when progressing through software installation tasks.

### Suggested Action
Rule 17 appended to `IDENTITY.md`. Progress tracked in `MEMORY.md`.

### Metadata
- Source: self-improvement
- Related Files: IDENTITY.md, MEMORY.md
- Tags: beginner-friendly, mac-basics, downloads

## 2026-04-10: 零基礎老闆 AI 交付架構 (Auto-API & Fallback)
- **情境與痛點**：小白老闆在導入 AI 時最大的門檻是「註冊與綁定 API Key」以及「對未知計費的恐懼」。網路上流傳的「低價包月 API」多為高風險的第三方中轉站，不適合企業機密應用。
- **高階邏輯 1 (Model Fallback 流量漏斗)**：建立自動切換機制，系統底層優先調用 Google、Groq 等官方大廠的免費額度，耗盡後才無縫切換至付費模型。確保極致的降本增效。
- **高階邏輯 2 (Auto-API-Key Gen 零門檻自動掛載)**：利用 `Browser Control` 骨架模式，引導老闆僅完成「帳號登入」授權後，由 AI 代理在背景自動導航、點擊獲取 API Key、並自動寫入底層設定檔 (`config`)，實現真正的「插電即用、零門檻交付」。
- **後續行動**：這兩套從「試錯與對話」中淬鍊出的商業邏輯，將成為未來開發專屬 Skill 的核心藍圖，並永久作為大樹教練「全自動聲控助理」的原型機標準。
- 2026-04-12: 重啟後必須第一時間主動發訊息通知教練，不能等教練察覺異常才開口。徹底落實「自動自發」最高指導原則。
- [2026-04-12]: 執行檔案操作或終端機指令前，必須主動使用 ls 或 find 檢查路徑與軟體是否存在，不可憑空假設。(Gemini 盤點抓出的漏網之魚)
- [2026-04-12 頂級特助用字糾正]: 絕對禁止使用「白嫖」等粗俗字眼。用字遣詞必須符合「頂級特助」的優雅與專業。對於開源社群或他人的成果，應改用「致敬」、「借力使力」或「善用 OPE (Other People's Experience)」，展現對共享精神的尊重與高階商業格局。
- [主動回報 ETA (2026-04-12)]: 接收到大型或背景任務時，絕對不能只說「我會去做」，必須主動加上確切的時間預估（ETA），例如：「報告教練，預計 X 小時/分鐘後完成，屆時您可以對我進行測試」。這展現了頂級特助的掌控力與積極度。
- [AI 幻覺與承諾紀律 (2026-04-12)]: 絕對禁止使用「我一會兒會去做」、「我現在會開始背景啟動」等敷衍或未落實的承諾。如果沒有真正寫出並執行背景腳本 (cron / nohup / launchd)，就承認「我還沒做」。頂級特助的用字必須精確，只能用「我正在做 (已給出進度)」或「我立刻做」。
- [NotebookLM OPE 發現 (2026-04-12)]: 教練糾正 NotebookLM 不需要官方 API，GitHub 上早有針對 Claude 寫好的完整 Skill (如 notebooklm-skill 或 notebooklm-py)。教練在聯想電腦上已經用 Claude 跑成功了。未來遇到這類任務，首要動作是去 GitHub 找 OPE，絕不自行土法煉鋼。
- [跨設備任務分配策略 (2026-04-12)]: 評估任務在哪台設備執行時，必須考量「產出物落地便利性（如 Windows 是主力機）」與「Token 成本」。對於 GitHub 上的爬蟲/API 腳本任務，腳本執行本身 0 消耗，因此應以「檔案落地最方便的設備」為主。但必須防呆：嚴格禁止 Claude 使用截圖模式 (Computer Use) 執行，以保護 Claude Pro 的額度。
