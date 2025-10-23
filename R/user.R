#' Get User Information
#'
#' @description
#' Returns information about the authenticated user including their subscription,
#' level, and preferences.
#'
#' @param api_token Character string with your WaniKani API token. If NULL, uses
#'   the WANIKANI_API_TOKEN environment variable.
#'
#' @return A list containing user information including:
#'   \itemize{
#'     \item id: User ID
#'     \item username: Username
#'     \item level: Current level
#'     \item subscription: Subscription details
#'     \item current_vacation_started_at: Vacation mode start time
#'     \item preferences: User preferences
#'   }
#'
#' @examples
#' \dontrun{
#' user <- wk_user()
#' print(user$data$level)
#' }
#'
#' @export
wk_user <- function(api_token = NULL) {
  client <- WaniKaniClient$new(api_token)
  client$get("/user")
}

#' Update User Preferences
#'
#' @description
#' Updates the user's preferences.
#'
#' @param preferences A named list containing preference settings to update.
#' @param api_token Character string with your WaniKani API token. If NULL, uses
#'   the WANIKANI_API_TOKEN environment variable.
#'
#' @return A list containing updated user information.
#'
#' @examples
#' \dontrun{
#' # Update user preferences
#' prefs <- list(
#'   lessons_autoplay_audio = TRUE,
#'   lessons_batch_size = 5
#' )
#' user <- wk_user_update(preferences = prefs)
#' }
#'
#' @export
wk_user_update <- function(preferences, api_token = NULL) {
  client <- WaniKaniClient$new(api_token)
  body <- list(user = list(preferences = preferences))
  client$put("/user", body = body)
}
