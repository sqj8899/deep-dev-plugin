# deep-dev — 四阶段深度开发工作流

Claude Code 插件，提供纪律严明的四阶段开发工作流：**研究 → 计划+注释循环 → 实现 → 验证**。

核心原则：**在写代码之前，必须先审查和批准一份详细的书面计划。**

## 安装

### 方式一：通过 GitHub 安装（推荐）

```bash
claude install github:songqijun/deep-dev-plugin
```

支持后续通过 `claude update` 自动更新。

### 方式二：手动安装

1. 将整个 `deep-dev-plugin` 文件夹复制到任意位置，例如：

```bash
cp -r deep-dev-plugin ~/tools/deep-dev-plugin
```

2. 在 `~/.claude/settings.json` 中注册插件路径：

```json
{
  "plugins": [
    "~/tools/deep-dev-plugin"
  ]
}
```

路径可以是任意位置，Claude Code 只认 `settings.json` 中注册的路径。

## 依赖

### 必需依赖

- **Codex 插件** — 研究、计划和验证阶段的执行引擎

```bash
claude install github:anthropics/claude-code-openai-codex
```

> 如果未安装 Codex，deep-dev 会自动检测并提示安装，或自动切换到 Claude Code 单引擎回退模式。

### 可选依赖

- **Superpowers 插件** — 增强计划编写、代码审查等能力

```bash
claude install github:anthropics/claude-code-superpowers
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

阶段四：测试验证 [Codex]
  ├─ 基于 test-cases.md 逐条验证
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
