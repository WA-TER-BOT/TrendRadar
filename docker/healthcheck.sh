#!/bin/bash
# TrendRadar 健康检查脚本
# 检查 supercronic 进程是否在运行

# 检查 supercronic 进程
if pgrep -f supercronic > /dev/null; then
    echo "✓ Supercronic is running"
    exit 0
else
    echo "✗ Supercronic is NOT running"
    exit 1
fi
