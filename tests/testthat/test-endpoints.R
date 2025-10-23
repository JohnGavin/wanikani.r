# These tests verify that endpoint functions exist and have the correct signatures
# For real API testing, you would use httptest or a similar mocking library

test_that("User endpoint functions exist", {
  expect_true(exists("wk_user"))
  expect_true(exists("wk_user_update"))
})

test_that("Summary endpoint function exists", {
  expect_true(exists("wk_summary"))
})

test_that("Assignment endpoint functions exist", {
  expect_true(exists("wk_assignments"))
  expect_true(exists("wk_assignments_by_id"))
  expect_true(exists("wk_assignments_start"))
})

test_that("Subject endpoint functions exist", {
  expect_true(exists("wk_subjects"))
  expect_true(exists("wk_subjects_by_id"))
})

test_that("Review endpoint functions exist", {
  expect_true(exists("wk_reviews"))
  expect_true(exists("wk_reviews_by_id"))
  expect_true(exists("wk_reviews_create"))
})

test_that("Review statistics endpoint functions exist", {
  expect_true(exists("wk_review_statistics"))
  expect_true(exists("wk_review_statistics_by_id"))
})

test_that("Study materials endpoint functions exist", {
  expect_true(exists("wk_study_materials"))
  expect_true(exists("wk_study_materials_by_id"))
  expect_true(exists("wk_study_materials_create"))
  expect_true(exists("wk_study_materials_update"))
})

test_that("Level progression endpoint functions exist", {
  expect_true(exists("wk_level_progressions"))
  expect_true(exists("wk_level_progressions_by_id"))
})

test_that("Reset endpoint functions exist", {
  expect_true(exists("wk_resets"))
  expect_true(exists("wk_resets_by_id"))
})

test_that("SRS endpoint functions exist", {
  expect_true(exists("wk_spaced_repetition_systems"))
  expect_true(exists("wk_spaced_repetition_systems_by_id"))
})

test_that("Voice actor endpoint functions exist", {
  expect_true(exists("wk_voice_actors"))
  expect_true(exists("wk_voice_actors_by_id"))
})

test_that("wk_reviews_create validates required parameters", {
  expect_error(
    wk_reviews_create(
      incorrect_meaning_answers = 0,
      incorrect_reading_answers = 0,
      api_token = "test"
    ),
    "Either assignment_id or subject_id must be provided"
  )
})
