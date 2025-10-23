#' Get Study Materials
#'
#' @description
#' Returns a collection of study materials filtered by query parameters. Study
#' materials store user-specific notes and synonyms for subjects.
#'
#' @param ids Optional integer vector of study material IDs
#' @param subject_ids Optional integer vector of subject IDs
#' @param subject_types Optional character vector of subject types ("radical", "kanji", "vocabulary", "kana_vocabulary")
#' @param hidden Optional logical, filter for hidden study materials
#' @param updated_after Optional character timestamp (ISO 8601)
#' @param api_token Character string with your WaniKani API token
#'
#' @return A list containing study materials data and pagination information
#'
#' @examples
#' \dontrun{
#' # Get all study materials
#' materials <- wk_study_materials()
#'
#' # Get study materials for specific subjects
#' materials <- wk_study_materials(subject_ids = c(440, 441, 442))
#'
#' # Get study materials for kanji
#' materials <- wk_study_materials(subject_types = "kanji")
#' }
#'
#' @export
wk_study_materials <- function(ids = NULL,
                               subject_ids = NULL,
                               subject_types = NULL,
                               hidden = NULL,
                               updated_after = NULL,
                               api_token = NULL) {
  client <- WaniKaniClient$new(api_token)

  query <- list()
  if (!is.null(ids)) query$ids <- paste(ids, collapse = ",")
  if (!is.null(subject_ids)) query$subject_ids <- paste(subject_ids, collapse = ",")
  if (!is.null(subject_types)) query$subject_types <- paste(subject_types, collapse = ",")
  if (!is.null(hidden)) query$hidden <- tolower(as.character(hidden))
  if (!is.null(updated_after)) query$updated_after <- updated_after

  client$get("/study_materials", query = query)
}

#' Get Study Material by ID
#'
#' @description
#' Returns a specific study material by ID.
#'
#' @param id Integer study material ID
#' @param api_token Character string with your WaniKani API token
#'
#' @return A list containing study material data
#'
#' @examples
#' \dontrun{
#' material <- wk_study_materials_by_id(123456)
#' }
#'
#' @export
wk_study_materials_by_id <- function(id, api_token = NULL) {
  client <- WaniKaniClient$new(api_token)
  client$get(paste0("/study_materials/", id))
}

#' Create Study Material
#'
#' @description
#' Creates a study material for a specific subject.
#'
#' @param subject_id Integer subject ID (required)
#' @param meaning_note Optional character string with meaning mnemonic notes
#' @param reading_note Optional character string with reading mnemonic notes
#' @param meaning_synonyms Optional character vector of meaning synonyms
#' @param api_token Character string with your WaniKani API token
#'
#' @return A list containing the created study material data
#'
#' @examples
#' \dontrun{
#' # Create study material with notes and synonyms
#' material <- wk_study_materials_create(
#'   subject_id = 440,
#'   meaning_note = "Think of a tall tree",
#'   meaning_synonyms = c("tree", "wood")
#' )
#' }
#'
#' @export
wk_study_materials_create <- function(subject_id,
                                     meaning_note = NULL,
                                     reading_note = NULL,
                                     meaning_synonyms = NULL,
                                     api_token = NULL) {
  client <- WaniKaniClient$new(api_token)

  study_material <- list(subject_id = subject_id)

  if (!is.null(meaning_note)) {
    study_material$meaning_note <- meaning_note
  }
  if (!is.null(reading_note)) {
    study_material$reading_note <- reading_note
  }
  if (!is.null(meaning_synonyms)) {
    study_material$meaning_synonyms <- meaning_synonyms
  }

  body <- list(study_material = study_material)
  client$post("/study_materials", body = body)
}

#' Update Study Material
#'
#' @description
#' Updates an existing study material.
#'
#' @param id Integer study material ID
#' @param meaning_note Optional character string with meaning mnemonic notes
#' @param reading_note Optional character string with reading mnemonic notes
#' @param meaning_synonyms Optional character vector of meaning synonyms
#' @param api_token Character string with your WaniKani API token
#'
#' @return A list containing the updated study material data
#'
#' @examples
#' \dontrun{
#' # Update study material
#' material <- wk_study_materials_update(
#'   id = 123456,
#'   meaning_note = "Updated mnemonic",
#'   meaning_synonyms = c("new", "synonyms")
#' )
#' }
#'
#' @export
wk_study_materials_update <- function(id,
                                     meaning_note = NULL,
                                     reading_note = NULL,
                                     meaning_synonyms = NULL,
                                     api_token = NULL) {
  client <- WaniKaniClient$new(api_token)

  study_material <- list()

  if (!is.null(meaning_note)) {
    study_material$meaning_note <- meaning_note
  }
  if (!is.null(reading_note)) {
    study_material$reading_note <- reading_note
  }
  if (!is.null(meaning_synonyms)) {
    study_material$meaning_synonyms <- meaning_synonyms
  }

  body <- list(study_material = study_material)
  client$put(paste0("/study_materials/", id), body = body)
}
