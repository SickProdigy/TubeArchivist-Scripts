#!/bin/bash

# Loop over all .info.json files in the current directory
for f in *.info.json; do
  [ -f "$f" ] || continue  # skip if no files

  # Extract ID from filename: match [ID] at the end (before .info.json)
  id=$(echo "$f" | sed -n 's/.*\[\([^]]*\)\]\.info\.json/\1/p')

  # If no ID found, skip this file
  [ -z "$id" ] && continue

  # Use 'jq' to safely update the "id" field
  if command -v jq >/dev/null 2>&1; then
    tmpfile=$(mktemp)
    jq --arg newid "$id" '.id = $newid' "$f" > "$tmpfile" && mv "$tmpfile" "$f"
    echo "Updated $f with id: $id"
  else
    # If jq not installed, fallback with sed (assumes simple JSON format)
    sed -i "s/\"id\": *\"\"/\"id\": \"$id\"/" "$f"
    echo "Updated $f with id: $id (using sed)"
  fi
done
