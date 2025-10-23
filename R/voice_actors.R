#' Get Voice Actors
#'
#' @description
#' Returns a collection of voice actors filtered by query parameters. Voice actors
#' are used for vocabulary audio.
#'
#' @param ids Optional integer vector of voice actor IDs
#' @param updated_after Optional character timestamp (ISO 8601)
#' @param api_token Character string with your WaniKani API token
#'
#' @return A list containing voice actor data and pagination information. Each
#'   voice actor includes:
#'   \itemize{
#'     \item name: Name of the voice actor
#'     \item gender: Gender of the voice actor
#'     \item description: Description of the voice actor
#'   }
#'
#' @examples
#' \dontrun{
#' # Get all voice actors
#' voice_actors <- wk_voice_actors()
#' }
#'
#' @export
wk_voice_actors <- function(ids = NULL,
                            updated_after = NULL,
                            api_token = NULL) {
  client <- WaniKaniClient$new(api_token)

  query <- list()
  if (!is.null(ids)) query$ids <- paste(ids, collapse = ",")
  if (!is.null(updated_after)) query$updated_after <- updated_after

  client$get("/voice_actors", query = query)
}

#' Get Voice Actor by ID
#'
#' @description
#' Returns a specific voice actor by ID.
#'
#' @param id Integer voice actor ID
#' @param api_token Character string with your WaniKani API token
#'
#' @return A list containing voice actor data
#'
#' @examples
#' \dontrun{
#' voice_actor <- wk_voice_actors_by_id(1)
#' print(voice_actor$data$name)
#' }
#'
#' @export
wk_voice_actors_by_id <- function(id, api_token = NULL) {
  client <- WaniKaniClient$new(api_token)
  client$get(paste0("/voice_actors/", id))
}
