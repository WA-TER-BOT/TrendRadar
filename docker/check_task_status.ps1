# TrendRadar 监控任务验证脚本
Write-Host "=========================================="
Write-Host "TrendRadar 监控任务状态检查"
Write-Host "=========================================="
Write-Host ""

$taskName = "TrendRadar_Monitor"

try {
    $task = Get-ScheduledTask -TaskName $taskName -ErrorAction Stop

    Write-Host "✅ 任务已创建" -ForegroundColor Green
    Write-Host ""
    Write-Host "📋 任务详情："
    Write-Host "  任务名称: $($task.TaskName)"
    Write-Host "  状态: $($task.State)"
    Write-Host "  上次运行: $($task.LastRunTime)"
    Write-Host "  下次运行: $($task.NextRunTime)"
    Write-Host ""

    $trigger = $task.Triggers[0]
    Write-Host "⏰ 触发器配置："
    Write-Host "  类型: $($trigger.CimClass.CimClassName)"
    if ($trigger.Repetition) {
        Write-Host "  重复间隔: $($trigger.Repetition.Interval)"
        Write-Host "  持续时间: $($trigger.Repetition.Duration)"
    }
    Write-Host ""

    Write-Host "🔧 操作："
    Write-Host "  程序: $($task.Actions[0].Execute)"
    Write-Host ""

} catch {
    Write-Host "❌ 任务未创建" -ForegroundColor Red
    Write-Host ""
    Write-Host "💡 请运行以下脚本创建任务："
    Write-Host "   C:\Users\Lenovo\TrendRadar\docker\setup_monitor_task.bat"
    Write-Host "   （需要以管理员身份运行）"
    Write-Host ""
}

Write-Host "=========================================="
Write-Host ""
Write-Host "按任意键退出..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
