#' wanikani: R Client for the WaniKani API
#'
#' @description
#' This package provides a complete interface to the WaniKani API v2.
#' WaniKani is a Japanese learning platform that uses spaced repetition
#' to teach kanji and vocabulary.
#'
#' @section Main Features:
#' \itemize{
#'   \item Complete coverage of all WaniKani API v2 endpoints
#'   \item Automatic rate limit tracking
#'   \item Pagination helpers
#'   \item R6 class for advanced usage
#'   \item Comprehensive documentation and examples
#' }
#'
#' @section Getting Started:
#' To use this package, you need a WaniKani API token from:
#' https://www.wanikani.com/settings/personal_access_tokens
#'
#' Set it as an environment variable:
#' \preformatted{
#' Sys.setenv(WANIKANI_API_TOKEN = "your_token_here")
#' }
#'
#' Then start using the API:
#' \preformatted{
#' user <- wk_user()
#' subjects <- wk_subjects(levels = 1)
#' }
#'
#' @section Available Endpoints:
#' \itemize{
#'   \item User: \code{\link{wk_user}}, \code{\link{wk_user_update}}
#'   \item Summary: \code{\link{wk_summary}}
#'   \item Assignments: \code{\link{wk_assignments}}, \code{\link{wk_assignments_by_id}}, \code{\link{wk_assignments_start}}
#'   \item Subjects: \code{\link{wk_subjects}}, \code{\link{wk_subjects_by_id}}
#'   \item Reviews: \code{\link{wk_reviews}}, \code{\link{wk_reviews_by_id}}, \code{\link{wk_reviews_create}}
#'   \item Review Statistics: \code{\link{wk_review_statistics}}, \code{\link{wk_review_statistics_by_id}}
#'   \item Study Materials: \code{\link{wk_study_materials}}, \code{\link{wk_study_materials_by_id}}, \code{\link{wk_study_materials_create}}, \code{\link{wk_study_materials_update}}
#'   \item Level Progressions: \code{\link{wk_level_progressions}}, \code{\link{wk_level_progressions_by_id}}
#'   \item Resets: \code{\link{wk_resets}}, \code{\link{wk_resets_by_id}}
#'   \item SRS: \code{\link{wk_spaced_repetition_systems}}, \code{\link{wk_spaced_repetition_systems_by_id}}
#'   \item Voice Actors: \code{\link{wk_voice_actors}}, \code{\link{wk_voice_actors_by_id}}
#' }
#'
#' @docType package
#' @name wanikani-package
#' @aliases wanikani
#' @keywords internal
"_PACKAGE"

## usethis namespace: start
## usethis namespace: end
NULL
