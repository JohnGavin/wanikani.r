#' Get Subjects
#'
#' @description
#' Returns a collection of subjects (radicals, kanji, or vocabulary) filtered by
#' query parameters. Subjects are the things that users learn through assignments.
#'
#' @param ids Optional integer vector of subject IDs
#' @param types Optional character vector of subject types ("radical", "kanji", "vocabulary", "kana_vocabulary")
#' @param slugs Optional character vector of subject slugs
#' @param levels Optional integer vector of levels (1-60)
#' @param updated_after Optional character timestamp (ISO 8601)
#' @param api_token Character string with your WaniKani API token
#'
#' @return A list containing subject data and pagination information. Each subject
#'   includes meanings, readings (for kanji/vocabulary), components, and other metadata.
#'
#' @examples
#' \dontrun{
#' # Get all subjects from level 1
#' subjects <- wk_subjects(levels = 1)
#'
#' # Get all kanji from levels 1-3
#' kanji <- wk_subjects(types = "kanji", levels = c(1, 2, 3))
#'
#' # Get subjects by ID
#' subjects <- wk_subjects(ids = c(440, 441, 442))
#' }
#'
#' @export
wk_subjects <- function(ids = NULL,
                        types = NULL,
                        slugs = NULL,
                        levels = NULL,
                        updated_after = NULL,
                        api_token = NULL) {
  client <- WaniKaniClient$new(api_token)

  query <- list()
  if (!is.null(ids)) query$ids <- paste(ids, collapse = ",")
  if (!is.null(types)) query$types <- paste(types, collapse = ",")
  if (!is.null(slugs)) query$slugs <- paste(slugs, collapse = ",")
  if (!is.null(levels)) query$levels <- paste(levels, collapse = ",")
  if (!is.null(updated_after)) query$updated_after <- updated_after

  client$get("/subjects", query = query)
}

#' Get Subject by ID
#'
#' @description
#' Returns a specific subject by ID.
#'
#' @param id Integer subject ID
#' @param api_token Character string with your WaniKani API token
#'
#' @return A list containing subject data including:
#'   \itemize{
#'     \item characters: The UTF-8 characters for the subject
#'     \item meanings: Array of meaning objects
#'     \item readings: Array of reading objects (kanji/vocabulary only)
#'     \item component_subject_ids: IDs of component subjects (kanji/vocabulary)
#'     \item amalgamation_subject_ids: IDs of subjects that use this as a component
#'     \item lesson_position: Position in lessons
#'   }
#'
#' @examples
#' \dontrun{
#' subject <- wk_subjects_by_id(440)
#' print(subject$data$characters)
#' }
#'
#' @export
wk_subjects_by_id <- function(id, api_token = NULL) {
  client <- WaniKaniClient$new(api_token)
  client$get(paste0("/subjects/", id))
}
