% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calculate_LeafArea_lm.R
\name{calculate_LeafArea_lm}
\alias{calculate_LeafArea_lm}
\title{Calculate Leaf Area using Linear Model}
\usage{
calculate_LeafArea_lm(
  data,
  LeafLength = "LengthLeaf",
  sp = "sp",
  LeafWidth = "WidthLeaf"
)
}
\arguments{
\item{data}{A data frame containing the input data.}

\item{LeafLength}{Name of the column representing leaf length.}

\item{sp}{Name of the column representing the species.}

\item{LeafWidth}{Name of the column representing leaf Width.}
}
\value{
A data frame with the calculated synthetic variable sqrt_Length_Width added and leaf area.
}
\description{
This function computes the leaf area values for six plant species: S. quitoense,
S. betaceum, P. ligularis, R. fruticosus, P. peruviana, and P. edulis. The leaf area
is determined through a linear model that utilizes leaf length and width as independent variables.
}
\examples{
df <- data.frame(
  Culture = c("S. quitoense", "S. quitoense", "S. quitoense", "S. quitoense",
              "S. quitoense", "S. quitoense", "S. betaceum", "S. betaceum",
              "S. betaceum", "S. betaceum", "S. betaceum", "S. betaceum"),
  LL = c(25, 27, 200, 56, NA, 56, 25, 27, 28, 56, 56, 56),
  WL = c(45, 56, 57, 53, 54, NA, 57, 56, 57, 53, 54, 55)
)

# Use the outlier_treatment_mice function
df_result_outlier <- LeafArea::outlier_treatment_mice(df)

# Calculate sqrt_Length_Width in the dataset
df_result <- calculate_LeafArea_lm(df, LeafLength = "LL", sp = "Culture",
           LeafWidth = "WL")

# Print the resulting dataset
print(df_result)
}
\seealso{
\code{\link{read_excel}} for reading Excel files.
\code{\link{lm}} for creating linear models.
\code{\link{predict}} for making predictions from a model.
\code{\link{performance}} for additional model diagnostics.
}
