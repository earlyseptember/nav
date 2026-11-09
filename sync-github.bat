@echo off
setlocal enabledelayedexpansion
title GitHub 一键同步
cd /d "D:\nav"

echo ==========================================
echo    GitHub 一键同步  (仓库: earlyseptember/nav)
echo ==========================================
echo.

echo [1/3] 拉取远程最新代码...
set n=0
:pull_retry
git pull origin main
if not errorlevel 1 goto pull_ok
set /a n+=1
if !n! LSS 6 (
    echo       连接失败 (!n!/5)，5 秒后自动重试...
    timeout /t 5 /nobreak >nul
    goto pull_retry
)
echo [失败] 拉取失败，网络不稳定，请稍后再试。
goto end

:pull_ok
echo       拉取完成。
echo.

echo [2/3] 提交本地改动...
git add .
git commit -m "sync update" >nul 2>&1
echo       完成 (若无改动提示 nothing to commit 属正常)
echo.

echo [3/3] 推送到 GitHub...
set n=0
:push_retry
git push origin main
if not errorlevel 1 goto push_ok
set /a n+=1
if !n! LSS 6 (
    echo       连接失败 (!n!/5)，5 秒后自动重试...
    timeout /t 5 /nobreak >nul
    goto push_retry
)
echo [失败] 推送失败。首次推送需在弹出的浏览器登录 GitHub。
goto end

:push_ok
echo       推送完成。
echo.
echo ==========================================
echo   同步完成!
echo ==========================================

:end
echo.
pause
endlocal
