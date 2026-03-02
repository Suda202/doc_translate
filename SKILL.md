# Immersive Translate 文档翻译 Skill

使用 Immersive Translate (BabelDOC) 自动翻译 PDF 文档。

## 功能

- 支持输入 arxiv 链接自动下载 PDF
- 支持输入本地 PDF 文件路径
- 自动上传并翻译
- 自动下载翻译后的文件，保持原始文件名

## 使用方式

```
/immersive-translate-doc <arxiv链接或本地文件路径>
```

## 示例

```
/immersive-translate-doc https://arxiv.org/abs/2309.01431
/immersive-translate-doc ~/Downloads/paper.pdf
```

## 配置流程

**首次使用**：
1. 使用 AskUserQuestion 询问导出格式偏好（双语/仅译文/不导出）
2. 上传文件后在网站上选择翻译配置（服务、术语库、语言等）
3. 自动保存设置

**后续使用**：
1. 读取已保存的配置文件
2. 使用 AskUserQuestion 询问是否沿用
   - "沿用配置"：浏览器打开后配置自动应用，直接点击翻译
   - "重新选择"：打开浏览器，在网站上选择新配置

**配置保存位置**：`~/.config/doc_translate/config.json`

## 修改配置

如需修改配置：
1. 输入 `reset` 清空配置记录，重新询问导出格式
2. 或在翻译网站上选择新配置，我会自动保存

## 实现步骤

1. **解析输入**：判断是 arxiv 链接还是本地文件
2. **下载/复制文件**：
   - 如果是 arxiv 链接：直接下载 PDF 到 ~/Downloads/doc_translate/{文件名}.pdf
   - 如果是本地文件：复制到 ~/Downloads/doc_translate/{文件名}.pdf
3. **复制到允许访问的目录**：Playwright MCP 只能访问项目目录（如 /Users/suda/project/coding/doc_translate/），需要先将文件复制到该目录
4. **检查配置**：读取 ~/.config/doc_translate/config.json
   - 无配置：使用 AskUserQuestion 询问导出格式
   - 有配置：使用 AskUserQuestion 询问是否沿用
5. **翻译流程**：
   - 使用 Playwright MCP 打开网站
   - 上传 PDF 文件（从允许访问的目录）
   - 沿用配置：配置已自动应用，点击"立即翻译"
   - 首次/重新选择：等待你在网站上选择配置，点击"立即翻译"
6. **监控翻译**：
   - 翻译提交后会打开预览页面
   - 轮询检查翻译额度变化或页面状态
7. **下载翻译文件**：
   - 从预览页面提取下载链接（分析页面中的 <a> 标签 href 属性）
   - 使用 curl 直接下载到 ~/Downloads/doc_translate/
   - 根据导出格式重命名：{原始文件名}_双语.pdf 或 {原始文件名}_译文.pdf
8. **保存配置**：将本次使用的配置保存到 ~/.config/doc_translate/config.json
