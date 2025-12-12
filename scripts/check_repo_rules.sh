#!/bin/bash

cd /workspaces/g5

echo "=== Repository Rulesets ==="
gh api repos/davvvidk03/g5/rulesets --jq '.[] | {id: .id, name: .name, enforcement: .enforcement, target: .target, bypass_actors: .bypass_actors}'

echo ""
echo "=== Branch Protection Rules ==="
gh api repos/davvvidk03/g5/branches/main/protection 2>/dev/null || echo "No branch protection on main"

echo ""
echo "=== Repository Settings ==="
gh api repos/davvvidk03/g5 --jq '{
  allow_merge_commit: .allow_merge_commit,
  allow_squash_merge: .allow_squash_merge,
  allow_rebase_merge: .allow_rebase_merge,
  allow_auto_merge: .allow_auto_merge,
  delete_branch_on_merge: .delete_branch_on_merge
}'
