#' Get Level Progressions
#'
#' @description
#' Returns a collection of level progressions filtered by query parameters. Level
#' progressions track a user's progress through WaniKani levels.
#'
#' @param ids Optional integer vector of level progression IDs
#' @param updated_after Optional character timestamp (ISO 8601)
#' @param api_token Character string with your WaniKani API token
#'
#' @return A list containing level progression data and pagination information. Each
#'   level progression includes:
#'   \itemize{
#'     \item level: The level number
#'     \item created_at: When the level was started
#'     \item unlocked_at: When the level was unlocked
#'     \item started_at: When the level lessons were started
#'     \item passed_at: When the level was passed
#'     \item completed_at: When all items reached guru or higher
#'     \item abandoned_at: When the level was reset
#'   }
#'
#' @examples
#' \dontrun{
#' # Get all level progressions
#' progressions <- wk_level_progressions()
#'
#' # Get recent level progressions
#' progressions <- wk_level_progressions(updated_after = "2024-01-01T00:00:00Z")
#' }
#'
#' @export
wk_level_progressions <- function(ids = NULL,
                                  updated_after = NULL,
                                  api_token = NULL) {
  client <- WaniKaniClient$new(api_token)

  query <- list()
  if (!is.null(ids)) query$ids <- paste(ids, collapse = ",")
  if (!is.null(updated_after)) query$updated_after <- updated_after

  client$get("/level_progressions", query = query)
}

#' Get Level Progression by ID
#'
#' @description
#' Returns a specific level progression by ID.
#'
#' @param id Integer level progression ID
#' @param api_token Character string with your WaniKani API token
#'
#' @return A list containing level progression data
#'
#' @examples
#' \dontrun{
#' progression <- wk_level_progressions_by_id(123456)
#' print(progression$data$level)
#' }
#'
#' @export
wk_level_progressions_by_id <- function(id, api_token = NULL) {
  client <- WaniKaniClient$new(api_token)
  client$get(paste0("/level_progressions/", id))
}
