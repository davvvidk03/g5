#!/bin/bash

cd /workspaces/g5

echo "=== Merging changes to main and pushing directly ==="

# Switch to main
git checkout main

# Pull latest changes
echo "Pulling latest from main..."
git pull origin main

# Merge the feature branch
echo "Merging feature branch..."
git merge feature/rate-limiting-and-improvements-1765509756 --no-ff -m "Merge improvements and usage documentation

- Added comprehensive USAGE.md with detailed usage instructions
- Enhanced error handling in openai_helper.py
- Improved recipe generation and management in recipe_helper.py
- Updated requirements.txt with required dependencies
- Added test_app.py for testing functionality
- Updated .env.example with new configuration options"

if [ $? -ne 0 ]; then
    echo "❌ Merge conflict detected. Resolve conflicts and run:"
    echo "   git merge --continue"
    exit 1
fi

# Ensure no pycache files are included
git reset -- '*__pycache__*' 2>/dev/null
git restore --staged '*__pycache__*' 2>/dev/null

echo ""
echo "=== Pushing to main ==="
git push origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Successfully pushed to main!"
    echo ""
    echo "Cleaning up feature branch..."
    git branch -d feature/rate-limiting-and-improvements-1765509756 2>/dev/null
    echo ""
    echo "✅ All done! Changes are now on main branch."
else
    echo ""
    echo "❌ Push to main failed."
    echo "Repository may have branch protection on main as well."
fi
