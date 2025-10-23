# targets pipeline for wanikani package vignettes
# This pre-computes objects used in vignettes for faster building

library(targets)
library(tarchetypes)

# Set target-specific options
tar_option_set(
  packages = c("wanikani", "httr", "jsonlite"),
  format = "rds",
  memory = "transient",
  garbage_collection = TRUE
)

# Define the pipeline
list(
  # Example 1: Mock user data
  tar_target(
    example_user_data,
    {
      # Simulate API call with delay
      Sys.sleep(0.5)
      list(
        data = list(
          username = "example_user",
          level = 5,
          subscription = list(
            type = "recurring",
            active = TRUE,
            max_level_granted = 60
          ),
          current_vacation_started_at = NULL,
          profile_url = "https://www.wanikani.com/users/example_user",
          started_at = "2024-01-01T00:00:00.000000Z",
          preferences = list(
            default_voice_actor_id = 1,
            lessons_autoplay_audio = TRUE,
            lessons_batch_size = 5,
            lessons_presentation_order = "ascending_level_then_subject"
          )
        )
      )
    }
  ),

  # Example 2: Mock subject data (kanji)
  tar_target(
    example_subjects_kanji,
    {
      Sys.sleep(0.3)
      list(
        data = lapply(1:10, function(i) {
          list(
            id = 440 + i,
            object = "kanji",
            data = list(
              characters = c("一", "二", "三", "四", "五", "六", "七", "八", "九", "十")[i],
              meanings = list(
                list(meaning = c("one", "two", "three", "four", "five",
                                "six", "seven", "eight", "nine", "ten")[i],
                     primary = TRUE)
              ),
              level = 1,
              component_subject_ids = c(),
              amalgamation_subject_ids = c()
            )
          )
        })
      )
    }
  ),

  # Example 3: Mock assignment data
  tar_target(
    example_assignments,
    {
      Sys.sleep(0.4)
      list(
        data = lapply(1:20, function(i) {
          list(
            id = 1000 + i,
            object = "assignment",
            data = list(
              subject_id = 440 + (i %% 10),
              subject_type = "kanji",
              srs_stage = i %% 9,
              unlocked_at = "2024-01-01T00:00:00.000000Z",
              started_at = if(i > 5) "2024-01-02T00:00:00.000000Z" else NULL,
              passed_at = if(i > 10) "2024-01-10T00:00:00.000000Z" else NULL,
              burned_at = if(i > 15) "2024-02-01T00:00:00.000000Z" else NULL
            )
          )
        })
      )
    }
  ),

  # Example 4: Mock review statistics
  tar_target(
    example_review_stats,
    {
      Sys.sleep(0.6)
      list(
        data = lapply(1:10, function(i) {
          list(
            id = 2000 + i,
            object = "review_statistic",
            data = list(
              subject_id = 440 + i,
              meaning_correct = sample(10:50, 1),
              meaning_incorrect = sample(0:10, 1),
              meaning_current_streak = sample(0:20, 1),
              reading_correct = sample(10:50, 1),
              reading_incorrect = sample(0:10, 1),
              reading_current_streak = sample(0:20, 1),
              percentage_correct = sample(70:100, 1)
            )
          )
        })
      )
    }
  ),

  # Example 5: Derived target - calculate summary statistics
  tar_target(
    summary_statistics,
    {
      list(
        total_subjects = length(example_subjects_kanji$data),
        total_assignments = length(example_assignments$data),
        user_level = example_user_data$data$level,
        avg_percentage_correct = mean(sapply(example_review_stats$data,
                                            function(x) x$data$percentage_correct))
      )
    }
  ),

  # Example 6: Pipeline metadata
  tar_target(
    pipeline_metadata,
    {
      list(
        pipeline_name = "wanikani_vignettes",
        created_at = Sys.time(),
        r_version = R.version.string,
        platform = R.version$platform,
        targets_version = packageVersion("targets")
      )
    }
  )
)
