#!/bin/sh

# Khởi động Nginx ngầm
nginx

# LINK VIDEO CỦA BRO (Phải là link tải trực tiếp - Direct Link đuôi .mp4 đã chèn sẵn logo)
VIDEO_URL="https://www.w3schools.com/html/mov_bbb.mp4"

# Dùng FFmpeg kéo stream liên tục (loop vĩnh viễn -stream_loop -1) và đẩy vào Nginx
ffmpeg -stream_loop -1 -re -i "$VIDEO_URL" -c copy -f flv rtmp://localhost/hls_live/live247
