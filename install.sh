#!/bin/bash
# deep-dev 插件一键安装脚本

set -e

PLUGIN_DIR="${HOME}/.claude/plugins/deep-dev-plugin"
MKT_DIR="${HOME}/.claude/local-marketplace"
SETTINGS_FILE="${HOME}/.claude/settings.json"

echo "📦 正在安装 deep-dev 插件..."

# 1. 克隆或更新插件仓库
if [ -d "$PLUGIN_DIR" ]; then
  echo "  检测到已安装，正在更新..."
  cd "$PLUGIN_DIR" && git pull --quiet
else
  echo "  正在克隆仓库..."
  mkdir -p "${HOME}/.claude/plugins"
  git clone --quiet https://github.com/sqj8899/deep-dev-plugin.git "$PLUGIN_DIR"
fi

# 2. 创建本地 marketplace 结构
mkdir -p "$MKT_DIR/.claude-plugin"

# 写入 marketplace.json（覆盖更新）
python3 -c "
import json, os

mkt_json = os.path.expanduser('$MKT_DIR/.claude-plugin/marketplace.json')

# 读取已有的 marketplace.json 或创建新的
data = {}
if os.path.exists(mkt_json):
    with open(mkt_json, 'r') as f:
        data = json.load(f)

# 添加 deep-dev 插件
plugins = data.get('plugins', {})
plugins['deep-dev'] = {
    'source': {
        'type': 'file',
        'path': os.path.expanduser('$PLUGIN_DIR')
    }
}
data['plugins'] = plugins

with open(mkt_json, 'w') as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
"
echo "  本地 marketplace 已配置"

# 3. 注册 marketplace 和启用插件到 settings.json
if [ ! -f "$SETTINGS_FILE" ]; then
  echo '{}' > "$SETTINGS_FILE"
fi

python3 -c "
import json, os

path = os.path.expanduser('$SETTINGS_FILE')
with open(path, 'r') as f:
    data = json.load(f)

changed = False

# 注册本地 marketplace
mkts = data.get('extraKnownMarketplaces', {})
if 'local-dev' not in mkts:
    mkts['local-dev'] = {
        'source': {
            'source': 'file',
            'path': os.path.expanduser('$MKT_DIR')
        }
    }
    data['extraKnownMarketplaces'] = mkts
    changed = True

# 启用 deep-dev 插件
enabled = data.get('enabledPlugins', {})
if 'deep-dev@local-dev' not in enabled:
    enabled['deep-dev@local-dev'] = True
    data['enabledPlugins'] = enabled
    changed = True

if changed:
    with open(path, 'w') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
    print('  已注册到 settings.json')
else:
    print('  settings.json 中已配置，无需修改')
"

echo ""
echo "✅ deep-dev 插件安装完成！"
echo "   插件路径：$PLUGIN_DIR"
echo "   Marketplace：$MKT_DIR"
echo ""
echo "📋 依赖插件（可选，首次使用时会自动检测并提示）："
echo "   - Codex 插件：在 Claude Code 中运行 /plugin install codex@openai-codex"
echo "   - Superpowers 插件：在 Claude Code 中运行 /plugin install superpowers@superpowers"
echo ""
echo "🚀 重启 Claude Code 后即可使用 deep-dev skill"
