# backup_memory.ps1
# Copies Claude memory + skills to E:\Claude-Data\ for safety
# Run anytime to update the backup

$memorySrc = "C:\Users\bymyw\.claude\projects\E--\memory"
$skillsSrc  = "C:\Users\bymyw\.claude\skills"
$memoryDst  = "E:\Claude-Data\memory-backup"
$skillsDst  = "E:\Claude-Data\skills-backup"

New-Item -ItemType Directory -Path $memoryDst -Force | Out-Null
New-Item -ItemType Directory -Path $skillsDst  -Force | Out-Null

Copy-Item -Path "$memorySrc\*" -Destination $memoryDst -Recurse -Force
Copy-Item -Path "$skillsSrc\*" -Destination $skillsDst  -Recurse -Force

$mCount = (Get-ChildItem $memoryDst -File).Count
$sCount = (Get-ChildItem $skillsDst -Recurse -File).Count

Write-Host "Memory backup: $mCount files -> $memoryDst"
Write-Host "Skills backup: $sCount files -> $skillsDst"
Write-Host "Done."
