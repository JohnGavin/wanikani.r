#' Get Spaced Repetition Systems
#'
#' @description
#' Returns a collection of spaced repetition systems (SRS) filtered by query
#' parameters. SRS contain information about the spaced repetition stages and
#' their intervals.
#'
#' @param ids Optional integer vector of SRS IDs
#' @param updated_after Optional character timestamp (ISO 8601)
#' @param api_token Character string with your WaniKani API token
#'
#' @return A list containing SRS data and pagination information. Each SRS includes:
#'   \itemize{
#'     \item name: Name of the SRS system
#'     \item description: Description of the SRS system
#'     \item unlocking_stage_position: Stage when item is unlocked
#'     \item starting_stage_position: Stage when item is started
#'     \item passing_stage_position: Stage when item is passed
#'     \item burning_stage_position: Stage when item is burned
#'     \item stages: Array of stage objects with intervals
#'   }
#'
#' @examples
#' \dontrun{
#' # Get all SRS systems
#' srs <- wk_spaced_repetition_systems()
#' }
#'
#' @export
wk_spaced_repetition_systems <- function(ids = NULL,
                                         updated_after = NULL,
                                         api_token = NULL) {
  client <- WaniKaniClient$new(api_token)

  query <- list()
  if (!is.null(ids)) query$ids <- paste(ids, collapse = ",")
  if (!is.null(updated_after)) query$updated_after <- updated_after

  client$get("/spaced_repetition_systems", query = query)
}

#' Get Spaced Repetition System by ID
#'
#' @description
#' Returns a specific spaced repetition system by ID.
#'
#' @param id Integer SRS ID
#' @param api_token Character string with your WaniKani API token
#'
#' @return A list containing SRS data
#'
#' @examples
#' \dontrun{
#' srs <- wk_spaced_repetition_systems_by_id(1)
#' print(srs$data$name)
#' print(length(srs$data$stages))
#' }
#'
#' @export
wk_spaced_repetition_systems_by_id <- function(id, api_token = NULL) {
  client <- WaniKaniClient$new(api_token)
  client$get(paste0("/spaced_repetition_systems/", id))
}
