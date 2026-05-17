#!/usr/bin/env bash
set -euo pipefail

# Usage: reply-thread.sh <owner> <repo> <pr_number> <comment_id> <message_file>
owner="$1"
repo="$2"
pr_number="$3"
comment_id="$4"
message_file="$5"

message=$(cat "$message_file")
gh api "repos/$owner/$repo/pulls/$pr_number/comments/$comment_id/replies" \
  -X POST -f body="$message"
echo "Reply posted."
