---
name: VPS 小龍蝦（OpenClaw）技術架構
description: VPS 版 OpenClaw 的 IP、容器、路徑、port 與 memsearch 索引修復公式
type: reference
originSessionId: e3f4beeb-3f1c-4f5f-b1b3-597e7737bce4
---
VPS 上有一份獨立的 OpenClaw 實例，與 Mac mini 主機並存。

## 連線
- IP：43.245.60.200
- SSH：以 root 登入；容器內操作需 `docker exec -u node openclaw`
- 密碼：不存於此（教練分享時請當場使用，不要寫入任何 commit 或記憶）

## 容器架構
- 容器名稱：openclaw
- 容器內用戶：node
- workspace：`/home/node/.openclaw/workspace`
- uvx 路徑：`/home/node/.local/bin/uvx`（裝在 node 用戶下，root 找不到）
- Gateway port：18789

## memsearch 索引
- 集合命名公式：`bash derive-collection.sh <workspace>` → 例如 `/home/node/.openclaw/workspace` 推出 `ms_workspace_cddce8bd`
- 重建索引指令：
  ```
  uvx --from 'memsearch[onnx]' memsearch index --provider onnx \
    --collection ms_workspace_cddce8bd \
    /home/node/.openclaw/workspace/.memsearch/memory/
  ```
- 驗證指令：`uvx --from 'memsearch[onnx]' memsearch stats --collection <name>`
- 易踩坑：有 .md 檔案 ≠ 搜尋有效，要看 Milvus 向量索引是否真的建好

## 心得記錄位置
- repo：Coach1973/mac-openclaw-workflows
- 檔案：`terminal-notes/TERMINAL_LEARNINGS.md`
- 最近一次相關 commit：6d205f87（2026-05-08 VPS memsearch 索引修復）
