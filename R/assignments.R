#' Get Assignments
#'
#' @description
#' Returns a collection of assignments filtered by query parameters. Assignments
#' contain information about a user's progress on a particular subject.
#'
#' @param ids Optional integer vector of assignment IDs
#' @param subject_ids Optional integer vector of subject IDs
#' @param subject_types Optional character vector of subject types ("radical", "kanji", "vocabulary")
#' @param levels Optional integer vector of levels (1-60)
#' @param srs_stages Optional integer vector of SRS stage numbers (0-9)
#' @param unlocked Optional logical, filter for unlocked assignments
#' @param started Optional logical, filter for started assignments
#' @param burned Optional logical, filter for burned assignments
#' @param hidden Optional logical, filter for hidden assignments
#' @param available_before Optional character timestamp (ISO 8601)
#' @param available_after Optional character timestamp (ISO 8601)
#' @param updated_after Optional character timestamp (ISO 8601)
#' @param api_token Character string with your WaniKani API token
#'
#' @return A list containing assignment data and pagination information
#'
#' @examples
#' \dontrun{
#' # Get all unlocked assignments
#' assignments <- wk_assignments(unlocked = TRUE)
#'
#' # Get assignments for specific levels
#' assignments <- wk_assignments(levels = c(1, 2, 3))
#'
#' # Get kanji assignments at SRS stage 4 or higher
#' assignments <- wk_assignments(subject_types = "kanji", srs_stages = c(4:9))
#' }
#'
#' @export
wk_assignments <- function(ids = NULL,
                           subject_ids = NULL,
                           subject_types = NULL,
                           levels = NULL,
                           srs_stages = NULL,
                           unlocked = NULL,
                           started = NULL,
                           burned = NULL,
                           hidden = NULL,
                           available_before = NULL,
                           available_after = NULL,
                           updated_after = NULL,
                           api_token = NULL) {
  client <- WaniKaniClient$new(api_token)

  query <- list()
  if (!is.null(ids)) query$ids <- paste(ids, collapse = ",")
  if (!is.null(subject_ids)) query$subject_ids <- paste(subject_ids, collapse = ",")
  if (!is.null(subject_types)) query$subject_types <- paste(subject_types, collapse = ",")
  if (!is.null(levels)) query$levels <- paste(levels, collapse = ",")
  if (!is.null(srs_stages)) query$srs_stages <- paste(srs_stages, collapse = ",")
  if (!is.null(unlocked)) query$unlocked <- tolower(as.character(unlocked))
  if (!is.null(started)) query$started <- tolower(as.character(started))
  if (!is.null(burned)) query$burned <- tolower(as.character(burned))
  if (!is.null(hidden)) query$hidden <- tolower(as.character(hidden))
  if (!is.null(available_before)) query$available_before <- available_before
  if (!is.null(available_after)) query$available_after <- available_after
  if (!is.null(updated_after)) query$updated_after <- updated_after

  client$get("/assignments", query = query)
}

#' Get Assignment by ID
#'
#' @description
#' Returns a specific assignment by ID.
#'
#' @param id Integer assignment ID
#' @param api_token Character string with your WaniKani API token
#'
#' @return A list containing assignment data
#'
#' @examples
#' \dontrun{
#' assignment <- wk_assignments_by_id(123456)
#' }
#'
#' @export
wk_assignments_by_id <- function(id, api_token = NULL) {
  client <- WaniKaniClient$new(api_token)
  client$get(paste0("/assignments/", id))
}

#' Start an Assignment
#'
#' @description
#' Marks an assignment as started, moving the assignment from the lessons queue
#' to the review queue. Assignments are started when the user starts a lesson.
#'
#' @param id Integer assignment ID
#' @param started_at Optional character timestamp (ISO 8601). Defaults to current time.
#' @param api_token Character string with your WaniKani API token
#'
#' @return A list containing updated assignment data
#'
#' @examples
#' \dontrun{
#' # Start an assignment now
#' assignment <- wk_assignments_start(123456)
#'
#' # Start an assignment at a specific time
#' assignment <- wk_assignments_start(123456, started_at = "2024-01-15T09:00:00Z")
#' }
#'
#' @export
wk_assignments_start <- function(id, started_at = NULL, api_token = NULL) {
  client <- WaniKaniClient$new(api_token)
  body <- list()
  if (!is.null(started_at)) {
    body$started_at <- started_at
  }
  client$put(paste0("/assignments/", id, "/start"), body = body)
}
