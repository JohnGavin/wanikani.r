#!/usr/bin/env Rscript
# Script to check and build the wanikani R package

# Install required packages if not already installed
required_packages <- c("devtools", "roxygen2", "testthat", "httr", "jsonlite", "R6")

for (pkg in required_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    message(sprintf("Installing %s...", pkg))
    install.packages(pkg, repos = "https://cloud.r-project.org")
  }
}

library(devtools)
library(roxygen2)

# Set working directory to package root
setwd(dirname(sys.frame(1)$ofile))

message("=== Step 1: Loading package ===")
load_all()

message("\n=== Step 2: Generating documentation ===")
document()

message("\n=== Step 3: Running tests ===")
test()

message("\n=== Step 4: Checking package ===")
check()

message("\n=== Step 5: Building package ===")
build()

message("\n=== Package check complete! ===")
message("\nTo install the package locally, run:")
message("  devtools::install()")
message("\nTo install from GitHub (after pushing), users can run:")
message("  devtools::install_github('yourusername/wanikani.r')")
