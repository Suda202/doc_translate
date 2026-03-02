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
2. 使用 AskUserQuestion 询问：
   - "沿用配置" - 使用保存的设置直接翻译
   - "重新选择" - 在网站上选择新配置

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
4. **复制文件**：复制 PDF 到 ~/Downloads/doc_translate/{原始文件名}.pdf
5. **打开网站**：使用 Playwright 打开 https://app.immersivetranslate.com/babel-doc/
6. **上传文件**：点击"上传文件并翻译"按钮，上传 PDF
7. **等待配置**：等待用户在网站上选择翻译配置
8. **开始翻译**：用户点击"立即翻译"后，进入等待阶段
9. **监控状态**：每 1 分钟轮询翻译状态，直到显示"已完成"
10. **自动下载**：
    - 双语：下载双语 PDF 到 ~/Downloads/doc_translate/原始文件名_双语.pdf
    - 仅译文：下载仅译文 PDF 到 ~/Downloads/doc_translate/原始文件名_译文.pdf
    - 不导出：提示用户在网站上查看
11. **保存配置**：将本次使用的配置保存到 ~/.config/doc_translate/config.json
