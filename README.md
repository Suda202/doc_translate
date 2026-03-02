# Immersive Translate 文档翻译

使用 Immersive Translate (BabelDOC) 自动翻译 PDF 文档的 AI Skill。适用于 Claude Code、Codex 等支持 Skills 的 AI 助手。

## 典型场景

### 场景一：蹲坑刷论文
正在刷 arxiv 看到好论文 → 一句命令开始翻译 → 回到座位论文已下好

### 场景二：批量扫论文
发现多篇想看的论文 → 一次性提交批量翻译 → 喝杯咖啡回来全部搞定

### 场景三：论文阅读流
推荐论文 → 自动下载 + 翻译 → 直接阅读双语版

## 功能

- 支持输入 arxiv 链接自动下载 PDF
- 支持输入本地 PDF 文件路径
- 自动上传并翻译
- 自动下载翻译后的文件（文件名格式：原始文件名_译文.pdf 或 原始文件名_双语.pdf）

> **注意**：BabelDOC 文档翻译功能有免费额度（按 Token 计量），会员可获得更高额度。如需使用 Claude、GPT-5、Gemini 等顶级 AI 翻译模型，需订阅 Pro/Max 会员。

## 前置要求

1. **Claude Code** 已安装
2. **Playwright MCP** 已配置
3. **Immersive Translate 账号**（免费版可用，会员额度更高）
4. **首次使用需登录账号**（登录后网站会记住登录状态）

## 安装

告诉 Claude Code：`/install https://github.com/Suda202/doc_translate`

## 使用方式

```
/immersive-translate-doc <arxiv链接或本地文件路径> [更多文件...]
```

## 示例

```
# 翻译 arxiv 论文
/immersive-translate-doc https://arxiv.org/abs/2309.01431

# 翻译本地 PDF
/immersive-translate-doc ~/Downloads/paper.pdf

# 批量翻译（Pro 会员）
/immersive-translate-doc https://arxiv.org/abs/2309.01431 ~/Downloads/paper1.pdf ~/Downloads/paper2.pdf
```

## 配置

### 首次使用

首次使用会弹出网站配置页面，请选择：
- 翻译服务（推荐 Kimi + DeepSeek）
- 术语库（可多选）
- 目标语言
- 导出格式（双语/仅译文/不导出）

选择后会保存配置，下次使用自动沿用。

### 修改配置

- 直接在翻译页面上修改，网站会自动记住
- 输入 `reset` 可清除本地配置记录

### 自定义工作目录

```bash
export DOC_TRANSLATE_DIR="/your/custom/path"
```

## 文件说明

```
immersive-translate-doc/
├── SKILL.md      # Skill 定义文件
├── script.sh     # 执行脚本
└── README.md     # 本文件
```

## 注意事项

- PDF 文件会被复制到工作目录进行翻译
- 翻译后的文件保存在 `~/Downloads/`
- 翻译记录在网站保留 14 天

## License

MIT
