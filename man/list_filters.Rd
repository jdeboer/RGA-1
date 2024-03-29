% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/filters.R
\name{list_filters}
\alias{list_filters}
\title{Lists all filters for an account which the user has access to}
\usage{
list_filters(account.id, start.index = NULL, max.results = NULL, token)
}
\arguments{
\item{account.id}{Account ID to retrieve filters for.}

\item{start.index}{integer. An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.}

\item{max.results}{integer. The maximum number of filters to include in this response.}

\item{token}{\code{\link[httr]{Token2.0}} class object with a valid authorization data.}
}
\value{
A filter collection lists filters created by users in an Analytics account. Each resource in the collection corresponds to a filter.
\item{id}{Filter ID.}
\item{account.id}{Account ID to which this filter belongs.}
\item{name}{Name of this filter.}
\item{type}{Type of this filter.}
\item{created}{Time this filter was created.}
\item{updated}{Time this filter was last modified.}
}
\description{
Lists all filters for an account which the user has access to
}
\references{
\href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/filters}{Management API - Filters}
}
\seealso{
\code{\link{authorize}}

Other Management API: \code{\link{get_custom_dimension}};
  \code{\link{get_custom_metric}};
  \code{\link{get_experiment}}; \code{\link{get_filter}};
  \code{\link{get_goal}}; \code{\link{get_profile}};
  \code{\link{get_unsampled_report}};
  \code{\link{get_webproperty}};
  \code{\link{list_accounts}};
  \code{\link{list_custom_dimensions}};
  \code{\link{list_custom_metrics}};
  \code{\link{list_custom_sources}};
  \code{\link{list_experiments}}; \code{\link{list_goals}};
  \code{\link{list_profiles}}; \code{\link{list_segments}};
  \code{\link{list_unsampled_reports}};
  \code{\link{list_webproperties}}
}

