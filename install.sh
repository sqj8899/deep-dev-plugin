#!/bin/bash
# deep-dev 插件一键安装脚本

set -e

PLUGIN_DIR="${HOME}/.claude/plugins/deep-dev-plugin"
SETTINGS_FILE="${HOME}/.claude/settings.json"

echo "📦 正在安装 deep-dev 插件..."

# 1. 克隆或更新仓库
if [ -d "$PLUGIN_DIR" ]; then
  echo "  检测到已安装，正在更新..."
  cd "$PLUGIN_DIR" && git pull --quiet
else
  echo "  正在克隆仓库..."
  mkdir -p "${HOME}/.claude/plugins"
  git clone --quiet https://github.com/sqj8899/deep-dev-plugin.git "$PLUGIN_DIR"
fi

# 2. 注册到 settings.json
if [ ! -f "$SETTINGS_FILE" ]; then
  echo '{}' > "$SETTINGS_FILE"
fi

# 检查是否已注册
if grep -q "deep-dev-plugin" "$SETTINGS_FILE" 2>/dev/null; then
  echo "  插件路径已注册"
else
  echo "  正在注册插件路径到 settings.json..."
  # 用 python 安全修改 JSON（macOS 自带 python3）
  python3 -c "
import json, os
path = os.path.expanduser('$SETTINGS_FILE')
with open(path, 'r') as f:
    data = json.load(f)
plugins = data.get('plugins', [])
if '$PLUGIN_DIR' not in plugins:
    plugins.append('$PLUGIN_DIR')
    data['plugins'] = plugins
    with open(path, 'w') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
"
fi

echo ""
echo "✅ deep-dev 插件安装完成！"
echo "   路径：$PLUGIN_DIR"
echo ""
echo "📋 依赖插件（可选，首次使用时会自动检测并提示）："
echo "   - Codex 插件：在 Claude Code 中运行 /plugin install codex@openai-codex"
echo "   - Superpowers 插件：在 Claude Code 中运行 /plugin install superpowers@superpowers"
echo ""
echo "🚀 重启 Claude Code 后即可使用 deep-dev skill"
