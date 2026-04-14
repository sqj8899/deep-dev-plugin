# deep-dev — 四阶段深度开发工作流

Claude Code 插件，提供纪律严明的四阶段开发工作流：**研究 → 计划+注释循环 → 实现 → 验证**。

核心原则：**在写代码之前，必须先审查和批准一份详细的书面计划。**

## 安装

### 一键安装（推荐）

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/sqj8899/deep-dev-plugin/main/install.sh)
```

自动完成克隆和 `settings.json` 注册。重新运行同一命令即可更新。

### 手动安装

#### 方式一：克隆仓库

1. 克隆仓库到本地任意位置：
```bash
git clone git@github.com:sqj8899/deep-dev-plugin.git ~/tools/deep-dev-plugin
```

2. 在 `~/.claude/settings.json` 中注册插件路径：

```json
{
  "plugins": [
    "~/tools/deep-dev-plugin"
  ]
}
```

更新时只需 `git pull`。

#### 方式二：直接复制文件夹

1. 将整个 `deep-dev-plugin` 文件夹复制到任意位置，例如：

```bash
cp -r deep-dev-plugin ~/tools/deep-dev-plugin
```

2. 同样在 `~/.claude/settings.json` 中注册插件路径：

```json
{
  "plugins": [
    "~/tools/deep-dev-plugin"
  ]
}
```

> 路径可以是任意位置，Claude Code 只认 `settings.json` 中注册的路径。

## 依赖

### 必需依赖

- **Codex 插件** — 研究、计划和验证阶段的执行引擎

1. 在 `~/.claude/settings.json` 中添加 marketplace：

```json
{
  "extraKnownMarketplaces": {
    "openai-codex": {
      "source": {
        "source": "github",
        "repo": "openai/codex-plugin-cc"
      }
    }
  }
}
```

2. 在 Claude Code 会话中执行：

```
/plugin install codex@openai-codex
```

> 如果未安装 Codex，deep-dev 会自动检测并提示安装，或自动切换到 Claude Code 单引擎回退模式。

### 可选依赖

- **Superpowers 插件** — 增强计划编写、代码审查等能力

1. 在 `~/.claude/settings.json` 中添加 marketplace：

```json
{
  "extraKnownMarketplaces": {
    "superpowers": {
      "source": {
        "source": "github",
        "repo": "anthropics/claude-code-superpowers"
      }
    }
  }
}
```

2. 在 Claude Code 会话中执行：

```
/plugin install superpowers@superpowers
```

## 使用

在 Claude Code 对话中，当面对复杂功能开发、重构等任务时，告诉 Claude 使用 deep-dev 工作流：

```
使用 deep-dev 来实现用户认证系统重构
```

或在你的 CLAUDE.md 中配置自动触发。

## 工作流概览

```
阶段一：深度研究 [Codex]
  ├─ 深入阅读代码，产出 research.md
  └─ 用户审查并纠正

阶段二：计划 + 注释循环 [Codex]
  ├─ 基于研究产出 plan.md
  ├─ 用户添加注释，Codex 更新计划（1-6 次）
  └─ 用户最终批准 ──── HARD GATE

阶段三：测试用例 + 全量实现 [并行]
  ├─ [Codex 后台] 生成 test-cases.md
  ├─ [Claude Code] 实现代码
  └─ 同步更新所有文档

阶段四：审核文档 [Codex]
  ├─ 基于 plan.md + 代码 + test-cases.md 生成 review.md
  └─ 用户确认通过 ──── HARD GATE

阶段五：测试验证 [Codex]
  ├─ 基于 test-cases.md + review.md 逐条验证
  └─ 产出 verification.md
```

## 适用场景

- 新功能开发（涉及多文件、多模块）
- 复杂 Bug 修复（需要深入理解系统）
- 代码重构（影响面广）
- 系统集成（需要理解现有架构）

## 不适用

- 单行修复、拼写错误
- 简单的配置修改
- 已有明确计划的执行任务

## 许可证

MIT
