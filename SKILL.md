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
   - "沿用配置"：完全自动化（不上传网站，直接后台翻译）
   - "重新选择"：打开浏览器，在网站上选择新配置

**配置保存位置**：`~/.config/doc_translate/config.json`

## 修改配置

如需修改配置：
1. 输入 `reset` 清空配置记录，重新询问导出格式
2. 或在翻译网站上选择新配置，我会自动保存

## 实现步骤

1. **解析输入**：判断是 arxiv 链接还是本地文件
2. **转换下载**：如果是 arxiv 链接，转换为 PDF 下载地址并下载
3. **检查配置**：读取 ~/.config/doc_translate/config.json
   - 无配置：使用 AskUserQuestion 询问导出格式
   - 有配置：使用 AskUserQuestion 询问是否沿用
4. **沿用配置流程**（无需打开浏览器）：
   - 复制 PDF 到 ~/Downloads/doc_translate/{原始文件名}.pdf
   - 调用 BabelDOC API 上传并翻译（后台自动完成）
   - 轮询状态，每 1 分钟检查一次
   - 完成后自动下载到 ~/Downloads/doc_translate/
5. **首次/重新选择流程**（需要打开浏览器）：
   - 复制 PDF 到 ~/Downloads/doc_translate/{原始文件名}.pdf
   - 打开浏览器，上传文件
   - 等待用户在网站上选择配置
   - 用户点击"立即翻译"
   - 轮询状态，每 1 分钟检查一次
   - 自动下载
6. **保存配置**：将本次使用的配置保存到 ~/.config/doc_translate/config.json
