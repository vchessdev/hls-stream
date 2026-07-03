#!/bin/sh

# 1. Khởi động Nginx ngầm
nginx

# 2. Tải file logo từ GitHub của bro
wget -O /run/nginx/logo.png "https://github.com/vchessdev/hls-stream/blob/main/logo.png?raw=true"

# 3. LINK M3U8 NGUỒN CỦA BRO
M3U8_URL="https://raw.githubusercontent.com/vchessdev/hls-stream/refs/heads/main/playlist.m3u8"

# 4. Giữ nguyên độ phân giải gốc + Thu nhỏ logo + Ép luồng chạy siêu tốc để cứu CPU
ffmpeg -re -i "$M3U8_URL" -i /run/nginx/logo.png \
-filter_complex "[1:v]scale=150:-1[logo];[0:v][logo]overlay=main_w-overlay_w-20:main_h-overlay_h-20" \
-c:v libx264 -preset ultrafast -tune zerolatency -threads 1 -crf 26 -maxrate 1200k -bufsize 2400k \
-c:a aac -b:a 96k \
-f flv rtmp://localhost/hls_live/live247
