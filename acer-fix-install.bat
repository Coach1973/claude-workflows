@echo off
chcp 65001 >nul
echo =============================================
echo  OpenClaw Acer 宏碁 修復安裝腳本
echo  Kimi K2.5 輕量版 AGENTS.md 安裝器
echo =============================================
echo.

set WORKSPACE=C:\Users\Administrator\.openclaw\workspace
set REPO=%USERPROFILE%\Documents\mac-openclaw-workflows

:: 步驟 1：確認工作區存在
echo [1/4] 確認工作區路徑...
if not exist "%WORKSPACE%" (
    echo 建立工作區資料夾...
    mkdir "%WORKSPACE%"
)
echo     OK: %WORKSPACE%
echo.

:: 步驟 2：更新 Git 倉庫
echo [2/4] 同步 GitHub 最新記憶...
if exist "%REPO%\.git" (
    cd /d "%REPO%"
    git pull origin main
) else (
    git clone https://github.com/Coach1973/mac-openclaw-workflows "%REPO%"
    cd /d "%REPO%"
)
echo.

:: 步驟 3：備份舊的 AGENTS.md
echo [3/4] 備份原始 AGENTS.md...
if exist "%WORKSPACE%\AGENTS.md" (
    copy "%WORKSPACE%\AGENTS.md" "%WORKSPACE%\AGENTS.md.bak" >nul
    echo     已備份為 AGENTS.md.bak
) else (
    echo     （原本沒有 AGENTS.md，跳過備份）
)
echo.

:: 步驟 4：安裝輕量版 AGENTS.md
echo [4/4] 安裝 Kimi 輕量版 AGENTS.md...
copy /Y "%REPO%\AGENTS_KIMI_LITE.md" "%WORKSPACE%\AGENTS.md" >nul
echo     OK：已覆蓋 AGENTS.md
echo.

:: 同步所有 .md 記憶檔到工作區
echo [額外] 同步所有記憶 .md 檔案...
for %%f in ("%REPO%\*.md") do (
    copy /Y "%%f" "%WORKSPACE%\" >nul
)
echo     OK：記憶檔同步完成
echo.

echo =============================================
echo  安裝完成！
echo  現在重新啟動 OpenClaw Gateway 即可。
echo  K2.5 不會再因為上下文過大而當機。
echo =============================================
echo.
pause
