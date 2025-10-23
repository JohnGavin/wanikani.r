#!/usr/bin/env Rscript
# GitHub Submission Script for wanikani.r Package
# Submits the package to https://github.com/johngavin

cat("========================================\n")
cat("  GITHUB SUBMISSION SCRIPT\n")
cat("  Package: wanikani\n")
cat("  Target: https://github.com/johngavin\n")
cat("========================================\n\n")

# Install required packages if needed
required_packages <- c("usethis", "gh", "devtools")

cat("Checking required packages...\n")
for (pkg in required_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    cat(sprintf("Installing %s...\n", pkg))
    install.packages(pkg, repos = "https://cloud.r-project.org")
  }
}

library(usethis)
library(gh)
library(devtools)

# Configuration
github_user <- "johngavin"
repo_name <- "wanikani.r"
repo_description <- "R Client for the WaniKani API - Complete interface to WaniKani API v2 for Japanese learning"
repo_homepage <- "https://docs.api.wanikani.com/"

cat("\n=== Step 1: Verify git repository ===\n")
if (!dir.exists(".git")) {
  cat("ERROR: Not a git repository. Run 'git init' first.\n")
  quit(status = 1)
}

# Check for uncommitted changes
git_status <- system("git status --porcelain", intern = TRUE)
if (length(git_status) > 0) {
  cat("WARNING: You have uncommitted changes:\n")
  cat(paste(git_status, collapse = "\n"), "\n")
  cat("\nPlease commit your changes first:\n")
  cat("  git add -A\n")
  cat("  git commit -m 'Your commit message'\n\n")
  readline("Press Enter to continue anyway, or Ctrl+C to abort...")
}

cat("\n=== Step 2: Check GitHub authentication ===\n")
tryCatch({
  user_info <- gh::gh_whoami()
  cat(sprintf("Authenticated as: %s\n", user_info$login))

  if (user_info$login != github_user) {
    cat(sprintf("WARNING: Authenticated as '%s' but target user is '%s'\n",
                user_info$login, github_user))
    cat("Make sure you're using the correct GitHub account.\n")
    readline("Press Enter to continue, or Ctrl+C to abort...")
  }
}, error = function(e) {
  cat("ERROR: Not authenticated with GitHub.\n")
  cat("Please authenticate using one of these methods:\n\n")
  cat("1. Using usethis:\n")
  cat("   usethis::create_github_token()\n")
  cat("   gitcreds::gitcreds_set()\n\n")
  cat("2. Using gh CLI:\n")
  cat("   gh auth login\n\n")
  quit(status = 1)
})

cat("\n=== Step 3: Create GitHub repository ===\n")
repo_full_name <- paste0(github_user, "/", repo_name)

# Check if repo already exists
repo_exists <- FALSE
tryCatch({
  gh::gh("GET /repos/:owner/:repo", owner = github_user, repo = repo_name)
  repo_exists <- TRUE
  cat(sprintf("Repository %s already exists.\n", repo_full_name))
}, error = function(e) {
  cat(sprintf("Repository %s does not exist yet.\n", repo_full_name))
})

if (!repo_exists) {
  cat("Creating new repository...\n")
  tryCatch({
    gh::gh("POST /user/repos",
           name = repo_name,
           description = repo_description,
           homepage = repo_homepage,
           private = FALSE,
           has_issues = TRUE,
           has_projects = FALSE,
           has_wiki = FALSE,
           auto_init = FALSE)
    cat(sprintf("✓ Created repository: https://github.com/%s\n", repo_full_name))
  }, error = function(e) {
    cat("ERROR creating repository:\n")
    print(e)
    quit(status = 1)
  })
} else {
  cat("Using existing repository.\n")
}

cat("\n=== Step 4: Set up git remote ===\n")
remote_url <- sprintf("https://github.com/%s/%s.git", github_user, repo_name)

# Check if origin remote exists
remotes <- system("git remote", intern = TRUE)
if ("origin" %in% remotes) {
  current_url <- system("git remote get-url origin", intern = TRUE)
  if (current_url != remote_url) {
    cat(sprintf("Updating origin remote to: %s\n", remote_url))
    system(sprintf("git remote set-url origin %s", remote_url))
  } else {
    cat("✓ Origin remote already configured correctly\n")
  }
} else {
  cat(sprintf("Adding origin remote: %s\n", remote_url))
  system(sprintf("git remote add origin %s", remote_url))
}

cat("\n=== Step 5: Push to GitHub ===\n")
cat("Pushing to main branch...\n")

# Get current branch
current_branch <- system("git branch --show-current", intern = TRUE)
if (length(current_branch) == 0 || current_branch == "") {
  current_branch <- "main"
}

push_result <- system(sprintf("git push -u origin %s", current_branch))

if (push_result == 0) {
  cat("\n✓ Successfully pushed to GitHub!\n")
} else {
  cat("\nERROR: Failed to push to GitHub.\n")
  cat("You may need to:\n")
  cat("1. Verify your GitHub credentials\n")
  cat("2. Check if you have write access to the repository\n")
  cat("3. Pull any remote changes first: git pull origin main\n")
  quit(status = 1)
}

cat("\n=== Step 6: Configure repository settings ===\n")
tryCatch({
  # Update repository settings
  gh::gh("PATCH /repos/:owner/:repo",
         owner = github_user,
         repo = repo_name,
         description = repo_description,
         homepage = repo_homepage,
         has_issues = TRUE,
         has_projects = FALSE,
         has_wiki = FALSE)

  # Add topics/tags
  gh::gh("PUT /repos/:owner/:repo/topics",
         owner = github_user,
         repo = repo_name,
         names = c("r", "r-package", "wanikani", "api-client", "japanese",
                   "kanji", "vocabulary", "language-learning", "srs"))

  cat("✓ Repository settings configured\n")
}, error = function(e) {
  cat("Note: Could not update all repository settings (non-critical)\n")
})

cat("\n========================================\n")
cat("  SUBMISSION COMPLETE!\n")
cat("========================================\n\n")

cat("Repository URL:\n")
cat(sprintf("  https://github.com/%s/%s\n\n", github_user, repo_name))

cat("Next steps:\n")
cat("1. View your repository on GitHub\n")
cat(sprintf("2. Users can install with: devtools::install_github('%s/%s')\n",
            github_user, repo_name))
cat("3. Consider adding:\n")
cat("   - GitHub Actions for CI/CD\n")
cat("   - Code coverage badges\n")
cat("   - CRAN submission (optional)\n\n")

cat("To update the repository in the future:\n")
cat("  git add -A\n")
cat("  git commit -m 'Your changes'\n")
cat("  git push\n\n")
