test_that("wk_extract_data returns data field from response", {
  response <- list(
    data = list(item1 = "value1", item2 = "value2"),
    pages = list(next_url = NULL)
  )

  result <- wk_extract_data(response)
  expect_equal(result, response$data)
})

test_that("wk_extract_data warns when no data field", {
  response <- list(pages = list(next_url = NULL))

  expect_warning(
    result <- wk_extract_data(response),
    "No data field found"
  )
  expect_null(result)
})

test_that("wk_next_page_url returns next URL when available", {
  response <- list(
    data = list(),
    pages = list(next_url = "https://api.wanikani.com/v2/subjects?page_after_id=123")
  )

  result <- wk_next_page_url(response)
  expect_equal(result, "https://api.wanikani.com/v2/subjects?page_after_id=123")
})

test_that("wk_next_page_url returns NULL when no next page", {
  response <- list(
    data = list(),
    pages = list(next_url = NULL)
  )

  result <- wk_next_page_url(response)
  expect_null(result)
})

test_that("wk_has_next_page returns TRUE when next page exists", {
  response <- list(
    data = list(),
    pages = list(next_url = "https://api.wanikani.com/v2/subjects?page_after_id=123")
  )

  expect_true(wk_has_next_page(response))
})

test_that("wk_has_next_page returns FALSE when no next page", {
  response <- list(
    data = list(),
    pages = list(next_url = NULL)
  )

  expect_false(wk_has_next_page(response))
})
