# WaveICA #
## WaveICA ##

# install packages for WaveICA correction
install.packages("devtools", quite = TRUE)
library(devtools)
devtools::install_github("dengkuistat/WaveICA", host = "https://api.github.com", dependencies = TRUE)
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
cat("Running WaveICA\n")
# running waveICA
waveica_result_interday_matrix <- WaveICA(peak_data_matrix, batch = batch_info_interday, group = NULL)
waveica_result_interday_app <- as.data.frame(waveica_result_interday_matrix[["data_wave"]]) # 126 obs of 120 variables

# save dataset as csv file
write.csv(waveica_result_interday_app,
          file = "dataset_app/app_waveica_interday_corrected_data.csv",
          row.names = TRUE)
cat("Successfully saved corrected dataset in dataset_app\n")