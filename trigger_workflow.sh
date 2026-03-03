#!/bin/bash
# 使用 GitHub API 手动触发 workflow

REPO="WA-TER-BOT/TrendRadar"
WORKFLOW_ID="crawler.yml"
BRANCH="master"

# 需要 GitHub Personal Access Token
# 请访问: https://github.com/settings/tokens
# 创建一个 token，权限选择 workflow

read -p "请输入你的 GitHub Personal Access Token: " TOKEN

curl -X POST \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: token $TOKEN" \
  https://api.github.com/repos/$REPO/actions/workflows/$WORKFLOW_ID/dispatches \
  -d "{\"ref\":\"$BRANCH\"}"

echo ""
echo "✅ Workflow 触发请求已发送！"
echo "请访问 https://github.com/$REPO/actions 查看运行状态"
