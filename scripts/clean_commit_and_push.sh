#!/bin/bash

cd /workspaces/g5

echo "=== Diagnosing push issue ==="

echo "Files changed from main:"
git diff --name-only main...HEAD

echo ""
echo "Checking for __pycache__ files:"
git ls-files | grep __pycache__

echo ""
echo "=== Removing cached Python files ==="
git rm -r --cached src/__pycache__/ 2>/dev/null && echo "Removed src/__pycache__/" || echo "src/__pycache__ not tracked"
git rm -r --cached scripts/__pycache__/ 2>/dev/null && echo "Removed scripts/__pycache__/" || echo "scripts/__pycache__ not tracked"

echo ""
echo "=== Creating clean commit ==="
git checkout feature/rate-limiting-and-improvements-1765509756
git reset --soft HEAD~2  # Reset the last 2 commits but keep changes
git restore --staged 'src/__pycache__/*' 2>/dev/null
git restore --staged 'scripts/__pycache__/*' 2>/dev/null

# Add all changes except pycache
git add .env.example .gitignore RATE_LIMITS.md USAGE.md main.py requirements.txt saved_recipes.json src/ test_app.py
git reset -- 'src/__pycache__/*' 'scripts/__pycache__/*' 2>/dev/null

git commit -m "Add rate limiting, usage documentation, and improvements

- Implemented rate limiting with retry logic for API calls
- Added comprehensive RATE_LIMITS.md documentation
- Added USAGE.md with detailed usage instructions
- Enhanced error handling in openai_helper.py
- Improved recipe generation and management in recipe_helper.py
- Updated requirements.txt with required dependencies
- Added test_app.py for testing functionality
- Updated .env.example with new configuration options"

echo ""
echo "=== Pushing clean commit ==="
git push -f origin feature/rate-limiting-and-improvements-1765509756

if [ $? -eq 0 ]; then
    echo "✅ Push successful!"
    gh pr create --fill --base main --head feature/rate-limiting-and-improvements-1765509756
else
    echo "Push still failed. Trying new branch..."
    git checkout -b feature/improvements-clean
    git push -u origin feature/improvements-clean
    gh pr create --fill --base main --head feature/improvements-clean
fi
