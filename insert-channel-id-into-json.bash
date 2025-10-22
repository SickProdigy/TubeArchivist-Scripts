#!/bin/bash

for f in *.info.json; do
  [ -f "$f" ] || continue

  # Extract the uploader_url line safely using jq if available
  if command -v jq >/dev/null 2>&1; then
    uploader_url=$(jq -r '.uploader_url // empty' "$f")
  else
    # fallback to grep/sed if jq not present
    uploader_url=$(grep -oP '(?<="uploader_url": ")[^"]+' "$f")
  fi

  # Skip if no uploader_url found
  [ -z "$uploader_url" ] && { echo "No uploader_url in $f, skipping."; continue; }

  # Extract the channel ID (everything after '/channel/')
  channel_id=$(echo "$uploader_url" | sed -n 's|.*/channel/\([^/"]*\).*|\1|p')

  # Skip if extraction failed
  [ -z "$channel_id" ] && { echo "No channel ID found in $f, skipping."; continue; }

  # Update JSON with channel_id field
  if command -v jq >/dev/null 2>&1; then
    tmpfile=$(mktemp)
    jq --arg cid "$channel_id" '.channel_id = $cid' "$f" > "$tmpfile" && mv "$tmpfile" "$f"
    echo "Inserted channel_id into $f: $channel_id"
  else
    # Simple sed fallback (assumes JSON is flat)
    sed -i "/\"uploader_url\"/a \ \ \"channel_id\": \"$channel_id\"," "$f"
    echo "Inserted channel_id into $f (using sed): $channel_id"
  fi
done
