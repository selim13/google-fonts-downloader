#!/bin/sh

set -ue

FORMATS="woff,woff2,woff2-unicode-range"
OUTPUT="./fonts"

usage() {
    printf "%s\n" \
        "google-fonts-downloader.sh [options] URL" \
        "" \
        "Fetch font files from Google Fonts"

    printf "\n%s\n" "Options:"
    printf "\t%s\n\t\t%s\n\n" \
        "-f, --formats" "Formats to download (default: \"$FORMATS\")" \
        "-o, --output" "Output directory (default: $OUTPUT)"
}

error() {
    >&2 printf "%s\n" "$*"
}

agent() {
    case "$1" in
        ttf)
            printf "%s" "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_8; de-at) AppleWebKit/533.21.1 (KHTML, like Gecko) Version/5.0.5 Safari/533.21.1"
            ;;
        svg)
            printf "%s" "Mozilla/5.0(iPad; U; CPU iPhone OS 3_2 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B314 Safari/531.21.10gin_lib.cc"
            ;;
        eot)
            printf "%s" "Mozilla/5.0 (Windows; U; MSIE 7.0; Windows NT 6.0; en-US)"
            ;;
        woff)
            printf "Mozilla/5.0 (compatible, MSIE 11, Windows NT 6.3; Trident/7.0; rv:11.0) like Gecko"
            ;;
        woff2)
            printf "%s" "Mozilla/5.0 (Windows NT 6.3; rv:39.0) Gecko/20100101 Firefox/39.0"
            ;;
        woff2-unicode-range)
            printf "%s" "Mozilla/5.0 (Windows NT 6.3; rv:44.0) Gecko/20100101 Firefox/44.0"
            ;;
    esac
}

while [ "$#" -gt 0 ]; do
    case "$1" in
    -h | --help)
        usage
        exit
        ;;
    -f | --formats)
        FORMATS="$2"
        shift 2
        ;;
    -o | --output)
        OUTPUT="$2"
        shift 2
        ;;
    *)
        if [ "$#" -eq 1 ]; then
            URL="$1"
            shift 1
        else
            error "Unknown option $1"
            usage
            exit 1
        fi
        ;;
    esac
done

if [ -z "$URL" ]; then
    error "No URL secified"
    usage
    exit 1
fi

IFS=","
for F in $FORMATS; do
    if [ -z "$(agent $F)" ]; then
        error "Unsuported font format: $F"
        exit 1
    fi
done
unset IFS

IFS=","
for F in $FORMATS; do
    AGENT="$(agent $F)"
    DIR="$OUTPUT/$F"
    STYLE_FILE="$DIR/style.css"

    mkdir -p "$DIR"

    curl --silent --fail --location --user-agent "$AGENT" --output "$STYLE_FILE" "$URL"

    cat "$STYLE_FILE" | grep -o 'https://[^)]*' | while read -r FONT_URL; do
        FILE="$(basename $FONT_URL)"
        printf "%s\n" "Fetching $FILE"
        curl --silent --location --output "$DIR/$FILE" "$FONT_URL"
    done
done
unset IFS