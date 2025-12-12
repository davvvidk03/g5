#!/bin/bash

cd /workspaces/g5

# Create a completely new branch name
NEW_BRANCH="feature/rate-limit-improvements"
echo "Creating new branch: $NEW_BRANCH"

# Checkout new branch from current HEAD
git checkout -b "$NEW_BRANCH"

# Push to GitHub
echo "Pushing to GitHub..."
git push -u origin "$NEW_BRANCH"

if [ $? -eq 0 ]; then
    echo "✅ Successfully pushed branch: $NEW_BRANCH"
    echo ""
    echo "Creating pull request..."
    
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
- Documentation for handling rate limits effectively

## Testing

All features tested including:
- Local recipe search functionality
- AI recipe generation with Groq
- Rate limit handling and retry logic
- Error scenarios and fallback behavior" \
                 --base main \
                 --head "$NEW_BRANCH"
    
    echo ""
    echo "✅ Done! Pull request created."
else
    echo "❌ Push failed. Error details above."
    exit 1
fi
