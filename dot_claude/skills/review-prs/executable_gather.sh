#!/usr/bin/env bash
set -euo pipefail

echo "=== REVIEW REQUESTS ==="
review_requests=$(gh search prs --review-requested=@me --state=open \
  --json url,title,author,repository --limit 20 2>/dev/null) || review_requests="[]"

count=$(echo "$review_requests" | jq 'length')
if [ "$count" -eq 0 ]; then
  echo "(none)"
else
  echo "$review_requests" | jq -r '
    .[] | "TITLE: \(.title)\nURL: \(.url)\nAUTHOR: \(.author.login)\nREPO: \(.repository.nameWithOwner)\n---"
  '
fi

echo ""
echo "=== MY OPEN PRS ==="
my_prs=$(gh search prs --author=@me --state=open \
  --json url,title,number,repository,isDraft --limit 20 2>/dev/null) || my_prs="[]"

pr_count=$(echo "$my_prs" | jq 'length')
if [ "$pr_count" -eq 0 ]; then
  echo "(none)"
  exit 0
fi

# shellcheck disable=SC2016
gql_query='query($owner: String!, $repo: String!, $number: Int!) {
  repository(owner: $owner, name: $repo) {
    pullRequest(number: $number) {
      reviewDecision
      reviewThreads(first: 50) {
        nodes {
          id
          isResolved
          comments(first: 10) {
            nodes {
              databaseId
              body
              author { login }
              path
              originalLine
            }
          }
        }
      }
    }
  }
}'

while IFS= read -r pr; do
  title=$(echo "$pr" | jq -r '.title')
  url=$(echo "$pr" | jq -r '.url')
  number=$(echo "$pr" | jq -r '.number')
  repo=$(echo "$pr" | jq -r '.repository.nameWithOwner')
  is_draft=$(echo "$pr" | jq -r '.isDraft')
  owner="${repo%%/*}"
  repo_name="${repo#*/}"

  printf '\n=== PR START ===\n'
  printf 'TITLE: %s\n' "$title"
  printf 'URL: %s\n' "$url"
  printf 'NUMBER: %s\n' "$number"
  printf 'REPO: %s\n' "$repo"
  printf 'DRAFT: %s\n' "$is_draft"

  printf '\n-- CHECKS --\n'
  gh pr checks "$url" 2>/dev/null || printf '(no checks available)\n'

  printf '\n-- REVIEW DATA --\n'
  gh api graphql \
    -f owner="$owner" \
    -f repo="$repo_name" \
    -F number="$number" \
    -f query="$gql_query" 2>/dev/null | jq -r '
      "REVIEW_DECISION: " + (.data.repository.pullRequest.reviewDecision // "NONE"),
      (
        [.data.repository.pullRequest.reviewThreads.nodes[] | select(.isResolved == false)] as $threads |
        "UNRESOLVED_THREADS: " + ($threads | length | tostring),
        (
          $threads[] |
          "THREAD_ID: " + .id,
          "FILE: " + (.comments.nodes[0].path // "(general)") + ":" + ((.comments.nodes[0].originalLine // 0) | tostring),
          "REPLY_TO_ID: " + (.comments.nodes[-1].databaseId | tostring),
          "COMMENTS:",
          (.comments.nodes[] | "  [" + .author.login + "]: " + .body),
          "END_THREAD"
        )
      )
    ' || printf '(could not fetch review data)\n'

  printf '\n=== PR END ===\n'
done < <(echo "$my_prs" | jq -c '.[]')
