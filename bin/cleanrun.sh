#!/bin/bash

COLOR_CYAN="\e[36m"
COLOR_RESET="\e[0m"

REPO="harilvfs/carch"
BINARY_NAME="core.sh"
TEMP_FILE=$(mktemp /tmp/$BINARY_NAME.XXXXXX)

echo "Fetching the latest release information..."
LATEST_RELEASE=$(curl -s "https://api.github.com/repos/$REPO/releases/latest")

if [ $? -ne 0 ]; then
    echo "Failed to fetch the latest release information."
    exit 1
fi

DOWNLOAD_URL=$(echo "$LATEST_RELEASE" | grep -oP '"tag_name": "\K[^"]*' | xargs -I {} echo "https://github.com/$REPO/releases/download/{}/$BINARY_NAME")

echo "Downloading the latest release binary from $DOWNLOAD_URL..."
curl -fsL -o "$TEMP_FILE" "$DOWNLOAD_URL"

if [ $? -ne 0 ]; then
    echo "Failed to download the binary."
    exit 1
fi

if [ ! -s "$TEMP_FILE" ]; then
    echo "Downloaded file is empty. Please check the URL and binary name."
    exit 1
fi

chmod +x "$TEMP_FILE"

"$TEMP_FILE"

rm -f "$TEMP_FILE"

echo -e "${COLOR_CYAN}See You...${COLOR_RESET}"

