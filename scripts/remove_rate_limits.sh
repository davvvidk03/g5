#!/bin/bash

cd /workspaces/g5

# Remove RATE_LIMITS.md
git rm RATE_LIMITS.md

# Commit the changes
git add src/openai_helper.py
git commit -m "Remove all rate limiting functionality

- Removed retry logic with exponential backoff
- Removed RATE_LIMITS.md documentation
- Simplified error handling to direct try-catch
- API calls now fail immediately instead of retrying"

echo "Rate limiting removed successfully!"
