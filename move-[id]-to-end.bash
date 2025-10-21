#!/bin/bash
for f in *; do
  # Skip directories
  [ -f "$f" ] || continue

  # Extract the ID inside () or []
  id=$(echo "$f" | sed -n 's/.*[([]\([^])]*\)[])].*/\1/p')

  # If there's no ID, skip
  [ -z "$id" ] && continue

  # Remove the ID portion (and any leftover extra spaces)
  base=$(echo "$f" | sed 's/[([][^])]*[])]//g' | sed 's/  / /g' | sed 's/ *$//')

  # Separate name and extension
  name="${base%.*}"
  ext="${base##*.}"

  # Rebuild new name (handle files with and without extensions)
  if [ "$name" != "$ext" ]; then
    newname="${name} [${id}].${ext}"
  else
    newname="${base} [${id}]"
  fi

  # Only rename if different
  [ "$f" != "$newname" ] && mv -- "$f" "$newname"
done
