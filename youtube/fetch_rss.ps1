$TELEGRAM_TOKEN = "8570992742:AAGR_swFNzjopUuaAkWYZa-h8U9oHn5jlZk"
$CHAT_ID = "6124913915"
$AI_KEYWORDS = @("AI","人工智能","ChatGPT","Claude","效率","自動化","automation","workflow","productivity","工作流","工具","tool","GPT","LLM","大模型")

$channels = @(
    @{h="@inspiredcanvas_m"; id="UC17zrOCuDUXmtREyx9G2tCQ"},
    @{h="@LuluTechnology1"; id="UCPwCUeMO9EB-kFno2zKsm9w"},
    @{h="@greentrainpodcast"; id="UCJhUtNsR5pvU_gWWkxxUXUQ"},
    @{h="@Teacher_Kong"; id="UCpnBpREMjMNFvLTLnc2iLPQ"},
    @{h="@applefans520"; id="UCCC_m0Lw7Z4IT6IjoPb0ZLg"},
    @{h="@kocpc"; id="UCcQA-MzQxCvET1S-BekQdAA"},
    @{h="@panscischool"; id="UCATnB3v_NkTTd9iD_4W2A-g"},
    @{h="@apple-dad"; id="UCt757ZhOr3vrvSxKT96b6vA"},
    @{h="@rickhau99"; id="UCKMtbQbyhpBgyKaNX5vJUsw"},
    @{h="@MeticsMediaChinese"; id="UC7Qp52WIwke2P3l1Xh6k74Q"},
    @{h="@AlanChen"; id="UCaIIFXfdQUYf3OHPIFNDdrQ"},
    @{h="@PH-WorkFlow"; id="UCpXOvRzWW0lJhYrUeWBlNmA"},
    @{h="@TuTu"; id="UCuhAUKCdKrjYoMiJQc74ZkQ"},
    @{h="@lichangzhanglaile"; id="UC0v9b0Z00wWED_vGy-Q6ibg"},
    @{h="@Macro_Alpha_cn"; id="UC9oosAco7nIVZwuGhnC0FKg"},
    @{h="@AIPractitioners123"; id="UCfMXQ45Ch5EnT2jokiHuysw"},
    @{h="@SFReality"; id="UCCzf5FvUaAurIuY-YGmWJyQ"},
    @{h="@mage291"; id="UCG_qhxmgI1E0wO4x11TiI5w"},
    @{h="@ami.moment"; id="UCGs_cktFPCgN8ggJJVon84g"},
    @{h="@TackyTechy"; id="UC3YHFDbkHcqVxg4w20YYC7A"},
    @{h="@martinz2025"; id="UC1HhvtQd_yTBJAGYNYffmSQ"},
    @{h="@BizofFame"; id="UCQT2N6N_Jay8nWS_0h7muyw"},
    @{h="@Petersunreview"; id="UCl9BPXjyEmA0q6IrQvsEazA"},
    @{h="@techbang3c"; id="UC9IyDJ6vlG50iYjXGQpwwOQ"},
    @{h="@aaron-1215"; id="UCKHHtxWYOg15Gsrsa9ZDfrA"},
    @{h="@talkspg"; id="UCUa8Meh6_eFq7v1h_CCa9fQ"},
    @{h="@AI-Short-Taipei"; id="UClrAAcpCv06f4Z7hXo7SXiw"},
    @{h="@digitalxu"; id="UCGQPLvp98hRrzTG14AiTfUQ"},
    @{h="@austinchou888"; id="UC3hsgc8SHJs1RDMEZBCAccA"},
    @{h="@HarryLee"; id="UCEA4ZfPzWDHp72mlq7IvUcw"},
    @{h="@sensebar"; id="UCI2YklLazU9tB_Kh_9nMpKA"}
)

$cutoff = (Get-Date).AddHours(-24)
$today = Get-Date -Format "yyyy/MM/dd"
$aiVideos = @()
$otherVideos = @()
$errorCount = 0

foreach ($ch in $channels) {
    $url = "https://www.youtube.com/feeds/videos.xml?channel_id=$($ch.id)"
    try {
        $response = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 10 -ErrorAction Stop
        [xml]$xml = $response.Content
        foreach ($entry in $xml.feed.entry) {
            $published = [DateTime]::Parse($entry.published)
            if ($published -gt $cutoff) {
                $title = $entry.title
                $videoId = $entry.id -replace "yt:video:",""
                $videoUrl = "https://www.youtube.com/watch?v=$videoId"
                $isAI = $false
                foreach ($kw in $AI_KEYWORDS) { if ($title -match $kw) { $isAI = $true; break } }
                $item = "• [$($ch.h)] $title`n  $videoUrl"
                if ($isAI) { $aiVideos += $item } else { $otherVideos += $item }
            }
        }
    } catch { $errorCount++ }
}

$totalNew = $aiVideos.Count + $otherVideos.Count
$msg = "YouTube $today`n`n"
if ($aiVideos.Count -gt 0) { $msg += "AI/`n" + ($aiVideos -join "`n") + "`n`n" }
if ($otherVideos.Count -gt 0) { $msg += "`n" + ($otherVideos -join "`n") + "`n`n" }
if ($totalNew -eq 0) { $msg += "0`n`n" }
$msg += "$($channels.Count) $totalNew AI $($aiVideos.Count)"
if ($errorCount -gt 0) { $msg += "`n $errorCount" }

function Send-Tg($text) {
    $body = @{chat_id=$CHAT_ID; text=$text} | ConvertTo-Json -Compress
    Invoke-RestMethod -Uri "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage" -Method POST -ContentType "application/json; charset=utf-8" -Body $body | Out-Null
}

Send-Tg $msg
Write-Host "Done: $totalNew new videos (AI: $($aiVideos.Count)), errors: $errorCount"