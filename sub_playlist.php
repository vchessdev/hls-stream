<?php
/**
 * sub_playlist.php - Sliding Window Live Playlist (Direct RAW GitHub URLs)
 */

error_reporting(0);
ini_set('display_errors', 0);

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: *');
header('Access-Control-Max-Age: 86400');
header('Vary: Origin');
header('Content-Type: application/vnd.apple.mpegurl');
header('Cache-Control: max-age=2, must-revalidate');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    header('HTTP/1.1 200 OK');
    exit();
}

$quality = $_GET['quality'] ?? '1080p';
$allowed_qualities = ['1080p', '360p'];
if (!in_array($quality, $allowed_qualities, true)) {
    $quality = '1080p';
}

$segment_duration = 4;
$total_segments = 95;
$github_base = 'https://raw.githubusercontent.com/vchessdev/hls-stream/main/hoanthanh';

$time_now = time();
$media_sequence = intdiv($time_now, $segment_duration);
$current_index = $media_sequence % $total_segments;

$target_duration = $segment_duration + 1;

echo "#EXTM3U\n";
echo "#EXT-X-VERSION:3\n";
echo "#EXT-X-TARGETDURATION:$target_duration\n";
echo "#EXT-X-MEDIA-SEQUENCE:$media_sequence\n\n";

for ($i = 0; $i < 3; $i++) {
    $idx = sprintf('%03d', ($current_index + $i) % $total_segments);
    echo "#EXTINF:{$segment_duration}.000000,\n";
    echo "{$github_base}/{$quality}/finished_{$idx}.ts\n";
}
exit();
