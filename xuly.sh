#!/bin/bash

QUALITY_CONFIGS=(
    "1080p:1920x1080:4500k:aac"
    "720p:1280x720:2500k:aac"
    "360p:640x360:800k:aac"
)

BASE_URL="https://xeno.env.pm/stream"
SEGMENT_DIR="."
OUTPUT_DIR="./hls"
LOGO="./logo.png"

mkdir -p "$OUTPUT_DIR"

# 1️⃣ Generate Master Playlist
cat > "$OUTPUT_DIR/master.m3u8" << 'EOF'
#EXTM3U
#EXT-X-VERSION:3
#EXT-X-INDEPENDENT-SEGMENTS
EOF

for config in "${QUALITY_CONFIGS[@]}"; do
    IFS=':' read -r quality res bitrate audio <<< "$config"
    width=$(echo $res | cut -d'x' -f1)
    height=$(echo $res | cut -d'x' -f2)
    
    cat >> "$OUTPUT_DIR/master.m3u8" << EOF
#EXT-X-STREAM-INF:BANDWIDTH=${bitrate}000,AVERAGE-BANDWIDTH=$((bitrate*800/1000))000,RESOLUTION=${res},CODECS="avc1.640028,${audio}"
${quality}/playlist.m3u8
EOF
done

# 2️⃣ Generate variant playlists + encode segments with logo
for config in "${QUALITY_CONFIGS[@]}"; do
    IFS=':' read -r quality res bitrate audio <<< "$config"
    width=$(echo $res | cut -d'x' -f1)
    height=$(echo $res | cut -d'x' -f2)
    
    QUAL_DIR="$OUTPUT_DIR/$quality"
    mkdir -p "$QUAL_DIR"
    
    # Calculate logo size (10% of video width)
    logo_width=$((width / 10))
    logo_height=$((height / 10))
    
    # Encode segments with logo
    for i in {0..46}; do
        input_seg=$(printf "${SEGMENT_DIR}/finished_%03d.ts" $i)
        output_seg=$(printf "${QUAL_DIR}/segment_%03d.ts" $i)
        
        [ ! -f "$input_seg" ] && continue
        
        echo "[$quality] Encoding segment $i with logo..."
        
        if [ "$quality" = "1080p" ]; then
            # 1080p: copy video + overlay logo
            ffmpeg -i "$input_seg" \
                -i "$LOGO" \
                -filter_complex "[0:v][1:v]overlay=W-w-20:20:enable='between(t\,0\,100)'" \
                -c:v libx264 -preset ultrafast \
                -c:a copy "$output_seg" -y -loglevel error 2>/dev/null
        else
            # Scale + logo
            ffmpeg -i "$input_seg" \
                -i "$LOGO" \
                -filter_complex "[0:v]scale=${width}:${height}[scaled];[scaled][1:v]overlay=W-w-20:20:enable='between(t\,0\,100)'" \
                -c:v libx264 -preset ultrafast -b:v ${bitrate}k \
                -c:a aac -b:a 128k "$output_seg" -y -loglevel error 2>/dev/null
        fi
    done
    
    # Create variant playlist
    cat > "${QUAL_DIR}/playlist.m3u8" << EOF2
#EXTM3U
#EXT-X-VERSION:3
#EXT-X-TARGETDURATION:5
#EXT-X-MEDIA-SEQUENCE:0
EOF2
    
    for i in {0..46}; do
        seg=$(printf "segment_%03d.ts" $i)
        [ ! -f "${QUAL_DIR}/${seg}" ] && continue
        
        echo "#EXTINF:4.0," >> "${QUAL_DIR}/playlist.m3u8"
        echo "${BASE_URL}/${quality}/${seg}" >> "${QUAL_DIR}/playlist.m3u8"
    done
    
    echo "#EXT-X-ENDLIST" >> "${QUAL_DIR}/playlist.m3u8"
done

echo "✅ HLS streaming with logo complete!"
echo "📌 Master playlist: $BASE_URL/master.m3u8"
