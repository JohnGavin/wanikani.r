#!/usr/bin/env Rscript
# Generate documentation and build vignettes for the wanikani package

# Install required packages if needed
required_packages <- c("roxygen2", "devtools", "knitr", "rmarkdown")
for (pkg in required_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    message(sprintf("Installing %s...", pkg))
    install.packages(pkg, repos = "https://cloud.r-project.org", quiet = TRUE)
  }
}

library(roxygen2)
library(devtools)

# Set working directory to package root
args <- commandArgs(trailingOnly = FALSE)
script_path <- sub("--file=", "", args[grep("--file=", args)])
if (length(script_path) > 0) {
  setwd(dirname(script_path))
}

message("=== Generating documentation with roxygen2 ===")
roxygen2::roxygenise()

message("\n=== Building vignettes ===")
devtools::build_vignettes()

message("\n=== Documentation generation complete! ===")
message("Now run: R CMD check wanikani.r")
