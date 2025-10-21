#!/bin/bash

for f in *.info.json; do
  [ -f "$f" ] || continue

  # Extract title: remove .info.json and remove ID in brackets at the end
  title="${f%.info.json}"          # Remove extension
  title="${title% \[*\]}"          # Remove trailing [ID]

  # Update JSON title only
  if command -v jq >/dev/null 2>&1; then
    tmpfile=$(mktemp)
    jq --arg newtitle "$title" '.title = $newtitle' "$f" > "$tmpfile" && mv "$tmpfile" "$f"
    echo "Updated title in $f: $title"
  else
    # Simple sed fallback
    sed -i "s/\"title\": *\"\"/\"title\": \"$title\"/" "$f"
    echo "Updated title in $f: $title (using sed)"
  fi
done
