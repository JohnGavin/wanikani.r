# Installation and Testing Guide

## Prerequisites

This package requires R (>= 3.5.0) and the following R packages:
- httr (>= 1.4.0)
- jsonlite (>= 1.7.0)
- R6 (>= 2.5.0)

For development and testing:
- devtools
- roxygen2
- testthat (>= 3.0.0)
- knitr
- rmarkdown

## Installing R

### macOS
```bash
brew install r
```

Or download from: https://cloud.r-project.org/bin/macosx/

### Linux (Ubuntu/Debian)
```bash
sudo apt-get update
sudo apt-get install r-base r-base-dev
```

### Windows
Download from: https://cloud.r-project.org/bin/windows/base/

## Installation

### From Source (Development)

1. Clone the repository:
```bash
git clone https://github.com/yourusername/wanikani.r.git
cd wanikani.r
```

2. Open R and install development dependencies:
```r
install.packages("devtools")
devtools::install_dev_deps()
```

3. Build and install the package:
```r
devtools::install()
```

### From GitHub (Users)

```r
# Install devtools if you haven't already
install.packages("devtools")

# Install the package
devtools::install_github("yourusername/wanikani.r")
```

## Running Tests

### Option 1: Using devtools in R
```r
library(devtools)
setwd("path/to/wanikani.r")

# Run tests
test()

# Check package (comprehensive checks)
check()

# Build package
build()
```

### Option 2: Using R CMD (command line)
```bash
cd path/to/wanikani.r/..
R CMD build wanikani.r
R CMD check wanikani.r_*.tar.gz
```

### Option 3: Using the provided script
```bash
cd path/to/wanikani.r
Rscript check_package.R
```

## Manual Verification

Even without R installed, you can verify the package structure:

### Check file structure
```bash
cd wanikani.r

# Verify main components exist
ls -la DESCRIPTION NAMESPACE LICENSE README.md

# Verify R source files
ls -la R/

# Verify tests
ls -la tests/testthat/

# Verify documentation
ls -la man/ vignettes/
```

### Lint R files (requires shellcheck or similar)
```bash
# Check for common issues in R files
for file in R/*.R; do
  echo "Checking $file"
  # Look for common issues
  grep -n "TODO\|FIXME\|XXX" "$file" || echo "  No TODOs found"
done
```

## Package Structure Verification

A valid R package should have:

✓ DESCRIPTION - Package metadata
✓ NAMESPACE - Exported functions and imports
✓ R/ - R source code
  ✓ client.R - HTTP client
  ✓ user.R - User endpoints
  ✓ summary.R - Summary endpoint
  ✓ assignments.R - Assignment endpoints
  ✓ subjects.R - Subject endpoints
  ✓ reviews.R - Review endpoints
  ✓ review_statistics.R - Review statistics endpoints
  ✓ study_materials.R - Study materials endpoints
  ✓ level_progressions.R - Level progression endpoints
  ✓ resets.R - Reset endpoints
  ✓ spaced_repetition_systems.R - SRS endpoints
  ✓ voice_actors.R - Voice actor endpoints
  ✓ pagination.R - Pagination helpers
  ✓ wanikani-package.R - Package documentation
✓ tests/testthat/ - Test files
✓ vignettes/ - Long-form documentation
✓ README.md - Package readme
✓ LICENSE - License file

## Running Package Checks

### Standard R CMD check
This runs all standard CRAN checks:
```r
devtools::check()
```

Expected output:
- 0 errors
- 0 warnings
- 0 notes (or only informational notes)

### Common Issues and Solutions

1. **Missing dependencies**
   ```r
   install.packages(c("httr", "jsonlite", "R6"))
   ```

2. **Namespace issues**
   ```r
   devtools::document()  # Regenerate NAMESPACE
   ```

3. **Test failures**
   - Ensure you're not trying to make real API calls in tests
   - Mock external dependencies

4. **Documentation issues**
   ```r
   devtools::document()  # Regenerate .Rd files
   ```

## Usage After Installation

```r
library(wanikani)

# Set your API token
Sys.setenv(WANIKANI_API_TOKEN = "your_token_here")

# Test the package
user <- wk_user()
print(user$data$username)
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run `devtools::check()` to ensure everything passes
5. Submit a pull request

## Troubleshooting

### "Package not found" error
Make sure you're in the package directory when running commands.

### "API token required" error
Set the `WANIKANI_API_TOKEN` environment variable.

### "Rate limit exceeded" error
Wait for the rate limit to reset (60 requests per minute).

### Test failures
Some tests require mocking. Install the `httptest` package:
```r
install.packages("httptest")
```

## Support

- GitHub Issues: https://github.com/yourusername/wanikani.r/issues
- WaniKani API Docs: https://docs.api.wanikani.com/
- Package Documentation: `?wanikani` in R
