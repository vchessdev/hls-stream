#!/bin/sh

# 1. Khởi động Nginx ngầm
nginx

# 2. Tải file logo từ GitHub của bro về server Render
# Lưu ý: Phải dùng link raw (raw.githubusercontent.com) thì lệnh mới tải đúng file ảnh được
# 2. Tải file logo từ GitHub bằng link raw chuẩn
wget -O /var/www/html/logo.png "https://github.com/vchessdev/hls-stream/blob/main/logo.png?raw=true"

# 3. LINK M3U8 NGUỒN (Thay link m3u8 bro muốn tiếp sóng vào đây)
M3U8_URL="https://raw.githubusercontent.com/vchessdev/hls-stream/refs/heads/main/playlist.m3u8?token=GHSAT0AAAAAAEAXV6SER45NVL772TAWAQH22SHYFSA"

# 4. Chạy FFmpeg chèn logo vào góc dưới bên phải (cách lề phải 20px, lề dưới 20px)
# Do phải chèn logo nên bắt buộc phải render lại bằng libx264 và aac
ffmpeg -re -i "$M3U8_URL" -i /var/www/html/logo.png \
-filter_complex "overlay=main_w-overlay_w-20:main_h-overlay_h-20" \
-c:v libx264 -preset superfast -maxrate 1500k -bufsize 3000k \
-c:a aac -b:a 128k \
-f flv rtmp://localhost/hls_live/live247
