#!/bin/bash
# TrendRadar 简易监控脚本
# 检查最后一次运行时间，如果超过 2 小时没有运行则重启容器

echo "=========================================="
echo "TrendRadar 监控检查"
echo "检查时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "=========================================="

# 获取最后一条日志的时间戳
last_log=$(docker logs trendradar --tail 1 --timestamps 2>&1 | grep -oP '^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}' | head -1)

if [ -z "$last_log" ]; then
    echo "❌ 无法获取日志时间戳"
    exit 1
fi

# 转换为时间戳（秒）
last_time=$(date -d "$last_log" +%s 2>/dev/null || date -j -f "%Y-%m-%dT%H:%M:%S" "$last_log" +%s 2>/dev/null)
current_time=$(date +%s)
diff=$((current_time - last_time))

echo "📝 最后运行时间: $last_log"
echo "⏱️  距今: $((diff / 60)) 分钟"

# 如果超过 2 小时（7200 秒）没有运行，则重启
if [ $diff -gt 7200 ]; then
    echo "❌ 超过 2 小时未运行，正在重启容器..."
    cd "$(dirname "$0")"
    docker-compose restart trendradar
    echo "✅ 容器已重启"
else
    echo "✅ 运行正常"
fi

echo "=========================================="
