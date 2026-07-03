FROM alpine:3.18

# Cài đặt Nginx, module RTMP, FFmpeg và bash
RUN apk update && apk add --no-cache nginx nginx-mod-rtmp ffmpeg bash

# Tạo thư mục đồng bộ đường dẫn
RUN mkdir -p /run/nginx/stream

# Copy cấu hình vào container
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /entrypoint.sh

# Dùng lệnh sed (gốc của Linux) để tự động xóa sạch ký tự \r của Windows nếu có
RUN sed -i 's/\r$//' /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Mở port mạng
EXPOSE 80 1935

# 🔥 THAY ĐỔI QUAN TRỌNG NHẤT: Gọi đích danh 'sh' để chạy file, né sạch lỗi format error
ENTRYPOINT ["sh", "/entrypoint.sh"]
