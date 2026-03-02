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
- 显示已保存的配置（包含导出格式）
- 询问是否沿用，或选择新配置

## 修改配置

如需修改配置：
1. 直接在翻译页面上选择新配置，我会自动保存新设置
2. 输入 `reset` 可清空本地配置记录

## 实现步骤

1. **解析输入**：判断是 arxiv 链接还是本地文件
2. **转换下载**：如果是 arxiv 链接，转换为 PDF 下载地址并下载
3. **复制文件**：复制 PDF 到允许访问的目录（Playwright 可访问的目录）
4. **询问配置**：
   - 使用 AskUserQuestion 询问导出格式
   - 检查是否有已保存的配置
   - 有配置：询问是否沿用
   - 无配置：让用户在网站上选择
5. **打开网站**：使用 Playwright 打开 https://app.immersivetranslate.com/babel-doc/
6. **上传文件**：点击"上传文件并翻译"按钮，上传 PDF
7. **等待配置**：等待用户在网站上选择翻译配置
8. **开始翻译**：用户点击"立即翻译"后，进入等待阶段
9. **监控状态**：轮询翻译状态，直到显示"已完成"
10. **自动下载**：
    - 双语：下载双语 PDF 到 ~/Downloads/原始文件名_双语.pdf
    - 仅译文：下载仅译文 PDF 到 ~/Downloads/原始文件名_仅译文.pdf
    - 不导出：提示用户在网站上查看
11. **保存配置**：将本次使用的配置保存到本地文件
12. **清理临时文件**：删除临时复制的工作目录文件
