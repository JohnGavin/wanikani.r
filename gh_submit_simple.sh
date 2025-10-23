#!/bin/bash
# Simple GitHub submission script using gh CLI
# Alternative to gh_submit.R for those who prefer shell scripts

set -e  # Exit on error

GITHUB_USER="johngavin"
REPO_NAME="wanikani.r"
REPO_DESC="R Client for the WaniKani API - Complete interface to WaniKani API v2 for Japanese learning"

echo "========================================"
echo "  GITHUB SUBMISSION (Shell Script)"
echo "  Package: wanikani"
echo "  Target: https://github.com/$GITHUB_USER"
echo "========================================"
echo ""

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "ERROR: GitHub CLI (gh) is not installed."
    echo ""
    echo "Install it with:"
    echo "  macOS: brew install gh"
    echo "  Linux: See https://github.com/cli/cli#installation"
    echo ""
    exit 1
fi

# Check authentication
echo "=== Checking GitHub authentication ==="
if ! gh auth status &> /dev/null; then
    echo "Not authenticated. Logging in..."
    gh auth login
fi

echo "✓ Authenticated with GitHub"
echo ""

# Create repository if it doesn't exist
echo "=== Creating/checking repository ==="
if gh repo view "$GITHUB_USER/$REPO_NAME" &> /dev/null; then
    echo "✓ Repository already exists: $GITHUB_USER/$REPO_NAME"
else
    echo "Creating repository..."
    gh repo create "$GITHUB_USER/$REPO_NAME" \
        --public \
        --description "$REPO_DESC" \
        --source=. \
        --remote=origin
    echo "✓ Repository created"
fi
echo ""

# Set remote if not already set
echo "=== Configuring git remote ==="
if git remote get-url origin &> /dev/null; then
    echo "✓ Remote 'origin' already configured"
else
    git remote add origin "https://github.com/$GITHUB_USER/$REPO_NAME.git"
    echo "✓ Added remote 'origin'"
fi
echo ""

# Push to GitHub
echo "=== Pushing to GitHub ==="
BRANCH=$(git branch --show-current)
if [ -z "$BRANCH" ]; then
    BRANCH="main"
fi

echo "Pushing branch '$BRANCH'..."
git push -u origin "$BRANCH"
echo "✓ Pushed to GitHub"
echo ""

# Add topics
echo "=== Adding repository topics ==="
gh repo edit "$GITHUB_USER/$REPO_NAME" \
    --add-topic r \
    --add-topic r-package \
    --add-topic wanikani \
    --add-topic api-client \
    --add-topic japanese \
    --add-topic kanji \
    --add-topic vocabulary \
    --add-topic language-learning \
    --add-topic srs
echo "✓ Topics added"
echo ""

echo "========================================"
echo "  SUBMISSION COMPLETE!"
echo "========================================"
echo ""
echo "Repository URL:"
echo "  https://github.com/$GITHUB_USER/$REPO_NAME"
echo ""
echo "Installation command for users:"
echo "  devtools::install_github('$GITHUB_USER/$REPO_NAME')"
echo ""
