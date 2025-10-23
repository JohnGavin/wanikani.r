# GitHub Submission Guide

This document explains how to submit the wanikani package to GitHub at https://github.com/johngavin

## Prerequisites

Choose ONE of the following methods:

### Method 1: Using R Script (gh_submit.R)
Requires:
- R with packages: `usethis`, `gh`, `devtools`
- GitHub Personal Access Token (PAT)

### Method 2: Using Shell Script (gh_submit_simple.sh)
Requires:
- GitHub CLI (`gh`) installed
- Authentication via `gh auth login`

### Method 3: Manual Git Commands
Requires:
- Git installed
- GitHub account access

## Method 1: R Script (Recommended for R users)

### Setup
```r
# Install required packages
install.packages(c("usethis", "gh", "devtools"))

# Create GitHub token
usethis::create_github_token()
# This opens browser - create token with 'repo' scope

# Save the token
gitcreds::gitcreds_set()
# Paste your token when prompted
```

### Run
```bash
cd /Users/johngavin/docs_gh/claude_rix/wanikani.r
Rscript gh_submit.R
```

The script will:
1. ✓ Verify git repository
2. ✓ Check GitHub authentication
3. ✓ Create repository at github.com/johngavin/wanikani.r
4. ✓ Configure git remote
5. ✓ Push code to GitHub
6. ✓ Set repository description and topics

## Method 2: Shell Script (Recommended for CLI users)

### Setup
```bash
# Install GitHub CLI
brew install gh  # macOS
# or
# sudo apt install gh  # Linux

# Authenticate
gh auth login
```

### Run
```bash
cd /Users/johngavin/docs_gh/claude_rix/wanikani.r
./gh_submit_simple.sh
```

## Method 3: Manual Git Commands

### Setup
```bash
# Create repository on GitHub first
# Go to: https://github.com/new
# Repository name: wanikani.r
# Description: R Client for the WaniKani API
# Public, no README, no .gitignore, no license (we have them)
```

### Commands
```bash
cd /Users/johngavin/docs_gh/claude_rix/wanikani.r

# Add remote
git remote add origin https://github.com/johngavin/wanikani.r.git

# Push to GitHub
git push -u origin main

# Or if your default branch is master:
# git branch -M main
# git push -u origin main
```

## After Submission

### Verify Upload
Visit: https://github.com/johngavin/wanikani.r

You should see:
- ✓ All source files
- ✓ README.md displayed
- ✓ LICENSE file
- ✓ Complete commit history

### Installation for Users
Once on GitHub, users can install with:
```r
# Install from GitHub
devtools::install_github("johngavin/wanikani.r")

# Or using remotes
install.packages("remotes")
remotes::install_github("johngavin/wanikani.r")
```

### Test Installation
```r
# Set API token
Sys.setenv(WANIKANI_API_TOKEN = "your_token_here")

# Load and test
library(wanikani)
user <- wk_user()
print(user$data$username)
```

## Updating the Package

After making changes:

```bash
# Stage changes
git add -A

# Commit
git commit -m "Description of changes"

# Push to GitHub
git push
```

## Troubleshooting

### "Authentication failed"
**R Script:** Re-run `gitcreds::gitcreds_set()` with a new token
**Shell Script:** Run `gh auth login` again
**Manual:** Use SSH instead: `git@github.com:johngavin/wanikani.r.git`

### "Repository already exists"
The scripts handle this automatically. For manual method, skip the "create repository" step.

### "Permission denied"
Make sure you're authenticated as the correct user (johngavin) and have write access.

### "Failed to push"
```bash
# Pull any remote changes first
git pull origin main --rebase

# Then push
git push origin main
```

## Repository Settings (Optional)

After submission, you can configure via GitHub web interface:

### Settings to consider:
- ✓ Description: "R Client for the WaniKani API"
- ✓ Website: https://docs.api.wanikani.com/
- ✓ Topics: r, r-package, wanikani, api-client, japanese, kanji
- ✓ Issues: Enabled
- ✓ Wiki: Disabled
- ✓ Projects: Disabled

### GitHub Actions (Optional)
Consider adding CI/CD:
- R CMD check on push/pull request
- Code coverage with covr
- pkgdown site deployment

Example workflow: `.github/workflows/R-CMD-check.yaml`

### Badges (Optional)
Add to README.md:
```markdown
[![R-CMD-check](https://github.com/johngavin/wanikani.r/workflows/R-CMD-check/badge.svg)](https://github.com/johngavin/wanikani.r/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
```

## Summary

**Easiest Method:**
```bash
./gh_submit_simple.sh
```

**For R Users:**
```bash
Rscript gh_submit.R
```

**Result:**
Package available at: https://github.com/johngavin/wanikani.r
