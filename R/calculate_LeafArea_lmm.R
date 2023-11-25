#' Calculate Leaf Area using Linear Mixed Model
#'
#' This function computes the leaf area values for six plant species: S. quitoense,
#' S. betaceum, P. ligularis, R. fruticosus, P. peruviana, and P. edulis. The leaf area
#' is determined through a linear mixed model, incorporating random effects for individual species.
#'
#' @param data A data frame containing the input data.
#' @param LeafLength Name of the column representing leaf length.
#' @param sp Name of the column representing the species.
#' @param LeafWidth Name of the column representing leaf Width.
#'
#' @return A data frame with the calculated synthetic variable sqrt_Length_Width added and leaf area.
#'
#' @importFrom readxl read_excel
#' @importFrom stats predict logLik
#' @importFrom performance check_model
#' @importFrom MuMIn r.squaredGLMM
#' @importFrom nlme lme
#'
#' @export
#'
#' @seealso
#' \code{\link{lme}} for fitting linear mixed-effects models.
#' \code{\link{check_model}} for model diagnostics.
#' \code{\link{logLik}} for log-likelihood calculation.
#' \code{\link{sqrt}} for square root calculation.
#'
#' @examples
#' df <- data.frame(
#'   Culture = c("S. quitoense", "S. quitoense", "S. quitoense", "S. quitoense",
#'               "S. quitoense", "S. quitoense", "S. betaceum", "S. betaceum",
#'               "S. betaceum", "S. betaceum", "S. betaceum", "S. betaceum"),
#'   LL = c(25, 27, 200, 56, NA, 56, 25, 27, 28, 56, 56, 56),
#'   WL = c(45, 56, 57, 53, 54, NA, 57, 56, 57, 53, 54, 55)
#' )
#'
#' # It is recommended to use the outlier_treatment_mice function
#'
#' # Calculate sqrt_Length_Width in the dataset
#' df_result <- calculate_LeafArea_lmm(df, LeafLength = "LL", sp = "Culture",
#'            LeafWidth = "WL")
#'
#' # Print the resulting dataset
#' print(df_result)
calculate_LeafArea_lmm <- function(data, LeafLength = "LengthLeaf",
                                   sp = "sp",
                                   LeafWidth = "WidthLeaf") {
  # Construir la ruta relativa
  file_path <- system.file("tests", "testdata", "df.xlsx",
                           package = "LeafArea")

  # Leer la base de datos
  df <- read_excel(file_path)

  #Estimação do modelo com Interceptos e Inclinações Aleatórios
  model <- lme(fixed = sqrt_LeafArea ~ sqrt_Length_Width,
               random = ~ sqrt_Length_Width | sp,
               data = df,
               method = "REML")
  print(check_model(model))

  # Mostrar un resumen del modelo
  print(summary(model))

  # Mostrar un resumen del modelo
  print(logLik(model))

  # RMSE (Error Cuadrático Medio)
  rmse <- sqrt(mean((df$sqrt_LeafArea - predict(model, newdata = df))^2))

  # MAE (Error Absoluto Medio)
  mae <- mean(abs(df$sqrt_LeafArea - predict(model, newdata = df)))

  # MAPE (Error Porcentual Absoluto Medio)
  mape <- mean(abs(df$sqrt_LeafArea - predict(model, newdata = df)) / df$sqrt_LeafArea) * 100

  # MSE (Error Cuadrático Medio)
  mse <- mean((df$sqrt_LeafArea - predict(model, newdata = df))^2)

  # Coeficiente de Determinación (R-squared)
  rsquared <- r.squaredGLMM(model)

  # Mostrar las métricas redondeadas a tres dígitos
  cat("R-squared:", round(rsquared, 3), "\n")
  cat("RMSE:", round(rmse, 3), "\n")
  cat("MAE:", round(mae, 3), "\n")
  cat("MAPE:", round(mape, 3), "%\n")
  cat("MSE:", round(mse, 3), "\n")


  # Asegurarse de que las columnas necesarias estén presentes
  if (!(LeafLength %in% colnames(data) && LeafWidth %in% colnames(data))) {
    stop(paste("The columns '", LeafLength, "' y '", LeafWidth, "' are necessary in the database. "))
  }

  # Calcular sqrt_Length_Width
  data$sqrt_Length_Width <- ifelse(is.na(data[[LeafLength]]), sqrt(data[[LeafWidth]]),
                                   ifelse(is.na(data[[LeafWidth]]), sqrt(data[[LeafLength]]),
                                          sqrt(data[[LeafLength]] * data[[LeafWidth]])))
  data$sp <- data[[sp]]

  # Predecir valores de sqrt_LeafArea en la nueva base de datos
  LeafArea_lmm_model <- (predict(model, newdata = data))^2

  data$sp <- NULL

  # Mostrar los valores predichos
  cat("Valores predichos de sqrt_LeafArea en la nueva base de datos:\n")
  print(LeafArea_lmm_model)

  data$LeafArea_lmm_model<-(LeafArea_lmm_model)
  print(data)
  # Devolver la base de datos con la nueva variable calculada
  return(data)

}

