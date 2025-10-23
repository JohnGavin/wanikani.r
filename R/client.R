#' WaniKani API Client
#'
#' @description
#' An R6 class for interacting with the WaniKani API v2. This client handles
#' authentication, rate limiting, and provides methods for all API endpoints.
#'
#' @details
#' The WaniKani API uses bearer token authentication. You can obtain an API token
#' from your WaniKani account settings at: https://www.wanikani.com/settings/personal_access_tokens
#'
#' The API has a rate limit of 60 requests per minute. This client tracks rate limit
#' information from response headers.
#'
#' @examples
#' \dontrun{
#' # Create a client with your API token
#' client <- WaniKaniClient$new(api_token = "your_token_here")
#'
#' # Get user information
#' user <- client$user()
#'
#' # Get all assignments
#' assignments <- client$assignments()
#'
#' # Get subjects with filters
#' subjects <- client$subjects(levels = c(1, 2), types = "kanji")
#' }
#'
#' @importFrom R6 R6Class
#' @importFrom httr GET POST PUT add_headers content http_error status_code http_status content_type_json
#' @importFrom jsonlite fromJSON toJSON
#' @export
WaniKaniClient <- R6::R6Class(
  "WaniKaniClient",

  public = list(
    #' @field base_url The base URL for the WaniKani API
    base_url = "https://api.wanikani.com/v2",

    #' @field api_token The API token for authentication
    api_token = NULL,

    #' @field rate_limit_remaining Remaining requests in current window
    rate_limit_remaining = NULL,

    #' @field rate_limit_reset Timestamp when rate limit resets
    rate_limit_reset = NULL,

    #' @description
    #' Create a new WaniKani API client
    #'
    #' @param api_token Character string with your WaniKani API token
    #' @return A new `WaniKaniClient` object
    initialize = function(api_token = NULL) {
      if (is.null(api_token)) {
        api_token <- Sys.getenv("WANIKANI_API_TOKEN")
        if (api_token == "") {
          stop("API token must be provided or set in WANIKANI_API_TOKEN environment variable")
        }
      }
      self$api_token <- api_token
    },

    #' @description
    #' Make a GET request to the API
    #'
    #' @param endpoint Character string with the API endpoint
    #' @param query Named list of query parameters
    #' @return Parsed JSON response
    get = function(endpoint, query = NULL) {
      private$request("GET", endpoint, query = query)
    },

    #' @description
    #' Make a POST request to the API
    #'
    #' @param endpoint Character string with the API endpoint
    #' @param body Named list with request body
    #' @return Parsed JSON response
    post = function(endpoint, body = NULL) {
      private$request("POST", endpoint, body = body)
    },

    #' @description
    #' Make a PUT request to the API
    #'
    #' @param endpoint Character string with the API endpoint
    #' @param body Named list with request body
    #' @return Parsed JSON response
    put = function(endpoint, body = NULL) {
      private$request("PUT", endpoint, body = body)
    }
  ),

  private = list(
    request = function(method, endpoint, query = NULL, body = NULL) {
      url <- paste0(self$base_url, endpoint)

      headers <- httr::add_headers(
        Authorization = paste("Bearer", self$api_token),
        `Wanikani-Revision` = "20170710"
      )

      response <- switch(
        method,
        GET = httr::GET(url, headers, query = query),
        POST = httr::POST(url, headers, body = jsonlite::toJSON(body, auto_unbox = TRUE),
                         httr::content_type_json()),
        PUT = httr::PUT(url, headers, body = jsonlite::toJSON(body, auto_unbox = TRUE),
                       httr::content_type_json()),
        stop("Unsupported HTTP method: ", method)
      )

      # Update rate limit info
      self$rate_limit_remaining <- as.integer(response$headers$`ratelimit-remaining`)
      self$rate_limit_reset <- as.integer(response$headers$`ratelimit-reset`)

      # Check for errors
      if (httr::http_error(response)) {
        status <- httr::status_code(response)
        if (status == 429) {
          stop("Rate limit exceeded. Try again after: ",
               as.POSIXct(self$rate_limit_reset, origin = "1970-01-01"))
        }
        error_content <- httr::content(response, "text", encoding = "UTF-8")
        stop(sprintf("API request failed [%s]: %s", status, error_content))
      }

      # Parse and return response
      result <- httr::content(response, "text", encoding = "UTF-8")
      jsonlite::fromJSON(result, simplifyVector = FALSE)
    }
  )
)
