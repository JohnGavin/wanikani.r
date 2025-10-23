#' Get Reviews
#'
#' @description
#' Returns a collection of reviews filtered by query parameters. Reviews log all
#' the correct and incorrect answers provided through the 'Reviews' section of WaniKani.
#'
#' @param ids Optional integer vector of review IDs
#' @param assignment_ids Optional integer vector of assignment IDs
#' @param subject_ids Optional integer vector of subject IDs
#' @param updated_after Optional character timestamp (ISO 8601)
#' @param api_token Character string with your WaniKani API token
#'
#' @return A list containing review data and pagination information
#'
#' @examples
#' \dontrun{
#' # Get all reviews
#' reviews <- wk_reviews()
#'
#' # Get reviews for specific assignments
#' reviews <- wk_reviews(assignment_ids = c(123, 456, 789))
#'
#' # Get recent reviews
#' reviews <- wk_reviews(updated_after = "2024-01-01T00:00:00Z")
#' }
#'
#' @export
wk_reviews <- function(ids = NULL,
                       assignment_ids = NULL,
                       subject_ids = NULL,
                       updated_after = NULL,
                       api_token = NULL) {
  client <- WaniKaniClient$new(api_token)

  query <- list()
  if (!is.null(ids)) query$ids <- paste(ids, collapse = ",")
  if (!is.null(assignment_ids)) query$assignment_ids <- paste(assignment_ids, collapse = ",")
  if (!is.null(subject_ids)) query$subject_ids <- paste(subject_ids, collapse = ",")
  if (!is.null(updated_after)) query$updated_after <- updated_after

  client$get("/reviews", query = query)
}

#' Get Review by ID
#'
#' @description
#' Returns a specific review by ID.
#'
#' @param id Integer review ID
#' @param api_token Character string with your WaniKani API token
#'
#' @return A list containing review data
#'
#' @examples
#' \dontrun{
#' review <- wk_reviews_by_id(123456)
#' }
#'
#' @export
wk_reviews_by_id <- function(id, api_token = NULL) {
  client <- WaniKaniClient$new(api_token)
  client$get(paste0("/reviews/", id))
}

#' Create a Review
#'
#' @description
#' Creates a review for a specific assignment or subject. Reviews record the
#' outcome of a review session.
#'
#' @param assignment_id Optional integer assignment ID (either this or subject_id required)
#' @param subject_id Optional integer subject ID (either this or assignment_id required)
#' @param incorrect_meaning_answers Integer number of incorrect meaning answers
#' @param incorrect_reading_answers Integer number of incorrect reading answers
#' @param created_at Optional character timestamp (ISO 8601). Defaults to current time.
#' @param api_token Character string with your WaniKani API token
#'
#' @return A list containing the created review data
#'
#' @examples
#' \dontrun{
#' # Create a review for an assignment
#' review <- wk_reviews_create(
#'   assignment_id = 123456,
#'   incorrect_meaning_answers = 0,
#'   incorrect_reading_answers = 1
#' )
#'
#' # Create a review for a subject
#' review <- wk_reviews_create(
#'   subject_id = 440,
#'   incorrect_meaning_answers = 2,
#'   incorrect_reading_answers = 0,
#'   created_at = "2024-01-15T10:30:00Z"
#' )
#' }
#'
#' @export
wk_reviews_create <- function(assignment_id = NULL,
                              subject_id = NULL,
                              incorrect_meaning_answers,
                              incorrect_reading_answers,
                              created_at = NULL,
                              api_token = NULL) {
  if (is.null(assignment_id) && is.null(subject_id)) {
    stop("Either assignment_id or subject_id must be provided")
  }

  client <- WaniKaniClient$new(api_token)

  review_data <- list(
    incorrect_meaning_answers = incorrect_meaning_answers,
    incorrect_reading_answers = incorrect_reading_answers
  )

  if (!is.null(assignment_id)) {
    review_data$assignment_id <- assignment_id
  }
  if (!is.null(subject_id)) {
    review_data$subject_id <- subject_id
  }
  if (!is.null(created_at)) {
    review_data$created_at <- created_at
  }

  body <- list(review = review_data)
  client$post("/reviews", body = body)
}
