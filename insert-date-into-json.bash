#!/bin/bash

for f in *.info.json; do
  [ -f "$f" ] || continue

  # Extract title without extension
  title="${f%.info.json}"
  # Remove trailing ID if present
  title="${title% \[*\]}"

  # Extract the date at the beginning of the title (YYYYMMDD)
  if [[ "$title" =~ ^([0-9]{8}) ]]; then
    upload_date="${BASH_REMATCH[1]}"
  else
    echo "No date found in $f, skipping."
    continue
  fi

  # Update JSON upload_date
  if command -v jq >/dev/null 2>&1; then
    tmpfile=$(mktemp)
    jq --arg date "$upload_date" '.upload_date = $date' "$f" > "$tmpfile" && mv "$tmpfile" "$f"
    echo "Updated upload_date in $f: $upload_date"
  else
    # Simple sed fallback (only for simple JSON)
    sed -i "s/\"upload_date\": *\"\"/\"upload_date\": \"$upload_date\"/" "$f"
    echo "Updated upload_date in $f: $upload_date (using sed)"
  fi
done
