#!/bin/bash

cd /workspaces/g5

# Create a new branch from current state
NEW_BRANCH="feature/improvements-$(date +%s)"
echo "Creating new branch: $NEW_BRANCH"

git checkout -b "$NEW_BRANCH"

# Push the new branch
git push -u origin "$NEW_BRANCH"

if [ $? -eq 0 ]; then
    echo "Push successful! Creating PR..."
    gh pr create --title "Add rate limiting, usage documentation, and improvements" \
                 --body "## Changes

- Implemented rate limiting with retry logic for API calls
- Added comprehensive RATE_LIMITS.md documentation
- Added USAGE.md with detailed usage instructions  
- Enhanced error handling in openai_helper.py
- Improved recipe generation and management in recipe_helper.py
- Updated requirements.txt with required dependencies
- Added test_app.py for testing functionality
- Updated .env.example with new configuration options

## Rate Limiting Improvements

- Automatic retry with exponential backoff (1s → 2s → 4s)
- Graceful degradation to local recipes when API unavailable
- Clear user feedback for rate limit situations
- Removed overly restrictive spacing requirements

## Testing

Tested with:
- Local recipe search
- AI recipe generation
- Rate limit handling
- Error scenarios" \
                 --base main \
                 --head "$NEW_BRANCH"
    
    if [ $? -eq 0 ]; then
        echo "✅ Pull request created successfully!"
    else
        echo "❌ PR creation failed, but branch was pushed"
        echo "You can create the PR manually at: https://github.com/davvvidk03/g5/compare/$NEW_BRANCH"
    fi
else
    echo "❌ Push failed. Checking repository rules..."
    gh api repos/davvvidk03/g5/rulesets --jq '.[] | {name: .name, enforcement: .enforcement}'
fi
