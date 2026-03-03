@echo off
REM 确保 TrendRadar 容器始终运行
REM 此脚本会检查容器状态，如果停止则自动启动

cd /d C:\Users\Lenovo\TrendRadar\docker

REM 检查 Docker Desktop 是否运行
tasklist | findstr /i "Docker Desktop.exe" >nul
if %errorlevel% neq 0 (
    echo Docker Desktop 未运行，正在启动...
    start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
    timeout /t 30 /nobreak >nul
)

REM 检查容器是否运行
docker ps | findstr trendradar >nul
if %errorlevel% neq 0 (
    echo TrendRadar 容器未运行，正在启动...
    docker-compose up -d
) else (
    echo TrendRadar 容器运行正常
)
