@echo off
REM TrendRadar 监控脚本 (Windows 版本)
REM 检查最后运行时间，超过 2 小时则重启

echo ==========================================
echo TrendRadar 监控检查
echo 检查时间: %date% %time%
echo ==========================================

REM 获取最后一条日志
for /f "tokens=*" %%i in ('docker logs trendradar --tail 1 --timestamps 2^>^&1') do set LAST_LOG=%%i

echo 最后日志: %LAST_LOG%

REM 检查日志是否包含今天的日期
echo %LAST_LOG% | findstr /C:"%date:~0,10%" >nul
if %errorlevel% equ 0 (
    echo ✅ 运行正常
) else (
    echo ❌ 可能已停止，正在重启容器...
    cd /d C:\Users\Lenovo\TrendRadar\docker
    docker-compose restart trendradar
    echo ✅ 容器已重启
)

echo ==========================================
