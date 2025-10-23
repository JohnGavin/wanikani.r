#' Fetch All Pages
#'
#' @description
#' Helper function to automatically fetch all pages of a paginated API response.
#' The WaniKani API uses cursor-based pagination.
#'
#' @param endpoint_function A function that returns paginated results (e.g., wk_subjects)
#' @param ... Additional arguments to pass to the endpoint function
#' @param max_pages Optional integer, maximum number of pages to fetch. NULL for all pages.
#' @param verbose Logical, whether to print progress messages
#'
#' @return A list containing all items from all pages
#'
#' @examples
#' \dontrun{
#' # Fetch all subjects
#' all_subjects <- wk_fetch_all_pages(wk_subjects)
#'
#' # Fetch all level 1 kanji (with limit)
#' kanji <- wk_fetch_all_pages(wk_subjects, types = "kanji", levels = 1, max_pages = 5)
#' }
#'
#' @export
wk_fetch_all_pages <- function(endpoint_function, ..., max_pages = NULL, verbose = TRUE) {
  all_data <- list()
  page_count <- 0
  next_url <- NULL

  # Get first page
  if (verbose) message("Fetching page 1...")
  response <- endpoint_function(...)
  all_data <- c(all_data, response$data)
  page_count <- 1

  # Check if there are more pages
  if (!is.null(response$pages) && !is.null(response$pages$next_url)) {
    next_url <- response$pages$next_url
  }

  # Fetch remaining pages
  while (!is.null(next_url)) {
    # Check if we've reached max_pages
    if (!is.null(max_pages) && page_count >= max_pages) {
      if (verbose) message(sprintf("Reached maximum page limit (%d)", max_pages))
      break
    }

    page_count <- page_count + 1
    if (verbose) message(sprintf("Fetching page %d...", page_count))

    # Extract query parameters from next_url
    # This is a simplified approach - in production you might want more robust URL parsing
    url_parts <- strsplit(next_url, "\\?")[[1]]
    if (length(url_parts) == 2) {
      query_string <- url_parts[2]
      query_params <- strsplit(query_string, "&")[[1]]

      # Parse page_after_id if present
      page_after_id <- NULL
      for (param in query_params) {
        if (grepl("^page_after_id=", param)) {
          page_after_id <- sub("^page_after_id=", "", param)
          break
        }
      }

      if (!is.null(page_after_id)) {
        # Add page_after_id to the original arguments
        args <- list(...)
        args$page_after_id <- page_after_id
        response <- do.call(endpoint_function, args)

        all_data <- c(all_data, response$data)

        # Update next_url
        if (!is.null(response$pages) && !is.null(response$pages$next_url)) {
          next_url <- response$pages$next_url
        } else {
          next_url <- NULL
        }
      } else {
        break
      }
    } else {
      break
    }
  }

  if (verbose) message(sprintf("Fetched %d total items from %d pages", length(all_data), page_count))

  list(
    data = all_data,
    page_count = page_count,
    total_count = length(all_data)
  )
}

#' Extract Data Items
#'
#' @description
#' Helper function to extract just the data items from an API response,
#' discarding metadata and pagination info.
#'
#' @param response An API response object
#'
#' @return The data items from the response
#'
#' @examples
#' \dontrun{
#' response <- wk_subjects(levels = 1)
#' subjects <- wk_extract_data(response)
#' }
#'
#' @export
wk_extract_data <- function(response) {
  if (is.null(response$data)) {
    warning("No data field found in response")
    return(NULL)
  }
  response$data
}

#' Get Next Page URL
#'
#' @description
#' Helper function to extract the next page URL from a paginated response.
#'
#' @param response An API response object
#'
#' @return Character string with next page URL, or NULL if no next page
#'
#' @examples
#' \dontrun{
#' response <- wk_subjects(levels = 1)
#' next_url <- wk_next_page_url(response)
#' }
#'
#' @export
wk_next_page_url <- function(response) {
  if (!is.null(response$pages) && !is.null(response$pages$next_url)) {
    return(response$pages$next_url)
  }
  NULL
}

#' Check if More Pages Exist
#'
#' @description
#' Helper function to check if there are more pages available.
#'
#' @param response An API response object
#'
#' @return Logical indicating if more pages are available
#'
#' @examples
#' \dontrun{
#' response <- wk_subjects(levels = 1)
#' if (wk_has_next_page(response)) {
#'   # Fetch next page
#' }
#' }
#'
#' @export
wk_has_next_page <- function(response) {
  !is.null(wk_next_page_url(response))
}
