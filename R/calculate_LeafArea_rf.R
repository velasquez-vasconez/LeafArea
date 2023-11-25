#' Calculate Leaf Area using Random Forest Model
#'
#' This function computes the leaf area values for six plant species: S. quitoense,
#' S. betaceum, P. ligularis, R. fruticosus, P. peruviana, and P. edulis. The leaf area
#' is determined through a Random Forest model  that utilizes leaf length, width and
#' the species as independent variables.
#
#' @param data The data frame containing information about the plant species,
#'     leaf length, and leaf width.
#'
#' @return A data frame with the calculated leaf area.
#'
#' @importFrom stats predict
#' @importFrom caret trainControl train
#' @importFrom readxl read_excel
#' @importFrom randomForest randomForest
#'
#' @seealso
#' \code{\link{predict}} for making predictions from a model.
#'
#' @export
#'
#' @examples
#' df <- data.frame(
#'   Culture = c("S. quitoense", "S. quitoense", "S. quitoense", "S. quitoense",
#'               "S. quitoense", "S. quitoense", "S. betaceum", "S. betaceum",
#'               "S. betaceum", "S. betaceum", "S. betaceum", "S. betaceum"),
#'   LL = c(25, 27, 200, 56, NA, 56, 25, 27, 28, 56, 56, 56),
#'   LW = c(45, 56, 57, 53, 54, NA, 57, 56, 57, 53, 54, 55)
#' )
#'
#' sp <- df$Culture
#' LeafLength <- df$LL
#' LeafWidth <- df$LW
#' df_example <- data.frame(sp, LeafLength, LeafWidth)
#'
#' # Use the outlier_treatment_mice function
#' df_result_outlier <- LeafArea::outlier_treatment_mice(df_example)
#'
#' df_result<-calculate_LeafArea_rf(df_result_outlier)
#'
#' # Print the resulting dataset
#' print(df_result)
calculate_LeafArea_rf <- function(data) {

  # Construir la ruta relativa
  file_path <- system.file("tests", "testdata", "df.xlsx",
                           package = "LeafArea")

  # Leer la base de datos
  df <- read_excel(file_path)
  set.seed(1234)
  n <- sample(1:2,
              size=nrow(df),
              replace=TRUE,
              prob=c(0.8,0.2))
  treino <- df[n==1,]
  teste <- df[n==2,]

  set.seed(3456)
  controle <- caret::trainControl(
    method='repeatedcv',
    number=6,
    repeats=2,
    search='grid',
  )

  grid <- base::expand.grid(.mtry=c(1:10))
  set.seed(4567)
  modelo_rf <- caret::train(LeafArea ~ LeafLength + LeafWidth + sp,
                                data = treino,
                                method = 'rf',
                                trControl = controle,
                                ntree=500,
                                tuneGrid = grid)

  data$LeafArea_rf_model <- predict(modelo_rf, newdata = data)

  cat("\n---------------------------------------------\n\n")

  predicciones <- predict(modelo_rf, teste)

  # Calcular el RMSE
  rmse <- sqrt(mean((predicciones - teste$LeafArea)^2))
  print(paste("RMSE of test set:", round(rmse, 2)))

  # Calcular el MAE
  mae <- mean(abs(predicciones - teste$LeafArea))
  print(paste("MAE of test set:", round(mae, 2)))

  # Calcular el MAPE
  mape <- mean(abs((predicciones - teste$LeafArea) / teste$LeafArea)) * 100
  print(paste("MAPE of test set:", round(mape,2),"%"))

  # Convertir las predicciones y los valores reales a objetos numeric
  predicciones_numeric <- as.numeric(predicciones)
  valores_reales_numeric <- as.numeric(teste$LeafArea)

  # Calcular el R^2 usando la función R2 de caret
  r2 <- R2(predicciones_numeric, valores_reales_numeric)
  print(paste("R2 of test set:", round(r2, 2)))

  cat("\n---------------------------------------------\n\n")

  predicciones <- predict(modelo_rf, treino)

  # Calcular el RMSE
  rmse <- sqrt(mean((predicciones - treino$LeafArea)^2))
  print(paste("RMSE of training set:", round(rmse, 2)))

  # Calcular el MAE
  mae <- mean(abs(predicciones - treino$LeafArea))
  print(paste("MAE of training set:", round(mae, 2)))

  # Calcular el MAPE
  mape <- mean(abs((predicciones - treino$LeafArea) / treino$LeafArea)) * 100
  print(paste("MAPE of training set:", round(mape,2),"%"))

  # Convertir las predicciones y los valores reales a objetos numeric
  predicciones_numeric <- as.numeric(predicciones)
  valores_reales_numeric <- as.numeric(treino$LeafArea)

  # Calcular el R^2 usando la función R2 de caret
  r2 <- R2(predicciones_numeric, valores_reales_numeric)
  print(paste("R2 of training set:", round(r2, 2)))

  cat("\n---------------------------------------------\n\n")

  cat("Performance Metrics of Random Forest model:\n")
  print(modelo_rf)

  cat("\n---------------------------------------------\n\n")

  return(data)
}

df <- data.frame(
  Culture = c("S. quitoense", "S. quitoense", "S. quitoense", "S. quitoense",
              "S. quitoense", "S. quitoense", "S. betaceum", "S. betaceum",
              "S. betaceum", "S. betaceum", "S. betaceum", "S. betaceum"),
  LL = c(25, 27, 200, 56, NA, 56, 25, 27, 28, 56, 56, 56),
  LW = c(45, 56, 57, 53, 54, NA, 57, 56, 57, 53, 54, 55)
)


