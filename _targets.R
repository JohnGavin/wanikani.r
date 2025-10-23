# targets pipeline for wanikani package vignettes
# This pre-computes objects used in vignettes for faster building

library(targets)
library(tarchetypes)

# Source custom functions
# source("R/targets_functions.R")

# Set target-specific options
tar_option_set(
  packages = c("wanikani", "httr", "jsonlite"),
  format = "rds"
)

# Define the pipeline
list(
  # Example: Pre-compute user data for vignette
  # Note: These require a valid API token to run
  # tar_target(
  #   example_user_data,
  #   {
  #     # Mock data for vignette examples
  #     list(
  #       data = list(
  #         username = "example_user",
  #         level = 5,
  #         subscription = list(type = "recurring")
  #       )
  #     )
  #   }
  # ),

  # Example: Pre-compute subject data
  # tar_target(
  #   example_subjects,
  #   {
  #     # Mock data for vignette examples
  #     list(
  #       data = list(
  #         list(
  #           id = 440,
  #           object = "kanji",
  #           data = list(
  #             characters = "一",
  #             meanings = list(list(meaning = "one", primary = TRUE)),
  #             level = 1
  #           )
  #         )
  #       )
  #     )
  #   }
  # ),

  # Placeholder target to show pipeline structure
  tar_target(
    vignette_ready,
    TRUE
  )
)
