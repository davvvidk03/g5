#!/bin/bash

cd /workspaces/g5

echo "First, let's diagnose the issue..."
bash /workspaces/g5/scripts/diagnose_push_issue.sh

echo ""
echo "=== Attempting to remove problematic files ==="

# Remove __pycache__ files from git if they're tracked
git rm -r --cached src/__pycache__ 2>/dev/null || echo "No __pycache__ to remove from src"
git rm -r --cached scripts/__pycache__ 2>/dev/null || echo "No __pycache__ to remove from scripts"

# Amend the commit if we removed anything
git status --short | grep -q . && git commit --amend --no-edit

echo ""
echo "=== Trying push again ==="
git push -u origin feature/rate-limit-improvements

if [ $? -ne 0 ]; then
    echo ""
    echo "=== Still failing. Trying without cached files ==="
    # Reset and recommit without cached files
    git reset HEAD~1
    git restore --staged 'src/__pycache__/*' 'scripts/__pycache__/*' 2>/dev/null
    git add .
    git commit -m "Add rate limiting and improvements (no cache files)"
    git push -u origin feature/rate-limit-improvements
fi
