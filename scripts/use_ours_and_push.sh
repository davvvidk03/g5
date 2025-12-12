#!/bin/bash

cd /workspaces/g5

echo "=== Aborting current merge ==="
git merge --abort

echo ""
echo "=== Unstaging pycache files ==="
git reset HEAD src/__pycache__/ 2>/dev/null
git restore src/__pycache__/ 2>/dev/null

echo ""
echo "=== Using ours strategy to keep local changes ==="
git pull origin main -X ours --no-edit

if [ $? -ne 0 ]; then
    echo "❌ Pull with 'ours' strategy failed."
    exit 1
fi

echo ""
echo "=== Pushing to main ==="
git push origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Successfully pushed to main!"
    echo "✅ All done!"
else
    echo ""
    echo "❌ Push failed."
fi
