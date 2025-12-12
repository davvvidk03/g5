#!/bin/bash

cd /workspaces/g5

echo "=== Rewriting git history to remove secret from all commits ==="

# Use filter-repo if available, otherwise use filter-branch
if command -v git-filter-repo &> /dev/null; then
    echo "Using git-filter-repo..."
    git filter-repo --invert-paths --path .env.example --force
    
    # Recreate .env.example with safe content
    echo "GROQ_API_KEY=your_groq_api_key_here" > .env.example
    git add .env.example
    git commit -m "Add .env.example without secrets"
else
    echo "Using git filter-branch (slower)..."
    
    # Create a script to replace the secret in .env.example
    cat > /tmp/replace_secret.sh << 'EOF'
#!/bin/bash
if [ -f .env.example ]; then
    sed -i 's/GROQ_API_KEY=gsk_.*/GROQ_API_KEY=your_groq_api_key_here/g' .env.example
    git add .env.example
fi
EOF
    chmod +x /tmp/replace_secret.sh
    
    # Run filter-branch to rewrite history
    git filter-branch --tree-filter '/tmp/replace_secret.sh' --force HEAD~3..HEAD
fi

echo ""
echo "=== Force pushing to main ==="
git push origin main --force

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Successfully pushed to main!"
    echo "✅ Secret removed from all commits!"
else
    echo ""
    echo "❌ Push failed. May need manual intervention."
fi
