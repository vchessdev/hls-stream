#!/bin/bash
# Process segments with ABR (360p, 720p, 1080p) + watermark logo
# Usage: ./process_abr.sh

set -e

# ============ CONFIG ============
SOURCE_DIR="./hoanthanh/1080p"
OUTPUT_DIR="./abr"
LOGO_PATH="./logo.png"
TOTAL_SEGMENTS=95
SEGMENT_DURATION=4

# ============ CHECK ============
if [ ! -f "$LOGO_PATH" ]; then
    echo "❌ Logo không tìm thấy: $LOGO_PATH"
    exit 1
fi

if [ ! -d "$SOURCE_DIR" ]; then
    echo "❌ Source directory không tìm thấy: $SOURCE_DIR"
    exit 1
fi

# ============ CREATE DIRS ============
mkdir -p "$OUTPUT_DIR/360p"
mkdir -p "$OUTPUT_DIR/720p"
mkdir -p "$OUTPUT_DIR/1080p"

echo "🚀 Bắt đầu xử lý $TOTAL_SEGMENTS segments với ABR + watermark..."
echo "📁 Source: $SOURCE_DIR"
echo "📁 Output: $OUTPUT_DIR"
echo "🎬 Logo: $LOGO_PATH"
echo ""

START_TIME=$(date +%s)

# ============ PROCESS LOOP ============
for i in $(seq 0 $((TOTAL_SEGMENTS - 1))); do
    SEGMENT=$(printf "finished_%03d.ts" $i)
    INPUT="$SOURCE_DIR/$SEGMENT"
    
    if [ ! -f "$INPUT" ]; then
        echo "⚠️  Không tìm thấy: $SEGMENT (skip)"
        continue
    fi
    
    PERCENT=$((($i + 1) * 100 / TOTAL_SEGMENTS))
    echo "[$PERCENT%] Processing: $SEGMENT"
    
    # ===== 1080p (Full HD) =====
    ffmpeg -i "$INPUT" -i "$LOGO_PATH" \
        -filter_complex "[1:v]scale=200:-1[logo];[0:v][logo]overlay=main_w-overlay_w-20:main_h-overlay_h-20" \
        -c:v libx264 -preset ultrafast -crf 18 \
        -c:a aac -b:a 128k \
        "$OUTPUT_DIR/1080p/$SEGMENT" -y -loglevel error 2>/dev/null
    
    # ===== 720p (HD) =====
    ffmpeg -i "$INPUT" -i "$LOGO_PATH" \
        -filter_complex "[0:v]scale=1280:720[v0];[1:v]scale=140:-1[logo];[v0][logo]overlay=main_w-overlay_w-20:main_h-overlay_h-20" \
        -c:v libx264 -preset ultrafast -crf 20 \
        -c:a aac -b:a 96k \
        "$OUTPUT_DIR/720p/$SEGMENT" -y -loglevel error 2>/dev/null
    
    # ===== 360p (SD) =====
    ffmpeg -i "$INPUT" -i "$LOGO_PATH" \
        -filter_complex "[0:v]scale=640:360[v0];[1:v]scale=80:-1[logo];[v0][logo]overlay=main_w-overlay_w-20:main_h-overlay_h-20" \
        -c:v libx264 -preset ultrafast -crf 22 \
        -c:a aac -b:a 64k \
        "$OUTPUT_DIR/360p/$SEGMENT" -y -loglevel error 2>/dev/null
    
done

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

echo ""
echo "✨ Hoàn thành! Tổng thời gian: ${DURATION}s"
echo "✅ 1080p segments: $OUTPUT_DIR/1080p/"
echo "✅ 720p segments:  $OUTPUT_DIR/720p/"
echo "✅ 360p segments:  $OUTPUT_DIR/360p/"
echo ""
echo "📊 Kiểm tra file:"
echo "   1080p: $(ls -1 $OUTPUT_DIR/1080p/ 2>/dev/null | wc -l) files"
echo "   720p:  $(ls -1 $OUTPUT_DIR/720p/ 2>/dev/null | wc -l) files"
echo "   360p:  $(ls -1 $OUTPUT_DIR/360p/ 2>/dev/null | wc -l) files"
