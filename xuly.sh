#!/bin/bash
# 1. Tạo sẵn các thư mục chứa các bản chất lượng khác nhau
mkdir -p hoanthanh/360p
mkdir -p hoanthanh/1080p

# Xóa dữ liệu cũ nếu có để tránh bị ghi đè lỗi
rm -rf hoanthanh/360p/*
rm -rf hoanthanh/1080p/*

# 2. Mảng chứa toàn bộ 95 link file gốc của bro
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

count=0
for url in "${urls[@]}"; do
  name=$(printf "finished_%03d.ts" $count)
  echo "🚀 [File $count/94] Đang băm đa luồng Adaptive Bitrate cho: $name"
  
  # LỆNH FFMPEG THẦN THÁNH: 1 đầu vào xuất song song 2 đầu ra (Fix màn đen + logo nhỏ và dịch xuống dưới góc)
  ffmpeg -protocol_whitelist "file,crypto,data,http,https,tls,tcp" -fflags +genpts \
    -i "$url" -i "logo.png" \
    -filter_complex "[0:v]split=2[v1][v2]; \
                     [1:v]split=2[logo1][logo2]; \
                     [v1]scale=640:360:force_original_aspect_ratio=decrease,pad=640:360:(ow-iw)/2:(oh-ih)/2[bg360]; \
                     [logo1]scale=60:-1[l360]; \
                     [bg360][l360]overlay=main_w-overlay_w-10:main_h-overlay_h-10,fps=24[outv360]; \
                     [v2]scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2[bg720]; \
                     [logo2]scale=100:-1[l720]; \
                     [bg720][l720]overlay=main_w-overlay_w-10:main_h-overlay_h-10,fps=60[outv720]" \
    -map "[outv360]" -map 0:a? -c:v:0 libx264 -preset ultrafast -b:v:0 400k -maxrate:0 400k -bufsize:0 800k -g 48 -c:a:0 aac -b:a:0 64k -ar:0 44100 "hoanthanh/360p/$name" \
    -map "[outv720]" -map 0:a? -c:v:1 libx264 -preset ultrafast -b:v:1 2500k -maxrate:1 2500k -bufsize:1 5000k -g 120 -c:a:1 aac -b:a:1 128k -ar:1 44100 "hoanthanh/1080p/$name" \
    -y 2>/dev/null

  count=$((count+1))
done

echo "🎉 HOÀN THÀNH ĐỒNG BỘ ĐA CHẤT LƯỢNG!"