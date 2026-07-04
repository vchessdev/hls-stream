#!/bin/bash
set -uo pipefail

# ================================================================
# encode_all.sh - Encode toàn bộ segment .ts thành 360p + 720p (gọi là "1080p")
# kèm logo overlay, theo dõi tiến trình chi tiết + log lỗi riêng.
# ================================================================

urls=(
    "https://raw.githubusercontent.com/vchessdev/antv/latest/1_010.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/1_011.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/1_012.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/1_013.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/1_014.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/2_000.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/2_001.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/3_005.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/3_006.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/3_007.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/3_008.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/3_009.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/4_000.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/4_001.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/4_002.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/4_003.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/5_010.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/5_011.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/5_012.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/5_013.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/5_014.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/6_007.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/6_008.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/6_009.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/6_010.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/6_011.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/7_000.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/7_001.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/7_002.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/7_003.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/7_004.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/7_005.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/7_006.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/7_007.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/7_008.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/7_009.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/7_010.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/7_011.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/7_012.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/7_013.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/7_014.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/7_015.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/8_000.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/8_001.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/8_002.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/8_003.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/8_004.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/8_005.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/8_006.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/8_007.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/8_008.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/8_009.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/8_010.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/8_011.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/8_012.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/8_013.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/8_014.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/8_015.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/8_016.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/latest/8_017.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/main/9_000.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/main/9_001.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/main/9_002.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/main/9_003.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/main/9_004.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/main/9_005.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/main/9_006.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/main/10_000.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/main/10_001.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/main/10_002.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/main/10_003.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/sau/11_000.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/sau/11_001.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/sau/11_002.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/sau/11_003.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/sau/11_004.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/sau/11_005.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/sau/12_000.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/sau/12_001.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/sau/12_002.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/sau/12_003.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/sau/12_004.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/sau/12_005.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/sau/12_006.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/sau/12_012.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/sau/12_013.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/sau/12_014.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/sau/12_015.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/sau/12_016.ts"
    "https://raw.githubusercontent.com/vchessdev/antv/sau/12_017.ts"
)

LOGO="logo.png"
OUT_360="hoanthanh/360p"
OUT_720="hoanthanh/1080p"
LOG_FILE="encode_log.txt"
FAIL_FILE="encode_failed.txt"

mkdir -p "$OUT_360" "$OUT_720"
: > "$LOG_FILE"
: > "$FAIL_FILE"

total=${#urls[@]}
ok_count=0
fail_count=0
start_all=$(date +%s)

echo "================================================================"
echo " BẮT ĐẦU ENCODE $total FILE  |  $(date '+%Y-%m-%d %H:%M:%S')"
echo "================================================================"

if [ ! -f "$LOGO" ]; then
    echo "❌ KHÔNG TÌM THẤY $LOGO trong thư mục hiện tại. Dừng lại." | tee -a "$LOG_FILE"
    exit 1
fi

count=0
for url in "${urls[@]}"; do
    name=$(printf "finished_%03d.ts" "$count")
    idx_display="$((count+1))/$total"
    t_start=$(date +%s)

    echo ""
    echo "🚀 [$idx_display] Đang xử lý: $name"
    echo "    Nguồn: $url"

    ffmpeg -y \
        -protocol_whitelist "file,crypto,data,http,https,tls,tcp" \
        -fflags +genpts \
        -i "$url" \
        -i "$LOGO" \
        -filter_complex "[0:v]split=2[v1][v2];[1:v]split=2[logo1][logo2];[v1]scale=640:360:force_original_aspect_ratio=decrease,pad=640:360:(ow-iw)/2:(oh-ih)/2[bg360];[logo1]scale=60:-1[l360];[bg360][l360]overlay=main_w-overlay_w-10:main_h-overlay_h-10,fps=24[outv360];[v2]scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2[bg720];[logo2]scale=100:-1[l720];[bg720][l720]overlay=main_w-overlay_w-10:main_h-overlay_h-10,fps=30[outv720]" \
        -map "[outv360]" -map "0:a?" \
        -c:v:0 libx264 -preset veryfast -profile:v:0 baseline \
        -b:v:0 350k -maxrate:0 350k -bufsize:0 700k -g 96 -keyint_min 96 \
        -c:a:0 aac -b:a:0 64k -ar:0 44100 \
        "$OUT_360/$name" \
        -map "[outv720]" -map "0:a?" \
        -c:v:1 libx264 -preset veryfast -profile:v:1 main \
        -b:v:1 1800k -maxrate:1 1800k -bufsize:1 3600k -g 120 -keyint_min 120 \
        -c:a:1 aac -b:a:1 128k -ar:1 44100 \
        "$OUT_720/$name" \
        >> "$LOG_FILE" 2>&1

    status=$?
    t_end=$(date +%s)
    elapsed=$((t_end - t_start))

    if [ $status -eq 0 ] && [ -s "$OUT_360/$name" ] && [ -s "$OUT_720/$name" ]; then
        size_360=$(du -h "$OUT_360/$name" | cut -f1)
        size_720=$(du -h "$OUT_720/$name" | cut -f1)
        echo "    ✅ OK  (${elapsed}s)  |  360p: $size_360  |  720p: $size_720"
        ok_count=$((ok_count+1))
    else
        echo "    ❌ FAIL (${elapsed}s)  |  Xem chi tiết lỗi trong $LOG_FILE"
        echo "$count | $name | $url" >> "$FAIL_FILE"
        fail_count=$((fail_count+1))
    fi

    count=$((count+1))
done

end_all=$(date +%s)
total_elapsed=$((end_all - start_all))
mins=$((total_elapsed/60))
secs=$((total_elapsed%60))

echo ""
echo "================================================================"
echo " HOÀN TẤT!  Tổng thời gian: ${mins}m${secs}s"
echo " ✅ Thành công : $ok_count/$total"
echo " ❌ Thất bại   : $fail_count/$total"
if [ $fail_count -gt 0 ]; then
    echo " -> Danh sách file lỗi nằm trong: $FAIL_FILE"
    echo " -> Log chi tiết ffmpeg nằm trong: $LOG_FILE"
fi
echo "================================================================"