#!/bin/bash

cd /workspaces/g5

echo "=== Cleaning up working directory ==="

# Discard pycache changes (shouldn't be committed)
git restore src/__pycache__/openai_helper.cpython-312.pyc
git restore src/__pycache__/recipe_helper.cpython-312.pyc

echo ""
echo "=== Pulling with merge strategy ==="
git config pull.rebase false
git pull origin main --no-edit

if [ $? -ne 0 ]; then
    echo ""
    echo "❌ Pull failed with conflicts. Checking status..."
    git status
    echo ""
    echo "Resolve conflicts, then run:"
    echo "   git add <resolved-files>"
    echo "   git commit"
    echo "   bash /workspaces/g5/scripts/push_final.sh"
    exit 1
fi

echo ""
echo "=== Pushing to main ==="
git push origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Successfully pushed to main!"
else
    echo ""
    echo "❌ Push failed. Error details above."
fi
