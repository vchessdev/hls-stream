#!/bin/sh

# 1. Khởi động Nginx ngầm
nginx

# 2. Tải file logo từ GitHub của bro về server Render
# Lưu ý: Phải dùng link raw (raw.githubusercontent.com) thì lệnh mới tải đúng file ảnh được
# 2. Tải file logo từ GitHub bằng link raw chuẩn
wget -O /var/www/html/logo.png "https://github.com/vchessdev/hls-stream/blob/main/logo.png?raw=true"

# 3. LINK M3U8 NGUỒN (Thay link m3u8 bro muốn tiếp sóng vào đây)
M3U8_URL="https://raw.githubusercontent.com/vchessdev/hls-stream/refs/heads/main/playlist.m3u8?token=GHSAT0AAAAAAEAXV6SER45NVL772TAWAQH22SHYFSA"
# Chạy FFmpeg hạ cấu hình tối đa để Render Free gánh nổi
ffmpeg -re -i "$M3U8_URL" -i /var/www/html/logo.png \
-filter_complex "[0:v][1:v]overlay=main_w-overlay_w-20:main_h-overlay_h-20,scale=1280:-2" \
-c:v libx264 -preset ultrafast -crf 28 -maxrate 1000k -bufsize 2000k \
-c:a copy \
-f flv rtmp://localhost/hls_live/live247
