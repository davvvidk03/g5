#!/bin/bash

cd /workspaces/g5

echo "=== Pulling latest changes from main ==="
git pull origin main

if [ $? -ne 0 ]; then
    echo "❌ Pull failed. There may be conflicts to resolve."
    echo "Run: git status"
    exit 1
fi

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
    echo "✅ All done! Your changes are now live on main."
else
    echo ""
    echo "❌ Push failed. Check error message above."
fi
