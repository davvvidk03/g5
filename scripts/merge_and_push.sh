#!/bin/bash

cd /workspaces/g5

echo "=== Configuring pull strategy (merge) ==="
git config pull.rebase false

echo ""
echo "=== Pulling latest changes from main ==="
git pull origin main

if [ $? -ne 0 ]; then
    echo ""
    echo "❌ Pull failed. Checking for conflicts..."
    git status
    echo ""
    echo "If there are conflicts, resolve them and run:"
    echo "   git add <resolved-files>"
    echo "   git commit"
    echo "   git push origin main"
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
    echo "❌ Push failed. Error details above."
fi
