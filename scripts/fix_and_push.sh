#!/bin/bash

cd /workspaces/g5

# Try force push with lease (safer than force push)
echo "Attempting force push with lease..."
git push --force-with-lease origin feature/rate-limiting-and-improvements-1765509756

# If that fails, create a new branch
if [ $? -ne 0 ]; then
    echo "Force push failed. Creating new branch..."
    NEW_BRANCH="feature/rate-limiting-improvements-v2"
    git checkout -b "$NEW_BRANCH"
    git push origin "$NEW_BRANCH"
    
    # Create PR
    gh pr create --title "Add rate limiting, usage documentation, and improvements" \
                 --body "## Changes
- Implemented rate limiting with retry logic for API calls
- Added comprehensive RATE_LIMITS.md documentation (with rejected rule removed)
- Added USAGE.md with detailed usage instructions
- Enhanced error handling in openai_helper.py
- Improved recipe generation and management in recipe_helper.py
- Updated requirements.txt with required dependencies
- Added test_app.py for testing functionality
- Updated .env.example with new configuration options

## Notes
- Removed the overly restrictive 20-30 second spacing requirement
- Kept the automatic retry logic with exponential backoff" \
                 --base main \
                 --head "$NEW_BRANCH"
else
    echo "Push successful! Creating PR..."
    gh pr create --fill --base main --head feature/rate-limiting-and-improvements-1765509756
fi
