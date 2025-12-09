#!/usr/bin/env bash
# Simple script to create GitHub Issues from `BACKLOG.csv` using the GitHub CLI (`gh`).
# Usage: `scripts/create_issues.sh` (requires `gh` authenticated and repository remote set)

set -euo pipefail

CSV_FILE="$(dirname "$0")/../BACKLOG.csv"
if [ ! -f "$CSV_FILE" ]; then
  echo "ERROR: $CSV_FILE not found"
  exit 1
fi

echo "Reading $CSV_FILE and creating issues (one per row). Press Ctrl+C to cancel."

# Ensure the 'backlog' label exists (create if missing)
if ! gh label view backlog >/dev/null 2>&1; then
  echo "Label 'backlog' not found — creating it."
  gh label create backlog --color "0e8a16" --description "Sprint backlog tasks" || {
    echo "Warning: failed to create label 'backlog'. Issues will be created without that label." >&2
    USE_LABEL=false
  }
else
  USE_LABEL=true
fi

# Skip header line, parse CSV roughly (fields don't contain commas in our export)
tail -n +2 "$CSV_FILE" | while IFS=, read -r id task owner status issue_link; do
  # Trim whitespace
  id=$(echo "$id" | xargs)
  task=$(echo "$task" | xargs)
  owner=$(echo "$owner" | xargs)
  status=$(echo "$status" | xargs)

  title="$id: $task"
  body="Owner: $owner\nStatus: $status\n\nSource: BACKLOG.md"

  echo "Creating issue: $title"
  if [ "${USE_LABEL:-true}" = true ]; then
    gh issue create --title "$title" --body "$body" --label backlog || {
      echo "Failed to create issue for row $id. Ensure 'gh' is installed and authenticated, and you have repo access." >&2
      exit 2
    }
  else
    gh issue create --title "$title" --body "$body" || {
      echo "Failed to create issue for row $id. Ensure 'gh' is installed and authenticated, and you have repo access." >&2
      exit 2
    }
  fi
  # Small sleep to avoid rate-limiting
  sleep 0.3
done

echo "All done."
