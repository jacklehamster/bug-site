#!/usr/bin/env bash
# Connect bug-site to GitHub so Cloudflare Workers Builds deploys on push.
# Run from INSIDE the bug-site folder (the one containing wrangler.toml).
set -euo pipefail

[ -f wrangler.toml ] || { echo "error: run this from the bug-site folder (no wrangler.toml here)"; exit 1; }

cat > .gitignore <<'GI'
node_modules/
.wrangler/
.dev.vars
.DS_Store
GI

git init -q 2>/dev/null || true
git add -A
git commit -qm "BUG — static site for bug.dobuki.net" || echo "(nothing new to commit)"
git branch -M main

if command -v gh >/dev/null 2>&1; then
  gh repo create bug-site --private --source=. --push
  echo
  echo "Repo created and pushed."
else
  echo
  echo "gh CLI not found. Create an empty repo named 'bug-site' at https://github.com/new"
  echo "then run:"
  echo "  git remote add origin git@github.com:jacklehamster/bug-site.git"
  echo "  git push -u origin main"
fi

cat <<'NEXT'

Next, in the Cloudflare dashboard:
  Workers & Pages -> bug -> Settings -> Builds -> Connect
    Repository:      bug-site
    Branch:          main
    Build command:   (leave EMPTY - there is no build step)
    Deploy command:  npx wrangler deploy
    Root directory:  (default)

The Worker name in the dashboard must stay "bug" to match wrangler.toml,
or every build will fail.
NEXT
