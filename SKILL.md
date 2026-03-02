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
3. **检查配置**：读取 ~/.config/doc_translate/config.json
   - 无配置：使用 AskUserQuestion 询问导出格式
   - 有配置：使用 AskUserQuestion 询问是否沿用
4. **沿用配置流程**（显示浏览器）：
   - 使用 Playwright MCP 打开网站
   - 上传 PDF 文件
   - 配置已自动应用，点击"立即翻译"
   - 轮询状态，每 1 分钟检查一次
   - 完成后自动下载，根据导出格式重命名：
     - 双语 → {原始文件名}_双语.pdf
     - 仅译文 → {原始文件名}_译文.pdf
     - 保存到 ~/Downloads/doc_translate/
5. **首次/重新选择流程**（显示浏览器）：
   - 使用 Playwright MCP 打开网站
   - 上传文件
   - 等待你在网站上选择翻译配置
   - 你点击"立即翻译"后，继续轮询状态
   - 完成后自动下载，根据导出格式重命名：
     - 双语 → {原始文件名}_双语.pdf
     - 仅译文 → {原始文件名}_译文.pdf
     - 保存到 ~/Downloads/doc_translate/
6. **保存配置**：将本次使用的配置保存到 ~/.config/doc_translate/config.json
