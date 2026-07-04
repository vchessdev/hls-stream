#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

PLAYLIST_FILE="playlist.m3u8"
LOGO="logo.png"
OUT_BASE="hoanthanh"
OUT_1080="$OUT_BASE/1080p"
OUT_360="$OUT_BASE/360p"
LOG_FILE="encode_log.txt"

if [ ! -f "$PLAYLIST_FILE" ]; then
  echo "ERROR: playlist.m3u8 không tồn tại trong thư mục hiện tại." >&2
  exit 1
fi

if [ ! -f "$LOGO" ]; then
  echo "ERROR: logo.png không tồn tại trong thư mục hiện tại." >&2
  exit 1
fi

mapfile -t urls < <(grep -Eo '^https?://[^ ]+\.ts' "$PLAYLIST_FILE")
if [ ${#urls[@]} -eq 0 ]; then
  echo "ERROR: Không tìm thấy URL .ts trong playlist.m3u8." >&2
  exit 1
fi

rm -rf "$OUT_1080" "$OUT_360"
mkdir -p "$OUT_1080" "$OUT_360"
rm -f "$LOG_FILE"

count=0
for url in "${urls[@]}"; do
  name=$(printf "finished_%03d.ts" "$count")
  echo "[$((count+1))/${#urls[@]}] $name"

  ffmpeg -y -protocol_whitelist "file,crypto,data,http,https,tls,tcp" -fflags +genpts \
    -i "$url" -i "$LOGO" \
    -filter_complex "[0:v]scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2,setsar=1[bg];[1:v]scale=80:-1[l];[bg][l]overlay=main_w-overlay_w-10:main_h-overlay_h-10:format=auto,fps=30[outv]" \
    -map "[outv]" -map "0:a?" \
    -c:v libx264 -preset veryfast -profile:v main -level 4.0 -pix_fmt yuv420p -b:v 2800k -maxrate 3200k -bufsize 5600k -g 120 -keyint_min 120 \
    -c:a aac -b:a 128k -ar 44100 \
    "$OUT_1080/$name" >> "$LOG_FILE" 2>&1

  ffmpeg -y -protocol_whitelist "file,crypto,data,http,https,tls,tcp" -fflags +genpts \
    -i "$url" -i "$LOGO" \
    -filter_complex "[0:v]scale=640:360:force_original_aspect_ratio=decrease,pad=640:360:(ow-iw)/2:(oh-ih)/2,setsar=1[bg];[1:v]scale=110:-1[l];[bg][l]overlay=main_w-overlay_w-10:main_h-overlay_h-10:format=auto,fps=24[outv]" \
    -map "[outv]" -map "0:a?" \
    -c:v libx264 -preset veryfast -profile:v baseline -level 3.1 -pix_fmt yuv420p -b:v 600k -maxrate 750k -bufsize 1500k -g 96 -keyint_min 96 \
    -c:a aac -b:a 96k -ar 44100 \
    "$OUT_360/$name" >> "$LOG_FILE" 2>&1

  count=$((count+1))
done

echo "Hoàn thành: ${#urls[@]} segment đã được tạo trong $OUT_1080 và $OUT_360."
