% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/unsampled.R
\name{get_unsampled_report}
\alias{get_unsampled_report}
\title{Gets a single unsampled report}
\usage{
get_unsampled_report(account.id, webproperty.id, profile.id,
  unsampled.report.id, token)
}
\arguments{
\item{account.id}{integer or character. Account ID to retrieve unsampled report for.}

\item{webproperty.id}{integer or character. Web property ID to retrieve unsampled reports for.}

\item{profile.id}{integer or character. View (Profile) ID to retrieve unsampled report for.}

\item{unsampled.report.id}{integer or character. Web property ID to retrieve unsampled reports for.}

\item{token}{\code{\link[httr]{Token2.0}} class object with a valid authorization data.}
}
\value{
An Analytics unsampled report.
\item{id}{Unsampled report ID.}
\item{kind}{Resource type for an Analytics unsampled report.}
\item{self.link}{Link for this unsampled report.}
\item{title}{Title of the unsampled report.}
\item{account.id}{Account ID to which this unsampled report belongs.}
\item{webproperty.id}{Web property ID to which this unsampled report belongs. The web property ID is of the form UA-XXXXX-YY.}
\item{profile.id}{View (Profile) ID to which this unsampled report belongs.}
\item{start-date}{The start date for the unsampled report.}
\item{end-date}{The end date for the unsampled report.}
\item{metrics}{The metrics for the unsampled report.}
\item{dimensions}{The dimensions for the unsampled report.}
\item{filters}{The filters for the unsampled report.}
\item{segment}{The segment for the unsampled report.}
\item{status}{Status of this unsampled report.  Possible values are PENDING, COMPLETED, or FAILED.}
\item{download.type}{The type of download you need to use for the report data file.}
\item{drive.download.details}{Download details for a file stored in Google Drive.}
\item{cloud.storage.download.details}{Download details for a file stored in Google Cloud Storage.}
\item{created}{Time this unsampled report was created.}
\item{updated}{Time this unsampled report was last modified.}
}
\description{
Gets a single unsampled report
}
\references{
\href{https://developers.google.com/analytics/devguides/config/mgmt/v3/mgmtReference/management/unsampledReports}{Management API - Unsampled Reports}
}
\seealso{
\code{\link{authorize}}

Other Management API: \code{\link{get_custom_dimension}};
  \code{\link{get_custom_metric}};
  \code{\link{get_experiment}}; \code{\link{get_filter}};
  \code{\link{get_goal}}; \code{\link{get_profile}};
  \code{\link{get_webproperty}};
  \code{\link{list_accounts}};
  \code{\link{list_custom_dimensions}};
  \code{\link{list_custom_metrics}};
  \code{\link{list_custom_sources}};
  \code{\link{list_experiments}};
  \code{\link{list_filters}}; \code{\link{list_goals}};
  \code{\link{list_profiles}}; \code{\link{list_segments}};
  \code{\link{list_unsampled_reports}};
  \code{\link{list_webproperties}}
}

