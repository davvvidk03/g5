#!/bin/bash

cd /workspaces/g5

echo "=== Removing secret from .env.example ==="
git add .env.example

echo ""
echo "=== Amending the commit to remove secret ==="
git commit --amend --no-edit

echo ""
echo "=== Pushing to main ==="
git push origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Successfully pushed to main!"
    echo "✅ All done! Your changes are live."
else
    echo ""
    echo "❌ Push failed. Check error above."
fi
