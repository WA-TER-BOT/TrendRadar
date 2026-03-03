#!/bin/bash
# TrendRadar Cron 监控脚本
# 用途：定期检查 cron 进程是否在运行，如果停止则自动重启容器

echo "=========================================="
echo "TrendRadar Cron 监控脚本"
echo "检查时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "=========================================="

# 检查容器是否在运行
if ! docker ps | grep -q trendradar; then
    echo "❌ 容器未运行，尝试启动..."
    cd "$(dirname "$0")"
    docker-compose up -d
    exit 1
fi

# 检查 supercronic 进程
if docker exec trendradar pgrep -f supercronic > /dev/null 2>&1; then
    echo "✅ Supercronic 进程正常运行"

    # 显示最后一次执行时间
    last_log=$(docker logs trendradar --tail 1 --timestamps 2>&1 | tail -1)
    echo "📝 最后日志: $last_log"
else
    echo "❌ Supercronic 进程已停止！"
    echo "🔄 正在重启容器..."

    cd "$(dirname "$0")"
    docker-compose restart trendradar

    echo "✅ 容器已重启"
fi

echo "=========================================="
