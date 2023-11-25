#' Calculate Leaf Area using Linear Model
#'
#' This function computes the leaf area values for six plant species: S. quitoense,
#' S. betaceum, P. ligularis, R. fruticosus, P. peruviana, and P. edulis. The leaf area
#' is determined through a linear model that utilizes leaf length and width as independent variables.
#'
#' @param data A data frame containing the input data.
#' @param LeafLength Name of the column representing leaf length.
#' @param sp Name of the column representing the species.
#' @param LeafWidth Name of the column representing leaf Width.
#'
#' @return A data frame with the calculated synthetic variable sqrt_Length_Width added and leaf area.
#'
#' @importFrom readxl read_excel
#' @importFrom stats lm predict logLik
#' @importFrom performance check_model
#'
#' @seealso
#' \code{\link{read_excel}} for reading Excel files.
#' \code{\link{lm}} for creating linear models.
#' \code{\link{predict}} for making predictions from a model.
#' \code{\link{performance}} for additional model diagnostics.
#'
#' @export
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
#' # Use the outlier_treatment_mice function
#' df_result_outlier <- LeafArea::outlier_treatment_mice(df)
#'
#' # Calculate sqrt_Length_Width in the dataset
#' df_result <- calculate_LeafArea_lm(df, LeafLength = "LL", sp = "Culture",
#'            LeafWidth = "WL")
#'
#' # Print the resulting dataset
#' print(df_result)
calculate_LeafArea_lm <- function(data, LeafLength = "LengthLeaf",
                                  sp = "sp",
                                  LeafWidth = "WidthLeaf") {

  # Construir la ruta relativa
  file_path <- system.file("tests", "testdata", "df.xlsx",
                           package = "LeafArea")

  # Leer la base de datos
  df <- read_excel(file_path)

  # Crear el modelo lineal
  model <- lm(sqrt_LeafArea ~ sqrt_Length_Width + sp, data = df)
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
  rsquared <- summary(model)$r.squared

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
  LeafArea_lm_model <- (predict(model, newdata = data))^2

  data$sp <- NULL

  # Mostrar los valores predichos
  cat("Valores predichos de sqrt_LeafArea en la nueva base de datos:\n")
  print(LeafArea_lm_model)

  data$LeafArea_lm_model<-(LeafArea_lm_model)
  print(data)
  # Devolver la base de datos con la nueva variable calculada
  return(data)
}

