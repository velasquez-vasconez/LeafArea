#' Outlier Treatment using MICE Imputation
#'
#' This function identifies and removes outliers from a given data frame and then performs
#' missing value imputation using the MICE (Multivariate Imputation by Chained Equations) algorithm.
#'
#' @param data_frame A data frame containing numeric variables where outliers will be treated.
#' @param multiplier The multiplier to determine the threshold for identifying outliers. Default is 1.5.
#'
#' @return A data frame with outliers removed and missing values imputed using the MICE algorithm.
#'
#' @examples
#' # Example with a custom data frame
#' data <- data.frame(
#'   Culture = c("S. quitoense", "S. quitoense", "S. quitoense", "S. quitoense",
#'               "S. quitoense", "S. quitoense", "S. betaceum", "S. betaceum",
#'               "S. betaceum", "S. betaceum", "S. betaceum", "S. betaceum"),
#'   LengthLeaf = c(25, 27, 200, 56, NA, 56, 25, 27, 28, 56, 56, 56),
#'   WidthLeaf = c(45, 56, 57, 53, 54, NA, 57, 56, 57, 53, 54, 55)
#' )
#' df <- outlier_treatment_mice(data)
#' df
#'
#' @importFrom mice complete
#' @importFrom stats quantile
#'
#' @import graphics
#'
#' @seealso
#' \code{\link{boxplot}} for creating boxplots.
#' \code{\link[mice]{mice}} for the MICE algorithm.
#'
#' @details
#' The function first identifies outliers using the IQR method and replaces them with NA.
#' Then, MICE imputation is applied to fill in missing values.
#'
#' @references
#' Van Buuren, S. (2018). Flexible Imputation of Missing Data. Chapman & Hall/CRC.
#'
#' @author Velasquez-Vasconez
#' @keywords outlier treatment mice imputation
#'
#' @export
outlier_treatment_mice <- function(data_frame, multiplier = 1.5) {
  removed_outliers <- list()  # Lista para almacenar los valores atípicos eliminados

  # Obtener el número total de variables numéricas
  num_numeric_variables <- sum(sapply(data_frame, is.numeric))

  # Configurar el diseño de la ventana de gráficos
  par(mfrow = c(2, num_numeric_variables))

  # Graficar boxplot antes de la remoción de outliers
  pbefore<-for (variable in names(data_frame)) {
    if (is.numeric(data_frame[[variable]])) {
      boxplot(data_frame[[variable]], main = paste(variable, "\nbefore outlier removal"),
              ylab = "Values", col = "lightblue",
              cex.main=1.2)
    }
  }

  for (variable in names(data_frame)) {
    if (is.numeric(data_frame[[variable]])) {
      q1 <- stats::quantile(data_frame[[variable]], 0.25, na.rm = TRUE)
      q3 <- stats::quantile(data_frame[[variable]], 0.75, na.rm = TRUE)
      iqr <- q3 - q1

      lower_bound <- q1 - multiplier * iqr
      upper_bound <- q3 + multiplier * iqr

      outliers <- data_frame[[variable]][which(data_frame[[variable]] < lower_bound | data_frame[[variable]] > upper_bound)]

      # Almacenar los valores atípicos antes de reemplazarlos con NA
      removed_outliers[[variable]] <- outliers

      # Reemplazar los valores atípicos con NA
      data_frame[[variable]] <- ifelse(data_frame[[variable]] < lower_bound | data_frame[[variable]] > upper_bound, NA, data_frame[[variable]])
    }
  }

  # Graficar boxplot después de la remoción de outliers
  pafter<-for (variable in names(data_frame)) {
    if (is.numeric(data_frame[[variable]])) {
      boxplot(data_frame[[variable]], main = paste(variable, "\nafter outlier removal"),
              ylab = "Values", col = "lightblue",
              cex.main =1.2)
    }
  }

  # Restablecer la configuración de la ventana de gráficos
  par(mfrow = c(1, 1))

  # Mostrar valores atípicos eliminados
  for (variable in names(removed_outliers)) {
    cat("Outliers removed from", variable,":", removed_outliers[[variable]], "\n")
  }

  # Imputando valores faltantes
  data_frame <- mice::complete(mice::mice(data_frame))

  return(data_frame)
}

