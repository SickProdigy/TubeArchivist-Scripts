#!/bin/bash
shopt -s nullglob

for f in *.mp4 *.mkv *.mov *.avi; do
  [ -f "$f" ] || continue

  base="${f%.*}"
  ext="${f##*.}"

  # Match: date - number - id - rest
  # Example: 20140720 - 097 - oaHzqMgnI70 - TempleOS - God for Larry Page 7_20 K
  if [[ "$base" =~ ^([^[:space:]]+)[[:space:]]*-[[:space:]]*([^[:space:]]+)[[:space:]]*-[[:space:]]*([A-Za-z0-9_-]+)[[:space:]]*-[[:space:]]*(.*)$ ]]; then
    datepart="${BASH_REMATCH[1]}"
    numpart="${BASH_REMATCH[2]}"
    id="${BASH_REMATCH[3]}"
    rest="${BASH_REMATCH[4]}"

    newname="${datepart} - ${numpart} - ${rest} [${id}].${ext}"

    echo "Would rename: $f → $newname"
    # Comment next line to test without renaming
    mv -i -- "$f" "$newname"
  else
    echo "Skipping (pattern mismatch): $f"
  fi
done
