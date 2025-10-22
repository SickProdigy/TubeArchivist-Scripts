#!/bin/bash
template="Example.info.json"

# Verify template exists
if [ ! -f "$template" ]; then
  echo "Error: $template not found."
  exit 1
fi

# Collect all matching video files safely
for f in *.mp4 *.mkv *.mov *.avi; do
  # Skip if no matching files
  [ -e "$f" ] || continue
  [ -f "$f" ] || continue

  base="${f%.*}"              # Remove extension
  target="${base}.info.json"  # Construct new name

  cp -- "$template" "$target"
  echo "Created: $target"
done
