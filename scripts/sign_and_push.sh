#!/bin/bash

cd /workspaces/g5

# Configure git to sign commits (if not already configured)
git config --global commit.gpgsign true

# Amend the last commit with a signature
git commit --amend --no-edit -S

# Force push with lease (safer than regular force push)
git push --force-with-lease origin feature/rate-limiting-and-improvements-1765509756

# Create the PR
gh pr create --fill --base main --head feature/rate-limiting-and-improvements-1765509756

echo "Done! PR should be created."
