# Combat #
## Combat ##

# install packages for combat
install.packages("sva", repos = "https://cran.rstudio.com/")


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
combat_result_interday_app <- ComBat(dat = peak_data_matrix, batch = batch_info_interday)
print(combat_result_interday_app)

# save dataset as csv file
write.csv(combat_result_interday_app,
          file = "dataset/app_combat_interday_corrected_data.csv",
          row.names = TRUE)