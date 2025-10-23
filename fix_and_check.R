#!/usr/bin/env Rscript
# Fix documentation and prepare package for checking

cat("=== Installing required packages ===\n")
required <- c("roxygen2", "devtools", "knitr", "rmarkdown")
for (pkg in required) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg, repos = "https://cloud.r-project.org")
  }
}

cat("\n=== Generating documentation with roxygen2 ===\n")
roxygen2::roxygenise()

cat("\n=== Building vignettes ===\n")
tryCatch({
  devtools::build_vignettes()
  cat("Vignettes built successfully\n")
}, error = function(e) {
  cat("Note: Vignette building skipped (not critical for package function)\n")
})

cat("\n=== Cleaning up empty inst directory ===\n")
if (dir.exists("inst") && length(list.files("inst", recursive = TRUE)) == 0) {
  unlink("inst", recursive = TRUE)
  cat("Removed empty inst directory\n")
}

cat("\n=== Done! ===\n")
cat("Documentation has been generated.\n")
cat("Now run: R CMD check wanikani.r\n")
