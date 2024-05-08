## Combat ##

# install packages for combat
install.packages("sva")

# running combat
library (sva)

# obtaining peak_data
row_names <- combined_batch_data_df[, 1]
peak_data <- as.data.frame(combined_batch_data_df[,-(1:3)])
rownames(peak_data) <- row_names
peak_data_matrix <- as.matrix(peak_data)
peak_data_matrix <- apply(peak_data_matrix, 2, as.numeric)
rownames(peak_data_matrix) <- row_names

# obtaining batch_info
batch_data <- as.data.frame(t(combined_batch_info_data[,-(1)]))
batch_info_values <- as.vector(unlist(batch_data["batch", , drop = FALSE]))
batch_info_interday <- as.numeric(batch_info_values)
#print(length(batch_info_interday))

# running combat
combat_result_interday <- ComBat(dat = peak_data_matrix, batch = batch_info_interday)

# save dataset as csv file
write.csv(combat_result_interday,
          file = "dataset/combat_interday_corrected_data.csv",
          row.names = TRUE)

## Waveica ##
library(WaveICA)

# obtaining peak_data
row_names <- combined_batch_data_df[, 1]
peak_data <- as.data.frame(combined_batch_data_df[,-(1:3)])
rownames(peak_data) <- row_names
peak_data_trans <- as.data.frame(t(peak_data))
peak_data_trans <- sapply(peak_data_trans, as.numeric)
rownames(peak_data_trans) <- colnames(peak_data)

# Convert peak_data_trans to a matrix
peak_data_matrix <- as.matrix(peak_data_trans)

# Keep the row names from peak_data_trans in the matrix
rownames(peak_data_matrix) <- rownames(peak_data_trans)

# obtaining batch_info
batch_data <- as.data.frame(t(combined_batch_info_data[,-(1)]))
batch_info_values <- as.vector(unlist(batch_data["batch", , drop = FALSE]))
batch_info_interday <- as.numeric(batch_info_values)
#print(length(batch_info_interday)) # 126 samples

# running waveICA
waveica_result_interday_matrix <- WaveICA(peak_data_matrix, batch = batch_info_interday, group = NULL)
waveica_result_interday <- as.data.frame(waveica_result_interday_matrix[["data_wave"]]) # 126 obs of 120 variables

# save dataset as csv file
write.csv(waveica_result_interday,
          file = "dataset/waveica_interday_corrected_data.csv",
          row.names = TRUE)

## QCS RSD Table ## Combat

## QCS RSD Calculation ## combat
data <- read.csv("dataset/waveica_interday_corrected_data.csv",
                 header = TRUE,
                 stringsAsFactors = FALSE,
                 row.names = 1) 
data <- as.data.frame(t(data))

rownames(data) <- row_names

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
cat("RSD for Combat:\n")                                   
rsd_propranolol_combat <- calculate_batch_rsd(propranolol_data_combat, propranolol_mz_value)
cat("m/z value:", propranolol_mz_value, "\n")
print(rsd_propranolol_combat)

rsd_d7_propranolol_combat <- calculate_batch_rsd(d7_propranolol_data_combat, d7_propranolol_mz_value)
cat("m/z value:", d7_propranolol_mz_value, "\n")
print(rsd_d7_propranolol_combat)

