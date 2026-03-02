#!/bin/bash

# Immersive Translate 文档翻译 Skill
# 参数：$1 = arxiv链接 或 本地文件路径

INPUT="$1"

if [ -z "$INPUT" ]; then
    echo "用法: /immersive-translate-doc <arxiv链接或本地文件路径>"
    echo "示例: /immersive-translate-doc https://arxiv.org/abs/2309.01431"
    echo "       /immersive-translate-doc ~/Downloads/paper.pdf"
    exit 1
fi

# 解析输入类型
if [[ "$INPUT" == *"arxiv.org"* ]]; then
    # arxiv 链接，提取论文 ID
    PDF_URL=""
    if [[ "$INPUT" == *"arxiv.org/pdf"* ]]; then
        PDF_URL="$INPUT"
    else
        # 提取 arxiv ID
        ARXIV_ID=$(echo "$INPUT" | sed -E 's/.*abs\/([0-9.]+).*/\1/')
        PDF_URL="https://arxiv.org/pdf/${ARXIV_ID}.pdf"
    fi

    # 下载论文
    TEMP_FILE="/tmp/$(basename "$PDF_URL")"
    echo "下载论文: $PDF_URL"
    curl -L -o "$TEMP_FILE" "$PDF_URL"

    if [ $? -ne 0 ]; then
        echo "下载失败"
        exit 1
    fi

    # 获取原始文件名
    ORIGINAL_NAME=$(basename "$TEMP_FILE" .pdf)
    FILE_PATH="$TEMP_FILE"
else
    # 本地文件
    if [ ! -f "$INPUT" ]; then
        echo "文件不存在: $INPUT"
        exit 1
    fi

    # 获取绝对路径和原始文件名
    FILE_PATH=$(readlink -f "$INPUT")
    ORIGINAL_NAME=$(basename "$FILE_PATH" .pdf)
fi

# 工作目录
WORK_DIR="${DOC_TRANSLATE_DIR:-$HOME/Downloads/doc_translate}"
mkdir -p "$WORK_DIR"

# 复制文件到工作目录，保留原始文件名
COPY_FILE="$WORK_DIR/${ORIGINAL_NAME}.pdf"
cp "$FILE_PATH" "$COPY_FILE"

echo "文件: $ORIGINAL_NAME"
echo "已复制到: $COPY_FILE"
echo "开始翻译流程..."

# 后续步骤在 Claude 会话中执行，使用 Playwright MCP
