test_that("WaniKaniClient initialization requires API token", {
  # Clear environment variable
  old_token <- Sys.getenv("WANIKANI_API_TOKEN")
  Sys.setenv(WANIKANI_API_TOKEN = "")

  expect_error(
    WaniKaniClient$new(),
    "API token must be provided"
  )

  # Restore
  Sys.setenv(WANIKANI_API_TOKEN = old_token)
})

test_that("WaniKaniClient initialization works with token parameter", {
  client <- WaniKaniClient$new(api_token = "test_token")
  expect_equal(client$api_token, "test_token")
  expect_equal(client$base_url, "https://api.wanikani.com/v2")
})

test_that("WaniKaniClient initialization works with environment variable", {
  old_token <- Sys.getenv("WANIKANI_API_TOKEN")
  Sys.setenv(WANIKANI_API_TOKEN = "env_token")

  client <- WaniKaniClient$new()
  expect_equal(client$api_token, "env_token")

  Sys.setenv(WANIKANI_API_TOKEN = old_token)
})

test_that("Client has expected methods", {
  client <- WaniKaniClient$new(api_token = "test_token")
  expect_true(is.function(client$get))
  expect_true(is.function(client$post))
  expect_true(is.function(client$put))
})
