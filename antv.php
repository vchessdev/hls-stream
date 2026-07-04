<?php
/**
 * ANTV Router - Điều phối luồng: Lịch phát -> World Cup -> Fallback ABR
 */

error_reporting(0);
ini_set('display_errors', 0);
date_default_timezone_set('Asia/Ho_Chi_Minh');

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: *');
header('Access-Control-Max-Age: 86400');
header('Vary: Origin');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    header('HTTP/1.1 200 OK');
    exit();
}

header('Cache-Control: max-age=5, must-revalidate');
header('Expires: ' . gmdate('D, d M Y H:i:s', time() + 5) . ' GMT');

$VTV6_URL      = 'https://devda.undo.it/Stream/index.php?id=vtv6&ext=.m3u8';
$FALLBACK_URL  = 'https://xeno.env.pm/play.php/index.m3u8';
$EPG_API_URL   = 'https://vnepg.site/api/schedule/vtv6hd';
$SCHEDULE_FILE = __DIR__ . '/schedule.json';
$LOG_DIR       = __DIR__ . '/Log';

function load_schedules($file_path)
{
    if (!file_exists($file_path)) {
        return [];
    }

    $content = @file_get_contents($file_path);
    if ($content === false) {
        return [];
    }

    $data = json_decode($content, true);
    return is_array($data) ? $data : [];
}

function write_log($message)
{
    global $LOG_DIR;
    if (!is_dir($LOG_DIR)) {
        @mkdir($LOG_DIR, 0755, true);
    }
    @error_log('[' . date('Y-m-d H:i:s') . '] ' . $message . "\n", 3, $LOG_DIR . '/antv.log');
}

function normalize_day_key($day)
{
    $day = trim(strtolower($day));
    if ($day === '') {
        return 'all';
    }

    $map = [
        'sunday' => 'sun',
        'monday' => 'mon',
        'tuesday' => 'tue',
        'wednesday' => 'wed',
        'thursday' => 'thu',
        'friday' => 'fri',
        'saturday' => 'sat',
        'sun' => 'sun',
        'mon' => 'mon',
        'tue' => 'tue',
        'wed' => 'wed',
        'thu' => 'thu',
        'fri' => 'fri',
        'sat' => 'sat',
        'all' => 'all',
    ];

    return $map[$day] ?? $day;
}

function day_matches($schedule_day, $current_time)
{
    $schedule_day = normalize_day_key($schedule_day);
    if ($schedule_day === 'all') {
        return true;
    }

    $current_date = date('Y-m-d', $current_time);
    if ($schedule_day === $current_date) {
        return true;
    }

    $current_day = strtolower(date('D', $current_time));
    if ($schedule_day === $current_day) {
        return true;
    }

    return false;
}

function parse_time_string($time_string)
{
    $time_string = trim($time_string);
    if (preg_match('/^\d{1,2}:\d{2}(?::\d{2})?$/', $time_string)) {
        if (substr_count($time_string, ':') === 1) {
            $time_string .= ':00';
        }
        return $time_string;
    }
    return false;
}

function is_world_cup_on($api_url)
{
    global $LOG_DIR;
    $cache_file = $LOG_DIR . '/wc_cache.txt';

    if (!is_dir($LOG_DIR)) {
        @mkdir($LOG_DIR, 0755, true);
    }

    if (file_exists($cache_file) && (time() - filemtime($cache_file) < 300)) {
        return @file_get_contents($cache_file) === '1';
    }

    if (!function_exists('curl_init')) {
        return false;
    }

    $ch = curl_init($api_url);
    curl_setopt_array($ch, [
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_TIMEOUT => 5,
        CURLOPT_CONNECTTIMEOUT => 5,
        CURLOPT_SSL_VERIFYPEER => false,
        CURLOPT_USERAGENT => 'Mozilla/5.0',
    ]);

    $response = curl_exec($ch);
    $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);

    if ($http_code !== 200 || $response === false) {
        @file_put_contents($cache_file, '0');
        return false;
    }

    $json = json_decode($response, true);
    if (!is_array($json)) {
        @file_put_contents($cache_file, '0');
        return false;
    }

    $events = [];
    if (isset($json['data']['program']) && is_array($json['data']['program'])) {
        $events = $json['data']['program'];
    } elseif (isset($json['data']) && is_array($json['data'])) {
        $events = $json['data'];
    } elseif (isset($json['events']) && is_array($json['events'])) {
        $events = $json['events'];
    }

    $keywords = ['world cup', 'worldcup', 'wc', 'vòng loại', 'bán kết', 'chung kết'];
    $active = false;

    foreach ($events as $event) {
        $haystack = strtolower(json_encode($event, JSON_UNESCAPED_UNICODE));
        foreach ($keywords as $keyword) {
            if (stripos($haystack, $keyword) !== false) {
                $active = true;
                break 2;
            }
        }
    }

    @file_put_contents($cache_file, $active ? '1' : '0');
    return $active;
}

write_log('=== Request Started ===');

$schedules = load_schedules($SCHEDULE_FILE);
$now = time();
$target_url = '';

foreach ($schedules as $schedule) {
    $day = $schedule['day'] ?? 'all';
    $start = $schedule['start_time'] ?? '';
    $end = $schedule['end_time'] ?? '';
    $url = $schedule['m3u8_url'] ?? '';

    if (empty($start) || empty($end) || empty($url)) {
        continue;
    }

    if (!day_matches($day, $now)) {
        continue;
    }

    $start_time = parse_time_string($start);
    $end_time = parse_time_string($end);
    if ($start_time === false || $end_time === false) {
        continue;
    }

    $date = date('Y-m-d', $now);
    $start_ts = strtotime($date . ' ' . $start_time);
    $end_ts = strtotime($date . ' ' . $end_time);

    if ($end_ts <= $start_ts) {
        $end_ts += 86400;
    }

    if ($now >= $start_ts && $now < $end_ts) {
        $target_url = $url;
        write_log('✓ Active schedule matched: ' . ($schedule['name'] ?? $url));
        break;
    }

    if ($now < $start_ts) {
        $prev_start_ts = $start_ts - 86400;
        $prev_end_ts = $end_ts - 86400;
        if ($now >= $prev_start_ts && $now < $prev_end_ts) {
            $target_url = $url;
            write_log('✓ Active overnight schedule carried from yesterday: ' . ($schedule['name'] ?? $url));
            break;
        }
    }
}

if (empty($target_url) && is_world_cup_on($EPG_API_URL)) {
    $target_url = $VTV6_URL;
    write_log('✓ World Cup active -> VTV6 redirect');
}

if (empty($target_url)) {
    $target_url = $FALLBACK_URL;
    write_log('✓ No schedule or World Cup -> fallback to ABR playlist');
}

write_log('Redirecting to: ' . $target_url);
header('Location: ' . $target_url, true, 302);
exit();
