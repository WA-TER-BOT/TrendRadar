@echo off
REM 自动创建 TrendRadar 监控任务
REM 此脚本需要管理员权限运行

echo ==========================================
echo TrendRadar 监控任务创建工具
echo ==========================================
echo.

REM 检查是否有管理员权限
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 错误：需要管理员权限
    echo 请右键点击此脚本，选择"以管理员身份运行"
    echo.
    pause
    exit /b 1
)

echo ✅ 管理员权限检查通过
echo.

REM 任务配置
set TASK_NAME=TrendRadar_Monitor
set SCRIPT_PATH=C:\Users\Lenovo\TrendRadar\docker\check_status.bat

REM 检查脚本是否存在
if not exist "%SCRIPT_PATH%" (
    echo ❌ 错误：监控脚本不存在
    echo 路径：%SCRIPT_PATH%
    echo.
    pause
    exit /b 1
)

echo 📝 任务配置：
echo   任务名称：%TASK_NAME%
echo   脚本路径：%SCRIPT_PATH%
echo   执行频率：每小时一次
echo.

REM 删除已存在的任务（如果有）
schtasks /query /tn "%TASK_NAME%" >nul 2>&1
if %errorlevel% equ 0 (
    echo 🔄 检测到已存在的任务，正在删除...
    schtasks /delete /tn "%TASK_NAME%" /f >nul 2>&1
    echo ✅ 旧任务已删除
    echo.
)

REM 创建新任务
echo 🔨 正在创建定时任务...
schtasks /create ^
    /tn "%TASK_NAME%" ^
    /tr "\"%SCRIPT_PATH%\"" ^
    /sc hourly ^
    /st 00:00 ^
    /ru "SYSTEM" ^
    /rl HIGHEST ^
    /f

if %errorlevel% equ 0 (
    echo.
    echo ==========================================
    echo ✅ 任务创建成功！
    echo ==========================================
    echo.
    echo 📋 任务详情：
    echo   • 任务名称：%TASK_NAME%
    echo   • 执行频率：每小时运行一次
    echo   • 运行账户：SYSTEM（系统账户）
    echo   • 权限级别：最高
    echo.
    echo 🔍 验证任务：
    schtasks /query /tn "%TASK_NAME%" /fo list
    echo.
    echo 💡 提示：
    echo   • 任务将在每小时的整点运行
    echo   • 可以在"任务计划程序"中查看和管理此任务
    echo   • 如需删除任务，运行：schtasks /delete /tn "%TASK_NAME%" /f
    echo.
) else (
    echo.
    echo ❌ 任务创建失败
    echo 错误代码：%errorlevel%
    echo.
)

pause
