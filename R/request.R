# Convert query list to the string
#' @include utils.R
prepare_query <- function(query) {
    query <- compact(query)
    params <- names(query)
    params <- sub("profile.id", "ids", params, fixed = TRUE)
    params <- sub("sampling.level", "samplingLevel", params, fixed = TRUE)
    params <- gsub(".", "-", params, fixed = TRUE)
    names(query) <- params
    return(query)
}

# Error printing function
#' @include utils.R
#' @importFrom httr http_status
#' @importFrom utils capture.output
error_message <- function(x) {
    code <- x$error$code
    message <- http_status(code)$message
    reasons <- x$error$errors[, -1L]
    reasons$reason <- to_separated(reasons$reason, sep = " ")
    reasons <- paste(capture.output(print(reasons, right = FALSE)), collapse = "\n")
    stop(message, "\n", reasons, call. = FALSE)
}

#' @title Get a Google Analytics API response
#'
#' @param type character string including report type.
#' @param path character including a request path.
#' @param query list including a request parameters.
#' @param simplify logical. Coerce JSON arrays to a vector, matrix or data frame.
#' @param flatten logical. Automatically flatten nested data frames into a single non-nested data frame.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#'
#' @return A list contatin Google Analytics API response.
#'
#' @keywords internal
#'
#' @noRd
#'
#' @include auth.R
#' @include url.R
#'
#' @importFrom httr GET config accept_json content
#' @importFrom jsonlite fromJSON
#'
get_response <- function(type = c("ga", "realtime", "mcf", "mgmt"), path = NULL, query = NULL,
                         simplify = TRUE, flatten = TRUE, token) {
    type <- match.arg(type)
    url <- get_url(type = type, path = path)
    if (missing(token) && token_exists(getOption("rga.token")))
        token <- get_token(getOption("rga.token"))
    if (!missing(token)) {
        stopifnot(inherits(token, "Token2.0"))
        config <- config(token = token)
    } else
        config <- NULL
    if (!is.null(query) && is.list(query))
        query <- prepare_query(query)
    resp <- GET(url, query = query, accept_json(), config)
    if (resp$status_code == 401L) {
        authorize(cache = FALSE)
        return(eval(match.call()))
    } else if (resp$status_code == 404L)
        stop("The requested URL not found. URL: ", strsplit(resp$url, split = "?", fixed = TRUE)[[1]][1])
    data_json <- fromJSON(content(resp, as = "text"), simplifyVector = simplify, flatten = flatten)
    if (!is.null(data_json$error))
        error_message(data_json)
    return(data_json)
}
