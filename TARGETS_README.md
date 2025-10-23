# Using Targets for Vignette Pre-computation

This package uses the [`targets`](https://docs.ropensci.org/targets/) package to pre-compute objects used in vignettes, ensuring fast and reproducible vignette builds.

## Overview

Vignettes that make live API calls can be slow to build and require valid API credentials. By using `targets`, we can:

1. Pre-compute data objects once
2. Store them in the `_targets/` directory
3. Load them quickly in vignettes with `targets::tar_load()` or `targets::tar_read()`

## Setup

### Install targets

```r
install.packages("targets")
install.packages("tarchetypes")
```

### Run the pipeline

```r
# Run all targets
targets::tar_make()

# View the pipeline
targets::tar_visnetwork()

# Check what needs updating
targets::tar_outdated()
```

## Pipeline Structure

The `_targets.R` file defines the pipeline:

```r
library(targets)
library(tarchetypes)

tar_option_set(
  packages = c("wanikani", "httr", "jsonlite"),
  format = "rds"
)

list(
  # Example: Pre-compute user data
  tar_target(
    example_user_data,
    wk_user()  # This would make a real API call
  ),

  # Example: Pre-compute subject data
  tar_target(
    example_subjects,
    wk_subjects(levels = 1)
  )
)
```

## Using in Vignettes

In your vignette:

```r
# Load pre-computed data
targets::tar_load(example_user_data)
targets::tar_load(example_subjects)

# Use the data
print(example_user_data$data$username)
print(example_subjects$data[[1]]$data$characters)
```

## Benefits

1. **Speed**: Vignettes build instantly without API calls
2. **Reproducibility**: Same data every time
3. **No credentials needed**: Pre-computed data doesn't require API tokens
4. **Caching**: `targets` only recomputes what changed

## Workflow

### For Package Development

1. **Update pipeline** in `_targets.R` with new targets
2. **Run pipeline**: `targets::tar_make()`
3. **Use in vignettes**: `targets::tar_load(your_target)`
4. **Build vignettes**: `devtools::build_vignettes()`

### For GitHub Actions

The workflow automatically:
1. Installs dependencies including `targets`
2. Can run `targets::tar_make()` before building vignettes
3. Builds the package with pre-computed data

## Example Vignette Structure

```rmd
---
title: "Getting Started"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{Getting Started}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---

```{r setup}
library(wanikani)
library(targets)
```

```{r load-precomputed}
# Load pre-computed data (fast!)
tar_load(example_user_data)
tar_load(example_subjects)
```

```{r show-results}
# Display the data
print(example_user_data$data$username)
print(example_subjects$data[[1]]$data$characters)
```

```{r eval=FALSE}
# Show the code users would run (but don't actually execute)
user <- wk_user()
subjects <- wk_subjects(levels = 1)
```
```

## Directory Structure

```
wanikani.r/
├── _targets.R              # Pipeline definition
├── _targets/              # Cached target objects (gitignored)
│   ├── meta/
│   ├── objects/
│   └── ...
├── vignettes/
│   └── getting-started-targets.Rmd
└── TARGETS_README.md      # This file
```

## Targets Commands

```r
# Run the full pipeline
targets::tar_make()

# Load a specific target
targets::tar_load(example_user_data)

# Read a target without loading to environment
data <- targets::tar_read(example_user_data)

# View pipeline status
targets::tar_progress()

# Visualize pipeline
targets::tar_visnetwork()

# Remove outdated targets
targets::tar_prune()

# Clean everything
targets::tar_destroy()
```

## Notes

- The `_targets/` directory is gitignored (data is too large)
- Pre-computed targets should be rebuilt periodically
- For CI/CD, consider caching `_targets/` between runs
- Mock data is fine for examples - doesn't need to be real API data

## References

- [targets documentation](https://docs.ropensci.org/targets/)
- [targets manual](https://books.ropensci.org/targets/)
- [tarchetypes package](https://docs.ropensci.org/tarchetypes/)
