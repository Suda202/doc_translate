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

**首次使用**：上传文件后在网站上选择配置，我会自动保存你的设置

**后续使用**：显示已保存的配置，问你是否沿用

## 修改配置

如需修改配置：
1. 直接在翻译页面上选择新配置，我会自动保存新设置
2. 输入 `reset` 可清空本地配置记录

## 实现步骤

1. 解析输入：判断是 arxiv 链接还是本地文件
2. 如果是 arxiv 链接，转换为 PDF 下载地址并下载
3. 复制文件到允许访问的目录
4. 检查是否有已保存的配置
   - 有：询问用户是否沿用
   - 无：让用户在网站上选择配置
5. 使用 Playwright 打开 https://app.immersivetranslate.com/babel-doc/
6. 点击"上传文件并翻译"按钮
7. 上传 PDF 文件
8. 等待文件上传完成，设置翻译配置
9. 点击"立即翻译"
10. 等待翻译完成
11. 获取下载链接
12. 下载翻译后的 PDF 到 ~/Downloads/，文件名格式：原始文件名_双语.pdf
13. 清理临时文件
14. 保存配置供下次使用
