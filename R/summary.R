#' Get Summary
#'
#' @description
#' Returns a summary report including lesson and review counts for the next 24 hours,
#' organized by hour.
#'
#' @param api_token Character string with your WaniKani API token. If NULL, uses
#'   the WANIKANI_API_TOKEN environment variable.
#'
#' @return A list containing:
#'   \itemize{
#'     \item lessons: Array of lessons with available_at timestamps
#'     \item next_reviews_at: Timestamp of next review
#'     \item reviews: Array of reviews with available_at timestamps
#'   }
#'
#' @examples
#' \dontrun{
#' summary <- wk_summary()
#' print(summary$data$next_reviews_at)
#' print(length(summary$data$reviews))
#' }
#'
#' @export
wk_summary <- function(api_token = NULL) {
  client <- WaniKaniClient$new(api_token)
  client$get("/summary")
}
