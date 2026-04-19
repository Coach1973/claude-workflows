# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.

## What Goes Here

Things like:

- Camera names and locations
- SSH hosts and aliases
- Preferred voices for TTS
- Speaker/room names
- Device nicknames
- Anything environment-specific

## Examples

```markdown
### Cameras

- living-room → Main area, 180° wide angle
- front-door → Entrance, motion-triggered

### SSH

- home-server → 192.168.1.100, user: admin

### TTS

- Preferred voice: "Nova" (warm, slightly British)
- Default speaker: Kitchen HomePod
```

## Why Separate?

Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your notes, and share skills without leaking your infrastructure.

---

## VPS 系統資訊

- **IP**：43.245.60.200
- **SSH 標準指令**：`sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200`
- **重要**：OpenClaw 跑在 Docker 容器內，容器名稱為 `openclaw`

### VPS 指令正確格式

❌ 錯誤（會報 command not found）：
```bash
ssh root@43.245.60.200 "openclaw [指令]"
```

✅ 正確（透過 docker exec 進容器執行）：
```bash
sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200 \
  "docker exec openclaw openclaw [指令]"
```

### 常用 VPS 指令

**批准新用戶配對：**
```bash
sshpass -p '9kdxvQN2' ssh -o StrictHostKeyChecking=no root@43.245.60.200 \
  "docker exec openclaw openclaw pairing approve telegram [配對碼]"
```

Add whatever helps you do your job. This is your cheat sheet.

---

## 雲端儲存服務

### InfiniCloud（iStorage）
- **用途**：20GB 網路硬碟空間
- **申請網址**：https://infini-cloud.net/en/modules/mypage/usage/
- **帳號**：bymyway7
- **密碼**：bymwyay7
