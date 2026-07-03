FROM alpine:3.18

# Cài đặt Nginx, module RTMP, FFmpeg và bash
RUN apk update && apk add --no-cache nginx nginx-mod-rtmp ffmpeg bash

# ĐỔI THÀNH DÒNG NÀY ĐỂ ĐỒNG BỘ ĐƯỜNG DẪN
RUN mkdir -p /run/nginx/stream

# Copy cấu hình vào container
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /entrypoint.sh

# Cấp quyền chạy cho file script
RUN chmod +x /entrypoint.sh

# Mở port mạng
EXPOSE 80 1935

# Chạy script khi khởi động
ENTRYPOINT ["/entrypoint.sh"]
