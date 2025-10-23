#' Get Resets
#'
#' @description
#' Returns a collection of resets filtered by query parameters. Resets contain
#' information about when users reset their progress.
#'
#' @param ids Optional integer vector of reset IDs
#' @param updated_after Optional character timestamp (ISO 8601)
#' @param api_token Character string with your WaniKani API token
#'
#' @return A list containing reset data and pagination information. Each reset includes:
#'   \itemize{
#'     \item created_at: When the reset was created
#'     \item original_level: The level before the reset
#'     \item target_level: The level after the reset
#'     \item confirmed_at: When the reset was confirmed
#'   }
#'
#' @examples
#' \dontrun{
#' # Get all resets
#' resets <- wk_resets()
#'
#' # Get recent resets
#' resets <- wk_resets(updated_after = "2024-01-01T00:00:00Z")
#' }
#'
#' @export
wk_resets <- function(ids = NULL,
                      updated_after = NULL,
                      api_token = NULL) {
  client <- WaniKaniClient$new(api_token)

  query <- list()
  if (!is.null(ids)) query$ids <- paste(ids, collapse = ",")
  if (!is.null(updated_after)) query$updated_after <- updated_after

  client$get("/resets", query = query)
}

#' Get Reset by ID
#'
#' @description
#' Returns a specific reset by ID.
#'
#' @param id Integer reset ID
#' @param api_token Character string with your WaniKani API token
#'
#' @return A list containing reset data
#'
#' @examples
#' \dontrun{
#' reset <- wk_resets_by_id(123456)
#' }
#'
#' @export
wk_resets_by_id <- function(id, api_token = NULL) {
  client <- WaniKaniClient$new(api_token)
  client$get(paste0("/resets/", id))
}
