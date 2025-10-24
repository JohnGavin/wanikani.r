# Script to generate visualization targets after main pipeline completes
# This script reads tar_meta() to create plots and tables

library(targets)
library(ggplot2)
library(dplyr)
library(tidyr)

# Read metadata from completed targets
targets_meta <- tar_meta(fields = c("name", "time", "bytes", "seconds"))

# Plot: Build times
plot_build_times <- {
  meta_df <- targets_meta %>%
    as.data.frame() %>%
    dplyr::mutate(
      seconds = as.numeric(seconds),
      name = factor(name)
    ) %>%
    dplyr::filter(!is.na(seconds))

  ggplot(meta_df, aes(x = reorder(name, seconds), y = seconds)) +
    geom_col(fill = "#0054AD") +
    coord_flip() +
    labs(
      title = "Target Build Times",
      x = "Target Name",
      y = "Time (seconds)"
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(face = "bold", size = 14),
      axis.text.y = element_text(size = 10)
    )
}

# Plot: Memory usage
plot_memory_usage <- {
  meta_df <- targets_meta %>%
    as.data.frame() %>%
    dplyr::mutate(
      mb = bytes / (1024^2),
      name = factor(name)
    ) %>%
    dplyr::filter(!is.na(bytes))

  ggplot(meta_df, aes(x = reorder(name, mb), y = mb)) +
    geom_col(fill = "#FF6B6B") +
    coord_flip() +
    labs(
      title = "Target Memory Usage",
      x = "Target Name",
      y = "Size (MB)"
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(face = "bold", size = 14),
      axis.text.y = element_text(size = 10)
    )
}

# Table: Build time statistics
table_time_stats <- {
  meta_df <- targets_meta %>%
    as.data.frame() %>%
    dplyr::mutate(seconds = as.numeric(seconds)) %>%
    dplyr::filter(!is.na(seconds))

  data.frame(
    Metric = c("Total Time", "Mean Time", "Median Time", "Max Time", "Min Time"),
    Value = c(
      sprintf("%.2f seconds", sum(meta_df$seconds, na.rm = TRUE)),
      sprintf("%.2f seconds", mean(meta_df$seconds, na.rm = TRUE)),
      sprintf("%.2f seconds", median(meta_df$seconds, na.rm = TRUE)),
      sprintf("%.2f seconds (%s)", max(meta_df$seconds, na.rm = TRUE),
              meta_df$name[which.max(meta_df$seconds)]),
      sprintf("%.2f seconds (%s)", min(meta_df$seconds, na.rm = TRUE),
              meta_df$name[which.min(meta_df$seconds)])
    ),
    stringsAsFactors = FALSE
  )
}

# Table: Memory statistics
table_memory_stats <- {
  meta_df <- targets_meta %>%
    as.data.frame() %>%
    dplyr::mutate(mb = bytes / (1024^2)) %>%
    dplyr::filter(!is.na(bytes))

  data.frame(
    Metric = c("Total Size", "Mean Size", "Median Size", "Largest", "Smallest"),
    Value = c(
      sprintf("%.2f MB", sum(meta_df$mb, na.rm = TRUE)),
      sprintf("%.2f MB", mean(meta_df$mb, na.rm = TRUE)),
      sprintf("%.2f MB", median(meta_df$mb, na.rm = TRUE)),
      sprintf("%.2f MB (%s)", max(meta_df$mb, na.rm = TRUE),
              meta_df$name[which.max(meta_df$mb)]),
      sprintf("%.2f MB (%s)", min(meta_df$mb, na.rm = TRUE),
              meta_df$name[which.min(meta_df$mb)])
    ),
    stringsAsFactors = FALSE
  )
}

# Table: Target manifest
table_manifest <- tar_manifest()

# Save all visualization objects to _targets/objects/ manually
dir.create("_targets/objects", showWarnings = FALSE, recursive = TRUE)
saveRDS(plot_build_times, "_targets/objects/plot_build_times")
saveRDS(plot_memory_usage, "_targets/objects/plot_memory_usage")
saveRDS(table_time_stats, "_targets/objects/table_time_stats")
saveRDS(table_memory_stats, "_targets/objects/table_memory_stats")
saveRDS(table_manifest, "_targets/objects/table_manifest")

message("✓ Visualization targets generated successfully")
message("  - plot_build_times")
message("  - plot_memory_usage")
message("  - table_time_stats")
message("  - table_memory_stats")
message("  - table_manifest")
