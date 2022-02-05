# Google Fonts Downloader

Script for downloading font files from [Google fonts](https://fonts.google.com/).

Google fonts use browser detection to serve the best font files for one's browser.
This script downloads most of the font types with CSS files
by cycling through different user-agents.

Supported formats:
- ttf
- eot
- svg
- woff
- woff2
- woff2-unicode-range

This script doesn't merge downloaded CSS files. That is up to you what
to do with them.
## Prerequisites

To run this script you need any POSIX compliant shell like
bash, dash or zsh and `curl`.

## Usage

```
google-fonts-downloader.sh [options] URL

Fetch font files from Google Fonts

Options:
    -f, --formats
            Formats to download (default: "woff,woff2,woff2-unicode-range")

    -o, --output
            Output directory (default: ./fonts)
```

## Example

The command:

```sh
./google-fonts-downloader.sh -f woff,woff2 'https://fonts.googleapis.com/css2?family=Montserrat:ital@0;1&family=Roboto:wght@100&display=swap'
```

Will output following files:
```
fonts
├── woff
│   ├── JTUFjIg1_i6t8kCHKm459Wx7xQYXK0vOoz6jq6R9aXw.woff
│   ├── JTUHjIg1_i6t8kCHKm4532VJOt5-QNFgpCtr6Ew9.woff
│   ├── KFOkCnqEu92Fr1MmgWxM.woff
│   └── style.css
└── woff2
    ├── JTUFjIg1_i6t8kCHKm459Wx7xQYXK0vOoz6jq6R9aXo.woff2
    ├── JTUHjIg1_i6t8kCHKm4532VJOt5-QNFgpCtr6Ew7.woff2
    ├── KFOkCnqEu92Fr1MmgWxK.woff2
    └── style.css
```