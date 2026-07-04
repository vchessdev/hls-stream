<?php
/**
 * play.php - HLS Master Playlist (Adaptive Bitrate 3 qualities)
 */

error_reporting(0);
ini_set('display_errors', 0);

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: *');
header('Access-Control-Max-Age: 86400');
header('Vary: Origin');
header('Content-Type: application/vnd.apple.mpegurl');
header('Cache-Control: max-age=5, must-revalidate');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    header('HTTP/1.1 200 OK');
    exit();
}

$base_url = 'https://xeno.env.pm';

echo "#EXTM3U\n";
echo "#EXT-X-VERSION:3\n";
echo "#EXT-X-INDEPENDENT-SEGMENTS\n\n";

// 1080p - Highest Bitrate
echo "#EXT-X-STREAM-INF:BANDWIDTH=4500000,AVERAGE-BANDWIDTH=4000000,RESOLUTION=1920x1080,FRAME-RATE=30.000,CODECS=\"avc1.640028,mp4a.40.2\"\n";
echo $base_url . "/sub_playlist.php?quality=1080p\n\n";

// 720p - Medium Bitrate
echo "#EXT-X-STREAM-INF:BANDWIDTH=2500000,AVERAGE-BANDWIDTH=2000000,RESOLUTION=1280x720,FRAME-RATE=30.000,CODECS=\"avc1.4d401f,mp4a.40.2\"\n";
echo $base_url . "/sub_playlist.php?quality=720p\n\n";

// 360p - Low Bitrate
echo "#EXT-X-STREAM-INF:BANDWIDTH=800000,AVERAGE-BANDWIDTH=600000,RESOLUTION=640x360,FRAME-RATE=25.000,CODECS=\"avc1.4d001e,mp4a.40.2\"\n";
echo $base_url . "/sub_playlist.php?quality=360p\n";

exit();