#!/bin/bash

cd /workspaces/g5

echo "=== Finding the problematic commit ==="
git log --oneline --all | head -10

echo ""
echo "=== Resetting to origin/main and reapplying changes ==="

# Fetch latest from origin
git fetch origin main

# Create backup of current changes
git diff HEAD > /tmp/current_changes.patch

# Hard reset to origin/main
git reset --hard origin/main

# Ensure .env.example has no secrets
if grep -q "gsk_" .env.example 2>/dev/null; then
    echo "Fixing .env.example..."
    echo "GROQ_API_KEY=your_groq_api_key_here" > .env.example
fi

# Apply only the important file changes (excluding pycache)
git checkout feature/rate-limiting-and-improvements-1765509756 -- \
    USAGE.md \
    main.py \
    src/openai_helper.py \
    src/recipe_helper.py \
    test_app.py \
    requirements.txt \
    saved_recipes.json \
    .gitignore 2>/dev/null

# Ensure .env.example is safe
echo "GROQ_API_KEY=your_groq_api_key_here" > .env.example
git add .env.example

# Commit all changes
git add -A
git commit -m "Add improvements and usage documentation

- Added comprehensive USAGE.md with detailed usage instructions
- Enhanced error handling in openai_helper.py
- Improved recipe generation and management
- Updated requirements.txt with required dependencies
- Added test_app.py for testing functionality
- Updated .gitignore

No secrets included in this commit."

echo ""
echo "=== Pushing to main ==="
git push origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Successfully pushed to main!"
    echo "✅ All done!"
else
    echo ""
    echo "❌ Push failed. Check error above."
fi
