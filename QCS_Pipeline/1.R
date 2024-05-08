## QCS RSD Table ## Combat

## QCS RSD Calculation ## combat

## QCS RSD Table ## NormAE
data <- read.csv("dataset/Rec_nobe_no_norm.csv",
                 header = TRUE,
                 stringsAsFactors = FALSE,
                 row.names = 1)

row_names <- rownames(data)

batch_info_norm <- read.csv("dataset/Ys.csv",
                            header = TRUE,
                            stringsAsFactors = FALSE)

injection_order_norm <- batch_info_norm$injection.order
batch_norm <- batch_info_norm$batch

# add injection_order and batch_info
new_data <- rbind(injection_order_norm, batch_norm, data)
new_row_names <- c("injection_order", "batch", row_names)
rownames(new_data) <- new_row_names

# Transpose the data
transposed_data <- as.data.frame(t(new_data))

# combat
data <- read.csv("dataset/combat_interday_corrected_data.csv",
                 header = TRUE,
                 stringsAsFactors = FALSE,
                 row.names = 1) 
row_names <- rownames(data)

batch_info_norm <- read.csv("input/batch_info_TIC.csv",
                            header = TRUE,
                            stringsAsFactors = FALSE)

injection_order_norm <- batch_info_norm$injection.order
batch_norm <- batch_info_norm$batch

# add injection_order and batch_info
new_data <- rbind(injection_order_norm, batch_norm, data) # 128 obs of 119
new_row_names <- c("injection_order", "batch", row_names) #128 of 119 
rownames(new_data) <- new_row_names

# Transpose the data
transposed_data <- as.data.frame(t(new_data))

# extract tissue samples away function
extract_qcs_data <- function(dataset, sample_set) {
  pattern <- paste(sample_set, collapse = "|")
  
  # Extract tissue rows
  tissue_rows <- grep(pattern, rownames(dataset))
  
  # Subset dataframe to exclude tissue rows
  qcs_data <- dataset[-tissue_rows, , drop = FALSE]
  
  return(qcs_data)
}

# get rid of tissue samples
sample_set <- c("ChickenHeart", "ChickenLiver", "GoatLiver")
qcs_batch_info_data <- extract_qcs_data(transposed_data, sample_set)
batch_info_columns <- qcs_batch_info_data[, 1:2, drop = FALSE]

# extract qcs data
propranolol_peak_data <- qcs_batch_info_data[,colnames(qcs_batch_info_data) == propranolol_mz_value, drop = FALSE]
propranolol_data_combat <- cbind(batch_info_columns, propranolol_peak_data)

d7_propranolol_peak_data <- qcs_batch_info_data[,colnames(qcs_batch_info_data) == d7_propranolol_mz_value, drop = FALSE]
d7_propranolol_data_combat <- cbind(batch_info_columns, d7_propranolol_peak_data)

# function to calculate RSD
calculate_rsd <- function(data) {
  sd_value <- sd(data)
  mean_value <- mean(data)
  rsd <- (sd_value / mean_value) * 100
  return(rsd)
}

# function to calculate rsd for each batch
calculate_batch_rsd <- function(data, mz_value) {
  # Convert mz_value to character
  mz_value <- as.character(mz_value)
  # Convert column to numeric
  data[[mz_value]] <- as.numeric(data[[mz_value]], na.rm = TRUE)
  # Calculate RSD for each batch, rounding to two decimal places
  batch_rsd <- aggregate(data[[mz_value]],
                         by = list(batch = data$batch),
                         FUN = function(x) round(calculate_rsd(x), 2))
  # Rename columns
  colnames(batch_rsd) <- c("Batch", "RSD")
  # Calculate interday RSD, rounding to two decimal places
  interday_rsd <- round(calculate_rsd(data[[mz_value]]), 2)
  # Create a new row for interday RSD
  interday_row <- data.frame(Batch = "Interday", RSD = interday_rsd)
  # Combine batch_rsd with interday_rsd
  batch_rsd <- rbind(batch_rsd, interday_row)
  # Replace all RSD values with percentage symbol
  batch_rsd$RSD <- paste0(batch_rsd$RSD, "%")
  # Replace batch labels with "Intraday 1", "Intraday 2", "Intraday 3"
  batch_rsd$Batch <- ifelse(batch_rsd$Batch == "Interday", "Interday", paste0("Intraday ", batch_rsd$Batch))
  
  return(batch_rsd)
}

# usage:
propranolol_mz_value <- 260.186
d7_propranolol_mz_value <- 267.187
sample_set <- c("ChickenHeart", "ChickenLiver", "GoatLiver")
cat("RSD for Combat:\n")                                   
rsd_propranolol_combat <- calculate_batch_rsd(propranolol_data_combat, propranolol_mz_value)
cat("m/z value:", propranolol_mz_value, "\n")
print(rsd_propranolol_combat)

rsd_d7_propranolol_combat <- calculate_batch_rsd(d7_propranolol_data_combat, d7_propranolol_mz_value)
cat("m/z value:", d7_propranolol_mz_value, "\n")
print(rsd_d7_propranolol_combat)