# Quick Start: Using Targets Pipeline

## Installation

```r
# Install from GitHub
devtools::install_github("JohnGavin/wanikani.r")

# Or install from source
setwd("path/to/wanikani.r")
devtools::install()
```

## Running the Targets Pipeline

The targets pipeline pre-computes data for vignettes without needing API credentials.

### Step 1: Install Required Packages

```r
install.packages(c("targets", "tarchetypes", "ggplot2", "dplyr", "tidyr", "visNetwork"))
```

### Step 2: Run the Pipeline

```r
library(targets)

# Run the full pipeline
tar_make()

# Check status
tar_progress()

# View what will be built
tar_visnetwork()
```

### Step 3: View the Visualization Vignette

After running `tar_make()`, install the package with vignettes:

```r
# Build vignettes
devtools::build_vignettes()

# View the visualization vignette
vignette("targets-pipeline-visualization", package = "wanikani")
```

## What the Pipeline Does

The `_targets.R` file creates 6 example targets:

1. **example_user_data**: Mock WaniKani user information
2. **example_subjects_kanji**: Mock kanji subjects (10 items)
3. **example_assignments**: Mock assignment data (20 items)
4. **example_review_stats**: Mock review statistics (10 items)
5. **summary_statistics**: Derived statistics from other targets
6. **pipeline_metadata**: Pipeline creation metadata

## Pipeline Visualization Features

The vignette shows:

- **Dependency graphs**: Interactive and static visualizations
- **Build times**: Bar charts showing time per target
- **Memory usage**: Charts showing size of each target
- **Performance metrics**: Statistics tables
- **System info**: R version, packages, platform
- **Recommendations**: Optimization suggestions

## Useful Commands

```r
# View all targets
tar_manifest()

# Load a specific target
tar_load(example_user_data)

# Read without loading to environment
data <- tar_read(example_subjects_kanji)

# Check what needs updating
tar_outdated()

# Clean everything (start fresh)
tar_destroy()

# Rebuild only outdated targets
tar_make()
```

## Tidyverse Style

The vignette uses tidyverse conventions:

```r
# Piping
meta_df %>%
  mutate(mb = bytes / (1024^2)) %>%
  ggplot(aes(x = reorder(name, mb), y = mb)) +
  geom_col()

# Summarizing
stats <- meta_df %>%
  summarise(
    mean_time = mean(seconds),
    total_memory = sum(mb)
  )

# Filtering
slow_targets <- meta_df %>%
  filter(seconds > median(seconds)) %>%
  arrange(desc(seconds))
```

## Troubleshooting

### Pipeline doesn't run

```r
# Make sure you're in the package directory
getwd()  # Should show .../wanikani.r

# Make sure _targets.R exists
file.exists("_targets.R")  # Should be TRUE
```

### Vignette not found

```r
# Build vignettes first
devtools::build_vignettes()

# Then install with vignettes
devtools::install(build_vignettes = TRUE)
```

### Can't see graphs

```r
# Install visualization packages
install.packages(c("ggplot2", "visNetwork"))

# Re-run pipeline
tar_make()
```

## Next Steps

1. Modify `_targets.R` to add your own targets
2. Run `tar_make()` to build them
3. Use `tar_load()` in vignettes to access pre-computed data
4. View diagnostics in the visualization vignette

## Resources

- [targets documentation](https://docs.ropensci.org/targets/)
- [targets manual](https://books.ropensci.org/targets/)
- [tidyverse style guide](https://style.tidyverse.org/)
