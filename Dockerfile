FROM alpine:3.18

# Cài đặt Nginx, module RTMP, FFmpeg, bash và thêm công cụ dos2unix
RUN apk update && apk add --no-cache nginx nginx-mod-rtmp ffmpeg bash dos2unix

# Tạo thư mục đồng bộ đường dẫn
RUN mkdir -p /run/nginx/stream

# Copy cấu hình vào container
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /entrypoint.sh

# ÉP SỬA ĐỊNH DẠNG FILE SANG CHUẨN LINUX (Bao ăn chắc)
RUN dos2unix /entrypoint.sh

# Cấp quyền chạy cho file script
RUN chmod +x /entrypoint.sh

# Mở port mạng
EXPOSE 80 1935

# Chạy script khi khởi động
ENTRYPOINT ["/entrypoint.sh"]
