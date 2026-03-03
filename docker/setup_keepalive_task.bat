@echo off
REM 创建 Windows 定时任务：每小时检查并确保 TrendRadar 运行
REM 需要管理员权限

echo ==========================================
echo TrendRadar 自动保活任务创建工具
echo ==========================================

REM 检查管理员权限
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 需要管理员权限
    echo 请右键点击此脚本，选择"以管理员身份运行"
    pause
    exit /b 1
)

set TASK_NAME=TrendRadar_KeepAlive
set SCRIPT_PATH=C:\Users\Lenovo\TrendRadar\docker\ensure_running.bat

echo 正在创建定时任务...

REM 删除旧任务（如果存在）
schtasks /delete /tn "%TASK_NAME%" /f >nul 2>&1

REM 创建新任务：每小时运行一次
schtasks /create ^
    /tn "%TASK_NAME%" ^
    /tr "\"%SCRIPT_PATH%\"" ^
    /sc hourly ^
    /st 00:00 ^
    /ru "SYSTEM" ^
    /rl HIGHEST ^
    /f

if %errorlevel% equ 0 (
    echo ✅ 定时任务创建成功！
    echo.
    echo 任务名称: %TASK_NAME%
    echo 运行频率: 每小时一次
    echo 脚本路径: %SCRIPT_PATH%
    echo.
    echo 此任务会：
    echo 1. 检查 Docker Desktop 是否运行，未运行则启动
    echo 2. 检查 TrendRadar 容器是否运行，未运行则启动
    echo 3. 确保早上 8:00-8:30 能正常推送
    echo.
) else (
    echo ❌ 任务创建失败
)

pause
