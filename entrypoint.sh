#!/bin/sh

# 1. Khởi động Nginx ngầm
nginx
# 3. LINK M3U8 NGUỒN (Thay link m3u8 bro muốn tiếp sóng vào đây)
M3U8_URL="https://raw.githubusercontent.com/vchessdev/hls-stream/refs/heads/main/playlist.m3u8?token=GHSAT0AAAAAAEAXV6SER45NVL772TAWAQH22SHYFSA"
# Chạy FFmpeg hạ cấu hình tối đa để Render Free gánh nổi
# 3. Dùng lệnh copy thuần túy (siêu nhẹ, bao mượt cho Render Free)
ffmpeg -re -i "$M3U8_URL" -c:v copy -c:a copy -f flv rtmp://localhost/hls_live/live247
