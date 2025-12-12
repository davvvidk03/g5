#!/bin/bash

cd /workspaces/g5

echo "=== Checking for large files ==="
git ls-files -z | xargs -0 du -h | sort -rh | head -20

echo ""
echo "=== Checking commit details ==="
git log --oneline -3

echo ""
echo "=== Checking for binary/cache files in commits ==="
git diff --name-only main...HEAD | grep -E '\.pyc$|__pycache__|\.so$|\.dylib$|\.exe$'

echo ""
echo "=== Files changed from main ==="
git diff --stat main...HEAD

echo ""
echo "=== Checking file sizes in changed files ==="
git diff --name-only main...HEAD | while read file; do
    if [ -f "$file" ]; then
        size=$(du -h "$file" | cut -f1)
        echo "$size - $file"
    fi
done | sort -rh

echo ""
echo "=== Current git user ==="
git config user.name
git config user.email
