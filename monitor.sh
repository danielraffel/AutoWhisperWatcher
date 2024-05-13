#!/bin/bash

FOLDER_PATH="/path/to/folder/to/watch/"

open_with_macwhisper() {
    osascript -e "tell application \"MacWhisper\" to open \"$1\""
}

export -f open_with_macwhisper

fswatch -o "$FOLDER_PATH" | while read f
do
  find "$FOLDER_PATH" -type f -print0 | xargs -0 -I {} bash -c 'open_with_macwhisper "$@"' _ {}
done
