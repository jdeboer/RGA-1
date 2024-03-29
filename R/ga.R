#' @title Get the Anaytics data from Core Reporting API for a view (profile)
#'
#' @param profile.id integer or character. Unique table ID for retrieving Analytics data. Table ID is of the form ga:XXXX, where XXXX is the Analytics view (profile) ID. Can be obtained using the \code{\link{list_profiles}} or via the web interface Google Analytics.
#' @param start.date character. Start date for fetching Analytics data. Request can specify the start date formatted as YYYY-MM-DD or as a relative date (e.g., today, yesterday, or 7daysAgo). The default value is 7daysAgo.
#' @param end.date character. End date for fetching Analytics data. Request can specify the end date formatted as YYYY-MM-DD or as a relative date (e.g., today, yesterday, or 7daysAgo). The default value is yesterday.
#' @param metrics character. A comma-separated list of Analytics metrics. E.g., \code{"ga:sessions,ga:pageviews"}. At least one metric must be specified.
#' @param dimensions character. A comma-separated list of Analytics dimensions. E.g., \code{"ga:browser,ga:city"}.
#' @param sort character. A comma-separated list of dimensions or metrics that determine the sort order for Analytics data.
#' @param filters character. A comma-separated list of dimension or metric filters to be applied to Analytics data.
#' @param segment character. An Analytics segment to be applied to data. Can be obtained using the \code{\link{list_segments}} or via the web interface Google Analytics.
#' @param sampling.level character. The desired sampling level. Allowed values: "default", "faster", "higher_precision".
#' @param start.index integer. An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
#' @param max.results integer. The maximum number of entries to include in this feed.
#' @param token \code{\link[httr]{Token2.0}} class object with a valid authorization data.
#'
#' @return A data frame including the Analytics data for a view (profile). Addition information about profile and request query stored in the attributes.
#'
#' @references
#' \href{https://developers.google.com/analytics/devguides/reporting/core/dimsmets}{Core Reporting API - Dimensions & Metrics Reference}
#'
#' \href{https://developers.google.com/analytics/devguides/reporting/core/v3/reference#q_details}{Core Reporting API - Query Parameter Details}
#'
#' \href{https://developers.google.com/analytics/devguides/reporting/core/v3/common-queries}{Core Reporting API - Common Queries}
#'
#' \href{https://ga-dev-tools.appspot.com/explorer/}{Google Analytics Demos & Tools - Query Explorer}
#'
#' @seealso \code{\link{authorize}} \code{\link{list_dimsmets}}
#'
#' @family Reporting API
#'
#' @examples
#' \dontrun{
#' # get token data
#' authorize()
#' # get report data
#' ga_data <- get_ga("profile_id", start.date = "30daysAgo", end.date = "today",
#'                   metrics = "ga:sessions", dimensions = "ga:source,ga:medium",
#'                   sort = "-ga:sessions")
#' }
#'
#' @include report.R
#'
#' @export
#'
get_ga <- function(profile.id, start.date = "7daysAgo", end.date = "yesterday",
                   metrics = "ga:users,ga:sessions,ga:pageviews", dimensions = NULL,
                   sort = NULL, filters = NULL, segment = NULL, sampling.level = NULL,
                   start.index = NULL, max.results = NULL, token) {
    if (!is.null(sampling.level))
        sampling.level <- match.arg(sampling.level, c("default", "faster", "higher_precision"))
    query <- build_query(profile.id = profile.id, start.date = start.date, end.date = end.date,
                         metrics = metrics, dimensions = dimensions, sort = sort, filters = filters,
                         segment = segment, sampling.level = sampling.level,
                         start.index = start.index, max.results = max.results)
    res <- get_report(type = "ga", query = query, token = token)
    return(res)
}
