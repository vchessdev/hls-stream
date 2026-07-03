
#!/bin/sh

# 1. Khởi động Nginx ngầm
nginx

# 2. Tải file logo từ GitHub về đúng thư mục hệ thống mới
wget -O /run/nginx/logo.png "https://github.com/vchessdev/hls-stream/blob/main/logo.png?raw=true"

# 3. LINK M3U8 NGUỒN CỦA BRO
M3U8_URL="https://raw.githubusercontent.com/vchessdev/hls-stream/refs/heads/main/playlist.m3u8"

# 4. Chạy FFmpeg hạ độ phân giải xuống 480p để Render Free gánh nổi logo
ffmpeg -re -i "$M3U8_URL" -i /run/nginx/logo.png \
-filter_complex "[0:v]fps=20,scale=854:480[bg];[bg][1:v]overlay=main_w-overlay_w-15:main_h-overlay_h-15" \
-c:v libx264 -preset ultrafast -tune zerolatency -crf 30 -maxrate 600k -bufsize 1200k \
-c:a aac -b:a 64k \
-f flv rtmp://localhost/hls_live/live247

