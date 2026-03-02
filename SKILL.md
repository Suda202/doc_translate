# Immersive Translate 文档翻译 Skill

使用 Immersive Translate (BabelDOC) 自动翻译 PDF 文档。

## 功能

- 支持输入 arxiv 链接自动下载 PDF
- 支持输入本地 PDF 文件路径
- 自动上传并翻译
- 自动下载翻译后的文件，保持原始文件名

## 使用方式

```
/immersive-translate-doc <arxiv链接或本地文件路径> [更多文件...]
```

## 示例

```
# 单个文件
/immersive-translate-doc https://arxiv.org/abs/2309.01431
/immersive-translate-doc ~/Downloads/paper.pdf

# 批量翻译（支持多个文件）
/immersive-translate-doc https://arxiv.org/abs/2309.01431 ~/Downloads/paper1.pdf ~/Downloads/paper2.pdf
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

### 场景一：从翻译历史下载（最快）
1. 使用 Playwright MCP 打开 https://app.immersivetranslate.com/babel-doc/
2. 在翻译历史列表中查找目标文件
3. 点击该记录的 radio button 选中文件
4. 顶部会出现"下载仅译文 PDF"和"下载双语 PDF"按钮
5. 直接点击需要的下载按钮
6. 使用 browser_evaluate 提取链接并用 curl 下载
   - 选择包含 `babeldoc-batch-download-pdf` 但**不包含** `zip` 的链接
7. 重命名为 {原始文件名}_双语.pdf 或 {原始文件名}_译文.pdf

### 场景二：新文件翻译（单个）

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
   - 选择包含 `babeldoc-batch-download-pdf` 但**不包含** `zip` 的链接
   - 使用 curl 直接下载 PDF 到 ~/Downloads/doc_translate/
   - 根据导出格式重命名：{原始文件名}_双语.pdf 或 {原始文件名}_译文.pdf
8. **保存配置**：将本次使用的配置保存到 ~/.config/doc_translate/config.json

### 场景三：批量翻译

1. **解析多个输入**：处理所有传入的文件
2. **批量下载/复制文件**：到工作目录和 Playwright 访问目录
3. **检查配置**：同场景二
4. **检测会员状态**：检查页面上是否有"批量翻译"按钮
   - 有"批量翻译"按钮 → Pro 会员，按批量流程处理
   - 无"批量翻译"按钮 → 普通用户，按序一个一个翻译
5. **批量上传（Pro）**：
   - 点击"批量翻译"选项卡
   - 一次性选择多个 PDF 文件上传
   - 所有任务同时提交翻译
6. **监控进度（Pro）**：
   - 轮询检查所有任务状态
   - 可并行监控多个任务
7. **逐个下载**：每个任务完成后提取链接并下载
8. **重命名保存**：{原始文件名}_双语.pdf 或 {原始文件名}_译文.pdf
9. **保存配置**

**普通用户**：只能一个一个翻译

1-3. 同上
4-5. **按序翻译**：每个文件完成后才开始下一个
   - 重复场景二的步骤
   - 当前一个完成后再处理下一个
6. **保存配置**
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
   - 选择包含 `babeldoc-batch-download-pdf` 但**不包含** `zip` 的链接
   - 使用 curl 直接下载 PDF 到 ~/Downloads/doc_translate/
   - 根据导出格式重命名：{原始文件名}_双语.pdf 或 {原始文件名}_译文.pdf
8. **保存配置**：将本次使用的配置保存到 ~/.config/doc_translate/config.json
