#!/bin/bash
# 共享智慧同步腳本
# 用途：把 1 號機最新的共享檔案推給 2、3 號機
# 執行：bash ~/.openclaw/workspace/scripts/sync-shared-wisdom.sh

S="/Users/bymyway/.openclaw/workspace"
P2="/Users/bymyway/.openclaw-peipei/workspace"
P3="/Users/bymyway/.openclaw-kong/workspace"

echo "=== 同步共享智慧檔案 $(date '+%Y-%m-%d %H:%M') ==="

# 靈魂與代理手冊
CORE=(
  "SOUL.md"
  "AGENTS.md"
  "WISDOM_CORES.md"
  "GRAND_MISSION.md"
  "CLIENT_PROFILE.md"
  "SHARED_GROUP_MEMORY.md"
  "TOOLS.md"
  "sea_biscuit_club.md"
  "seabiscuit_case_studies.md"
  "教練碎碎念.md"
  "project_top_assistant_blueprint.md"
)

for f in "${CORE[@]}"; do
  if [ -f "$S/$f" ]; then
    cp "$S/$f" "$P2/$f" && cp "$S/$f" "$P3/$f" && echo "✅ $f"
  else
    echo "⚠️  不存在：$f"
  fi
done

# 所有 feedback 工作守則
for f in "$S"/feedback_*.md; do
  fname=$(basename "$f")
  cp "$f" "$P2/$fname" && cp "$f" "$P3/$fname" && echo "✅ $fname"
done

echo ""
echo "同步完成。2 號機（佩佩）與 3 號機（孔大哥）已更新。"
