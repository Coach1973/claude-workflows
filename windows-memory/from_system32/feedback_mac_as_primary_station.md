---
name: mac-windows
description: 2026-05-13 教練在 Mac 裝 CC Switch 後，軍師大腦主站改為 Mac，Windows 退居備援
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 0e798d57-0089-4091-a391-e887788d2a90
---

# Mac 為主站、Windows 為備援

**規則：**
從 2026-05-13 起，軍師大腦的**主工作站改為 Mac mini**（透過 CC Switch 跑 Opus）。
Windows 站退居**備援**，只在以下情況啟用：
1. Mac CC Switch 或中轉商不通
2. 寫特別長的獨立長文、想避免干擾同機的終端機
3. 教練明確指派

**Why:**
教練在 2026-05-13 把 CC Switch 同步裝上 Mac，配 EchoTokens 與 Synterolink。
這直接消滅了「Windows 軍師 ↔ Mac 終端機跨機搬運」的原始痛點——正是 [[project_command_center_archaeology_report]] 最強假設 A「relay 缺軍師位置」要解的問題。

**把問題消滅永遠比解問題便宜。**
新架構下軍師與終端機同在 Mac，切換視窗就能協作，教練不再當跨機搬運工。
詳見 [[MAC_MIGRATION_PLAN]]（位於 repo 根目錄）。

**Mac 端與 Windows 端的 CC Switch 行為差異（重要）：**
- **Windows**：Claude Code CLI 內切換中轉商**不需開新視窗**，切完直接續讀當前對話
- **Mac**：切換中轉商**必須開新視窗**才能生效，當前視窗無法續用
這個差異影響操作流程與應變時的視窗管理。

**How to apply:**

1. **日常工作入口**：教練的「軍師，...」呼叫，預設發向 Mac 端
2. **記憶繼承**：沿用 Windows 目錄的記憶為原始資料，Mac 端透過以下方式讀取（見 [[MAC_MIGRATION_PLAN]]）：
   - 核心身份進 Mac `~/.claude/CLAUDE.md`
   - 詳細記憶同步一份到 repo `shared-memory/`，軍師啟動時先 pull
3. **Windows 端的維護**：
   - 不再寫新主線記憶，避免與 Mac 端產生雙軌
   - 重大變動仍要同步一份回 Windows（保留備援資料完整）
   - 教練臨時在 Windows 開 Claude Code，軍師也能接工作，但須宣告「我現在是備援模式」
4. **同機防撞**：
   - Mac 上軍師（Opus）與終端機（Sonnet）共存，動檔前先 `git status`
   - 結合 [[feedback_sync_before_upload]]：上雲前先讀雲
5. **桌面版的位置不變**：繼續當軍師斷線的第三備援

**反例（不要這樣做）：**
- Mac 軍師寫了記憶只存 Mac 本地、不同步 repo → Windows 備援軍師讀不到
- Windows 和 Mac 兩邊軍師同時改同檔沒 pull → 覆蓋彼此
- 教練問 Windows 軍師「這件事做完了嗎？」而實際上是 Mac 軍師做的 → Windows 軍師沒讀雲就亂答
