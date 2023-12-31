% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calculate_LeafArea_xgb.R
\name{calculate_LeafArea_xgb}
\alias{calculate_LeafArea_xgb}
\title{Calculate Leaf Area using XGBoost Model}
\usage{
calculate_LeafArea_xgb(data)
}
\arguments{
\item{data}{The data frame containing information about the plant species,
leaf length, and leaf width.}
}
\value{
A data frame with the calculated leaf area.
}
\description{
This function computes the leaf area values for six plant species: S. quitoense,
S. betaceum, P. ligularis, R. fruticosus, P. peruviana, and P. edulis. The leaf area
is determined through a XGBoost model  that utilizes leaf length, width and
the species as independent variables.
}
\examples{
df <- data.frame(
  Culture = c("S. quitoense", "S. quitoense", "S. quitoense", "S. quitoense",
              "S. quitoense", "S. quitoense", "S. betaceum", "S. betaceum",
              "S. betaceum", "S. betaceum", "S. betaceum", "S. betaceum"),
  LL = c(25, 27, 200, 56, NA, 56, 25, 27, 28, 56, 56, 56),
  LW = c(45, 56, 57, 53, 54, NA, 57, 56, 57, 53, 54, 55)
)

sp <- df$Culture
LeafLength <- df$LL
LeafWidth <- df$LW
df_example <- data.frame(sp, LeafLength, LeafWidth)

# Use the outlier_treatment_mice function
df_result_outlier <- LeafArea::outlier_treatment_mice(df_example)

df_result<-calculate_LeafArea_xgb(df_result_outlier)

# Print the resulting dataset
print(df_result)
}
\seealso{
\code{\link{predict}} for making predictions from a model.
}
