# Build data.frame for core report
df_ga <- function(x) {
    if (is.list(x$rows))
        x$rows <- do.call(rbind, x$rows)
    names <- gsub("^ga:", "", x$columnHeaders$name)
    data_df <- as.data.frame(x$rows, stringsAsFactors = FALSE)
    colnames(data_df) <- names
    return(data_df)
}

# Build data.frame for realtime report
df_realtime <- function(x) {
    names <- gsub("^rt:", "", x$columnHeaders$name)
    data_df <- as.data.frame(x$rows, stringsAsFactors = FALSE)
    colnames(data_df) <- names
    return(data_df)
}

# Build data.frame for mcf report
df_mcf <- function(x) {
    if (is.list(x$rows[[1L]]) && !is.data.frame(x$rows[[1L]]))
        x$rows <- do.call(c, x$rows)
    names <- gsub("^mcf:", "", x$columnHeaders$name)
    types <- x$columnHeaders$dataType
    if ("MCF_SEQUENCE" %in% types) {
        pv_idx <- grep("MCF_SEQUENCE", types, fixed = TRUE, invert = TRUE)
        cv_idx <- grep("MCF_SEQUENCE", types, fixed = TRUE)
        primitive <- lapply(x$rows, function(i) .subset2(i, "primitiveValue")[pv_idx])
        primitive <- do.call(rbind, primitive)
        colnames(primitive) <- names[pv_idx]
        conversion <- lapply(x$rows, function(i) .subset2(i, "conversionPathValue")[cv_idx])
        conversion <- lapply(conversion, function(i) lapply(i, function(j) paste(apply(j, 1, paste, collapse = ":"), collapse = " > ")))
        conversion <- do.call(rbind, lapply(conversion, unlist))
        colnames(conversion) <- names[cv_idx]
        data_df <- data.frame(primitive, conversion, stringsAsFactors = FALSE)[, names]
    } else {
        data_df <- as.data.frame(do.call(rbind, lapply(x$rows, unlist)), stringsAsFactors = FALSE)
        colnames(data_df) <- names
    }
    return(data_df)
}

# Rename list with sublists for mgmt data
#' @include utils.R
#' @importFrom stats setNames
ls_mgmt <- function(x) {
    x <- x[!names(x) %in% c("selfLink", "parentLink", "childLink")]
    names(x) <-  to_separated(names(x), sep = ".")
    to_rename <- vapply(x, is.list, logical(1))
    x[to_rename] <- lapply(x[to_rename], function(x) setNames(x, to_separated(names(x), sep = ".")))
    return(x)
}

# Build data.frame for mgmt data
df_mgmt <- function(x) {
    if (is.data.frame(x$items))
        data_df <- x$items
    else if (is.list(x$items) && !is.data.frame(x$items))
        data_df <- do.call(rbind, x$items)
    if (!is.null(data_df$permissions.effective)) {
        data_df$permissions.effective <- vapply(data_df$permissions.effective, paste, collapse = ",", FUN.VALUE = character(1))
        names(data_df) <- gsub(".effective", "", names(data_df), fixed = TRUE)
    }
    names(data_df) <- gsub("PropertyId", "propertyId", names(data_df), fixed = TRUE)
    return(data_df)
}

# Build a data.frame for GA report data
#' @include utils.R
build_df <- function(type = c("ga", "mcf", "realtime", "mgmt"), data) {
    type <- match.arg(type)
    data_df <- switch(type,
                      ga = df_ga(data),
                      rt = df_realtime(data),
                      mcf = df_mcf(data),
                      mgmt = df_mgmt(data))
    rownames(data_df) <- NULL
    colnames(data_df) <- to_separated(colnames(data_df), sep = ".")
    data_df <- convert_datatypes(data_df)
    message(paste("Obtained data.frame with", nrow(data_df), "rows and", ncol(data_df), "columns."))
    return(data_df)
}
