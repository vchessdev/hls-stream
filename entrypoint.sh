#!/bin/sh

# 1. Khởi động Nginx ngầm
nginx

# 2. LINK M3U8 NGUỒN CỦA BRO
M3U8_URL="https://raw.githubusercontent.com/vchessdev/hls-stream/refs/heads/main/playlist.m3u8"

# 3. Lệnh copy huyền thoại - 0% CPU, bao nét, bao mượt!
ffmpeg -re -i "$M3U8_URL" -c:v copy -c:a copy -f flv rtmp://localhost/hls_live/live247
