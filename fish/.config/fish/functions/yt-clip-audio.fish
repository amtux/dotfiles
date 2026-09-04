function yt-clip-audio --description "clip yt-audio between start and end times. Usage: yt-clip-audio URL START END"
    if test (count $argv) -lt 3
        echo "Usage: yt-clip-audio URL START END  (times like 0:30 or 1:23:45)" >&2
        return 1
    end
    set -l url $argv[1]
    set -l start $argv[2]
    set -l end $argv[3]
    yt-dlp --extract-audio --audio-quality=0 -f ba --add-metadata --embed-thumbnail \
        --downloader ffmpeg --downloader-args "ffmpeg_i:-ss $start -to $end" \
        $url
end
