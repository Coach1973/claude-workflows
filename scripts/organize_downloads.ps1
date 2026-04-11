# organize_downloads.ps1 - Updated 2026-04-11
# Rules: ZOOM/全國分享會/BNI/文書檔/資料收集/近期PDF文件/媒體檔案
# Note: uses Unicode codepoints for Chinese folder names to avoid encoding issues

$dl = "D:\Users\Downloads"

# Chinese folder names via Unicode codepoints (avoids PS encoding issues)
$dirZOOM   = "ZOOM"
$dirBNI    = "BNI"
$dirKokkai = [char]0x5168 + [char]0x570B + [char]0x5206 + [char]0x4EAB + [char]0x6703  # 全國分享會
$dirBunsei = [char]0x6587 + [char]0x66F8 + [char]0x6A94                                  # 文書檔
$dirShiryo = [char]0x8CC7 + [char]0x6599 + [char]0x6536 + [char]0x96C6                   # 資料收集
$dirPDF    = [char]0x8FD1 + [char]0x671F + "PDF" + [char]0x6587 + [char]0x4EF6           # 近期PDF文件
$dirMedia  = [char]0x5A92 + [char]0x9AD4 + [char]0x6A94 + [char]0x6848                   # 媒體檔案

foreach ($d in @($dirZOOM, $dirKokkai, $dirBNI, $dirBunsei, $dirShiryo, $dirPDF, $dirMedia)) {
    New-Item -ItemType Directory -Path "$dl\$d" -Force | Out-Null
}

$bniKw = "BNI|" + [char]0x7D05 + [char]0x7DA0 + [char]0x71C8 + "|" + [char]0x4FE1 + [char]0x7528 + [char]0x8B49 + "|Traffic Light|GROW|Blueprint"

$moved  = [System.Collections.ArrayList]@()
$failed = [System.Collections.ArrayList]@()

Get-ChildItem $dl -File | ForEach-Object {
    $f = $_
    $n = $f.Name
    $e = $f.Extension.ToLower()
    $dest = $null

    # export*.jpg/png - keep in place (smart notebook images)
    if ($n -match "^export") { return }

    # ZOOM recordings
    if ($n -match "^GMT2026") { $dest = $dirZOOM }
    # 全國分享會: timestamp 20260409_174056
    elseif ($n -match "^2026\d{4}_\d{6}" -and $e -in @(".mp4",".aac",".mp3",".m4a")) { $dest = $dirKokkai }
    # BNI PDF
    elseif ($e -eq ".pdf" -and $n -match $bniKw) { $dest = $dirBNI }
    # BNI Excel
    elseif ($e -in @(".xlsx",".xls")) { $dest = $dirBNI }
    # Audio/Video
    elseif ($e -in @(".mp3",".aac",".m4a",".mp4",".wav",".flac",".wma",".webm",".ogg")) { $dest = $dirMedia }
    # Images
    elseif ($e -in @(".jpg",".jpeg",".png",".webp",".gif",".bmp")) { $dest = $dirShiryo }
    # PPT + Word + TXT
    elseif ($e -in @(".pptx",".ppt",".doc",".docx",".txt")) { $dest = $dirBunsei }
    # Other PDFs
    elseif ($e -eq ".pdf") { $dest = $dirPDF }

    if ($dest) {
        try {
            Move-Item $f.FullName "$dl\$dest\" -Force -ErrorAction Stop
            [void]$moved.Add("$dest <- $n")
        } catch {
            [void]$failed.Add("FAIL $n : $($_.Exception.Message)")
        }
    }
}

Write-Host "=== Done: $($moved.Count) moved, $($failed.Count) failed ==="
if ($failed.Count -gt 0) {
    Write-Host "--- Failed ---"
    $failed | ForEach-Object { Write-Host $_ }
}
Write-Host ""
Write-Host "=== Remaining (kept/unmatched) ==="
Get-ChildItem $dl -File | Select-Object -ExpandProperty Name | ForEach-Object { Write-Host $_ }
