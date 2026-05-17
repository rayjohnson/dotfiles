#!/usr/bin/env bash
set -euo pipefail

mapfile -t paths < <(chezmoi status | awk '{print $2}')

if [[ ${#paths[@]} -eq 0 ]]; then
  echo "No modified files."
  exit 0
fi

echo "MODIFIED FILES: ${paths[*]}"
echo ""

for rel in "${paths[@]}"; do
  file="$HOME/$rel"
  echo "### $file"
  diff -u <(chezmoi cat "$file" 2>/dev/null) "$file" || true
  echo ""
done
