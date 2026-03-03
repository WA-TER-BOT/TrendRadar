@echo off
REM 修复 TrendRadar crontab 添加超时保护

echo ==========================================
echo TrendRadar Crontab 修复工具
echo ==========================================

REM 添加超时保护到 crontab
docker exec trendradar sh -c "echo '*/30 * * * * cd /app && timeout 900 /usr/local/bin/python -m trendradar' > /tmp/crontab"

REM 重启容器使配置生效
cd /d C:\Users\Lenovo\TrendRadar\docker
docker-compose restart trendradar

echo ✅ 已添加 15 分钟超时保护并重启容器
echo ==========================================

