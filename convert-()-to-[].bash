#!/bin/bash
for f in *; do
  newname=$(echo "$f" | sed 's/(\([^)]*\))/[\1]/')
  [ "$f" != "$newname" ] && mv -- "$f" "$newname"
done

