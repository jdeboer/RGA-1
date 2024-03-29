# Get the Google Analytics API data
#' @include request.R
get_data <- function(type = c("ga", "realtime", "mcf", "mgmt"), path = NULL, query = NULL, token) {
    type <- match.arg(type)
    # Set limits
    if (type == "mgmt") {
        results_limit <- 1000L
        items_name <- "items"
    } else {
        results_limit <- 10000L
        items_name <- "rows"
    }
    if (is.null(query$max.results)) {
        pagination <- TRUE
        query$max.results <- results_limit
    } else {
        pagination <- FALSE
        stopifnot(query$max.results <= results_limit)
    }
    # Add fields
    if (!is.null(query$fields) && type == "mgmt")
        query$fields <- paste("totalResults", "username", query$fields, sep = ",")
    # Make request
    data_json <- get_response(type = type, path = path, query = query, token = token)
    if (data_json$totalResults == 0L || is.null(data_json[[items_name]]) || length(data_json[[items_name]]) == 0L)
        return(NULL)
    if (!isTRUE(pagination) && query$max.results < data_json$totalResults)
        warning(paste("Only", query$max.results, "observations out of", data_json$totalResults, "were obtained. Set max.results = NULL (default value) to get all results."), call. = FALSE)
    # Pagination
    if (isTRUE(pagination) && query$max.results < data_json$totalResults) {
        if (type == "realtime")
            warning(paste("Only", query$max.results, "observations out of", data_json$totalResults, "were obtained (the batch processing mode is not implemented for this report type)."), call. = FALSE)
        else {
            message(paste("Response contain more then", query$max.results, "rows. Batch processing mode enabled."))
            total.pages <- ceiling(data_json$totalResults / query$max.results)
            pages <- vector(mode = "list", length = total.pages)
            for (page in 2L:total.pages) {
                message(paste0("Fetching page ", page, " of ", total.pages, "..."))
                query$start.index <- query$max.results * (page - 1L) + 1L
                pages[[page]] <- get_response(type = type, path = path, query = query, token = token)
            }
            pages <- pages[-1L]
            pages <- lapply(pages, `[[`, items_name)
            data_json[[items_name]] <- c(list(data_json[[items_name]]), pages)
        }
    }
    data_json[[items_name]] <- build_df(type, data_json)
    return(data_json)
}
