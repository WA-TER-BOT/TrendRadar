# coding=utf-8
"""
分类总结器 - 对每个新闻分类单独进行 AI 总结
"""

from typing import Dict, List
import sys
sys.path.insert(0, '/app')
from trendradar.ai.client import AIClient


def summarize_category(
    category_word: str,
    titles: List[Dict],
    ai_client: AIClient,
    max_tokens: int = 500
) -> str:
    """
    对单个分类的新闻进行 AI 总结

    Args:
        category_word: 分类关键词
        titles: 该分类下的新闻列表
        ai_client: AI 客户端实例
        max_tokens: 最大生成 token 数

    Returns:
        str: AI 总结内容（失败返回空字符串）
    """
    if not titles:
        return ""

    # 构建新闻内容
    news_content = ""
    for i, title_data in enumerate(titles, 1):
        title = title_data.get("title", "")
        source = title_data.get("source_name", "")
        news_content += f"{i}. [{source}] {title}\n"

    # 构建提示词
    system_prompt = "你是一个专业的新闻分析助手，擅长提取关键信息并进行简洁总结。"

    user_prompt = f"""请对以下关于"{category_word}"的新闻进行简洁总结（100字以内）：

{news_content}

要求：
1. 提取核心事件和关键信息
2. 语言简洁，避免冗余
3. 突出重点，不要罗列标题
4. 直接输出总结内容，不要前缀"""

    messages = [
        {"role": "system", "content": system_prompt},
        {"role": "user", "content": user_prompt}
    ]

    try:
        summary = ai_client.chat(messages, max_tokens=max_tokens, temperature=0.7)
        return summary.strip()
    except Exception as e:
        print(f"[AI总结] 分类 '{category_word}' 总结失败: {e}")
        return ""


def add_category_summaries(
    stats: List[Dict],
    ai_config: Dict,
    enabled: bool = True
) -> List[Dict]:
    """
    为每个分类添加 AI 总结

    Args:
        stats: 分类统计数据
        ai_config: AI 配置
        enabled: 是否启用分类总结

    Returns:
        List[Dict]: 添加了 ai_summary 字段的统计数据
    """
    if not enabled or not stats:
        return stats

    # 创建 AI 客户端
    try:
        ai_client = AIClient(ai_config)
        if not ai_client.api_key:
            print("[AI总结] 未配置 API Key，跳过分类总结")
            return stats
    except Exception as e:
        print(f"[AI总结] 初始化失败: {e}")
        return stats

    print(f"[AI总结] 开始对 {len(stats)} 个分类进行总结...")

    # 对每个分类进行总结
    for stat in stats:
        word = stat.get("word", "")
        titles = stat.get("titles", [])

        if not titles:
            continue

        print(f"[AI总结] 正在总结分类: {word} ({len(titles)} 条新闻)")
        summary = summarize_category(word, titles, ai_client)

        if summary:
            stat["ai_summary"] = summary
            print(f"[AI总结] ✓ {word}: {summary[:50]}...")
        else:
            stat["ai_summary"] = ""

    print("[AI总结] 分类总结完成")
    return stats
