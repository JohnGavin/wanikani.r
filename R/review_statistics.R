#' Get Review Statistics
#'
#' @description
#' Returns a collection of review statistics filtered by query parameters. Review
#' statistics summarize a user's answers to reviews for individual subjects.
#'
#' @param ids Optional integer vector of review statistic IDs
#' @param subject_ids Optional integer vector of subject IDs
#' @param subject_types Optional character vector of subject types ("radical", "kanji", "vocabulary", "kana_vocabulary")
#' @param hidden Optional logical, filter for hidden review statistics
#' @param percentages_greater_than Optional integer (0-100), filter for statistics with percentage correct greater than this
#' @param percentages_less_than Optional integer (0-100), filter for statistics with percentage correct less than this
#' @param updated_after Optional character timestamp (ISO 8601)
#' @param api_token Character string with your WaniKani API token
#'
#' @return A list containing review statistics data and pagination information
#'
#' @examples
#' \dontrun{
#' # Get all review statistics
#' stats <- wk_review_statistics()
#'
#' # Get statistics for kanji with low accuracy
#' stats <- wk_review_statistics(
#'   subject_types = "kanji",
#'   percentages_less_than = 75
#' )
#'
#' # Get statistics for specific subjects
#' stats <- wk_review_statistics(subject_ids = c(440, 441, 442))
#' }
#'
#' @export
wk_review_statistics <- function(ids = NULL,
                                 subject_ids = NULL,
                                 subject_types = NULL,
                                 hidden = NULL,
                                 percentages_greater_than = NULL,
                                 percentages_less_than = NULL,
                                 updated_after = NULL,
                                 api_token = NULL) {
  client <- WaniKaniClient$new(api_token)

  query <- list()
  if (!is.null(ids)) query$ids <- paste(ids, collapse = ",")
  if (!is.null(subject_ids)) query$subject_ids <- paste(subject_ids, collapse = ",")
  if (!is.null(subject_types)) query$subject_types <- paste(subject_types, collapse = ",")
  if (!is.null(hidden)) query$hidden <- tolower(as.character(hidden))
  if (!is.null(percentages_greater_than)) query$percentages_greater_than <- percentages_greater_than
  if (!is.null(percentages_less_than)) query$percentages_less_than <- percentages_less_than
  if (!is.null(updated_after)) query$updated_after <- updated_after

  client$get("/review_statistics", query = query)
}

#' Get Review Statistic by ID
#'
#' @description
#' Returns a specific review statistic by ID.
#'
#' @param id Integer review statistic ID
#' @param api_token Character string with your WaniKani API token
#'
#' @return A list containing review statistic data including:
#'   \itemize{
#'     \item meaning_correct: Number of correct meaning answers
#'     \item meaning_incorrect: Number of incorrect meaning answers
#'     \item meaning_current_streak: Current streak of correct meaning answers
#'     \item meaning_max_streak: Maximum streak of correct meaning answers
#'     \item reading_correct: Number of correct reading answers
#'     \item reading_incorrect: Number of incorrect reading answers
#'     \item reading_current_streak: Current streak of correct reading answers
#'     \item reading_max_streak: Maximum streak of correct reading answers
#'     \item percentage_correct: Overall percentage of correct answers
#'   }
#'
#' @examples
#' \dontrun{
#' stats <- wk_review_statistics_by_id(123456)
#' print(stats$data$percentage_correct)
#' }
#'
#' @export
wk_review_statistics_by_id <- function(id, api_token = NULL) {
  client <- WaniKaniClient$new(api_token)
  client$get(paste0("/review_statistics/", id))
}
