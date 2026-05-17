#!/usr/bin/env bash
set -euo pipefail

# Usage: resolve-thread.sh <thread_id>
thread_id="$1"

# shellcheck disable=SC2016
gql_mutation='mutation($threadId: ID!) {
  resolveReviewThread(input: { threadId: $threadId }) {
    thread {
      isResolved
    }
  }
}'

gh api graphql \
  -f query="$gql_mutation" \
  -f threadId="$thread_id"
echo "Thread resolved."
