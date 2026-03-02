#!/bin/bash

# Immersive Translate 文档翻译 Skill
# 参数：多个 arxiv链接 或 本地文件路径

if [ -z "$1" ]; then
    echo "用法: /immersive-translate-doc <arxiv链接或本地文件路径> [更多文件...]"
    echo "示例: /immersive-translate-doc https://arxiv.org/abs/2309.01431"
    echo "       /immersive-translate-doc ~/Downloads/paper.pdf"
    echo "       /immersive-translate-doc file1.pdf file2.pdf file3.pdf"
    exit 1
fi

# 工作目录（用于保存原始文件和翻译后的文件）
WORK_DIR="${DOC_TRANSLATE_DIR:-$HOME/Downloads/doc_translate}"
mkdir -p "$WORK_DIR"

# 处理所有输入文件
FILES=()
for INPUT in "$@"; do
    echo "========== 处理文件: $INPUT =========="

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

        # 获取原始文件名
        ORIGINAL_NAME=$(basename "$PDF_URL" .pdf)

        # 下载论文到工作目录
        echo "下载论文: $PDF_URL"
        curl -L -o "$WORK_DIR/${ORIGINAL_NAME}.pdf" "$PDF_URL"

        if [ $? -ne 0 ]; then
            echo "下载失败: $INPUT"
            continue
        fi

        FILE_PATH="$WORK_DIR/${ORIGINAL_NAME}.pdf"
    else
        # 本地文件
        if [ ! -f "$INPUT" ]; then
            echo "文件不存在: $INPUT"
            continue
        fi

        # 获取绝对路径和原始文件名
        FILE_PATH=$(readlink -f "$INPUT")
        ORIGINAL_NAME=$(basename "$FILE_PATH" .pdf)

        # 如果文件不在工作目录，则移动到工作目录
        if [[ "$FILE_PATH" != "$WORK_DIR"* ]]; then
            mv "$FILE_PATH" "$WORK_DIR/"
            FILE_PATH="$WORK_DIR/${ORIGINAL_NAME}.pdf"
        fi
    fi

    echo "文件: $ORIGINAL_NAME"
    echo "路径: $FILE_PATH"
    echo ""

    FILES+=("$ORIGINAL_NAME")
done

echo "========== 处理完成 =========="
echo "共处理 ${#FILES[@]} 个文件"
echo "文件列表: ${FILES[*]}"
echo "开始翻译流程..."

# 后续步骤在 Claude 会话中执行，使用 Playwright MCP
