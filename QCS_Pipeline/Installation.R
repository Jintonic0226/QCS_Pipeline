# Whole Notebook into R_Studio Version 2024.09.1+394 (2024.09.1+394)
RStudio.Version()$version
version # R version 4.4.2

## Packages for RSD overview table ##
install.packages("htmltools")
install.packages("kableExtra")
install.packages("IRdisplay")

## Packages for Violin plot ##
install.packages("ggplot2")
install.packages("dplyr")
install.packages("RColorBrewer")
install.packages("gridExtra")

## Package for excel sheet creating ##
install.packages("openxlsx")

cat("\033[1mSuccessfully Downloaded Packages\033[0m\n")

### Please edit the file path, file name ###
## Please change the line with ## ## 
no_normalization_data_2 <- read.csv("Pipeline_#2_(QCS+Tissue)/Input/119feature_T&QCS_BaseRemoval_noNorm.csv", ## change file path ##
                                    header = FALSE,
                                    check.name = FALSE,
                                    stringsAsFactors = FALSE)

TIC_normalization_data_2 <- read.csv("Pipeline_#2_(QCS+Tissue)/Input/119feature_T&QCS_BaseRemoval_TICNorm.csv", ## change file path ##
                                     header = FALSE,
                                     check.name = FALSE,
                                     stringsAsFactors = FALSE) 

QCS_mz_value_2 <- as.numeric(readline("Enter QCS (ie: Propranolol) m/z value: ")) ## ie: 260.186 ##

IS_mz_value_2 <- as.numeric(readline("Enter Internal Standard (ie: D7-propranolol) m/z value: ")) ## ie: 267.187 ##

batch_info_2 <- read.csv("Pipeline_#2_(QCS+Tissue)/Input/batch_info_TIC.csv", ## change file path ##
                         header = TRUE,
                         check.name = FALSE,
                         stringsAsFactors = FALSE) 

cat("\033[1mChange the sample_set accordingly to the Dataset!\033[0m\n")

sample_set_2 <- c("ChickenHeart", "ChickenLiver", "GoatLiver") ## change sample type names ##

## No Normalization Dataset ##
# Read the CSV file
rawdata <- no_normalization_data_2
mz_header <- unlist(strsplit(as.character(rawdata[9, 1]), ";"))[1]
peak_header <- unlist(strsplit(as.character(rawdata[9, 1]), ";"))[5:length(unlist(strsplit(as.character(rawdata[9, 1]), ";")))]
peak <- unlist(strsplit(as.character(rawdata[10, 1]), ";"))[5:length(unlist(strsplit(as.character(rawdata[9, 1]), ";")))]

mz_data_list <- list()
peak_data_list <- list()
combined_batch_data_list <- list()

# Extract data into datalist
for (i in 10:nrow(rawdata)){
  mz <- unlist(strsplit(as.character(rawdata[[i, 1]]), ";"))[1]
  peak <- unlist(strsplit(as.character(rawdata[i, 1]), ";"))[5:length(unlist(strsplit(as.character(rawdata[9, 1]), ";")))]
  mz_data_list[[i - 9]] <- mz
  peak_data_list[[i - 9]] <- peak
  combined_batch_data <- c(mz, peak)
  combined_batch_data_list[[i - 9]] <- combined_batch_data
}

# Combine data into a data frame
combined_batch_data_df_2 <- as.data.frame(do.call(rbind, combined_batch_data_list), stringsAsFactors = FALSE)

# Set column names as mz 
colnames(combined_batch_data_df_2) <- c("mz", peak_header)

# make name column (will be same as mz column)
combined_batch_data_df_2$name <- combined_batch_data_df_2$mz 

# Set 'rt' column to a constant value
combined_batch_data_df_2$rt <- 666 # Assigning rt a random number

# Reorder columns again
combined_batch_data_df_2 <- combined_batch_data_df_2[, c("name", "mz", "rt", peak_header)]

# check if each sample set exist in columns
sample_set_exist <- logical(length(sample_set_2))

# Check if each sample set exists in any of the column names
for (i in seq_along(sample_set_2)) {
  sample_set_exist[i] <- any(grepl(sample_set_2[i], colnames(combined_batch_data_df_2)))
}

# Identify sample sets that do not exist in any column names
missing_sample_sets <- sample_set_2[!sample_set_exist]

if (length(missing_sample_sets) > 0) {
  message("Error: The following sample sets do not exist in any column names: ", paste(missing_sample_sets, collapse = ", ", "check your sample_set"))
} else {
  message("Successfully made formatted table. All sample sets exist in at least one column name.")
}

# Check if m/z values exist in rows
propranolol_mz_exist <- any(combined_batch_data_df_2$mz == QCS_mz_value_2)
d7_propranolol_mz_exist <- any(combined_batch_data_df_2$mz == IS_mz_value_2)

# Print messages based on existence
if (!propranolol_mz_exist) {
  message("Error: The QCS m/z value ", QCS_mz_value_2, " does not exist in any row.")
} else {
  message("The QCS m/z value ", IS_mz_value_2, " exists in at least one row.")
}

if (!d7_propranolol_mz_exist) {
  message("Error: The Internal Standard m/z value ", IS_mz_value_2, " does not exist in any row.")
} else {
  message("The Internal Standard m/z value ", IS_mz_value_2, " exists in at least one row.")
}

# uncomment to check if combined_batch_data_df looks correct and if sample names are correct
#print(combined_batch_data_df_2)
#print(colnames(combined_batch_data_df_2))
#print(rownames(combined_batch_data_df_2))

## Make batch info combined dataframe ##
# dataframe with injection order, batch info, batch data
combined_batch_data_df_2_transposed <- as.data.frame(t(combined_batch_data_df_2[, -(1:3)]))
colnames(combined_batch_data_df_2_transposed) <- combined_batch_data_df_2[, 1]
combined_batch_info_data_2 <- cbind(batch_info_2[,-1], combined_batch_data_df_2_transposed) 


cat("\033[1mSuccessfully formmated no normalized datasets (check Dataset folder)\033[0m\n")

## TIC Normalization Dataset ##
# Read the CSV file
rawdata <- TIC_normalization_data_2
mz_header <- unlist(strsplit(as.character(rawdata[9, 1]), ";"))[1]
peak_header <- unlist(strsplit(as.character(rawdata[9, 1]), ";"))[5:length(unlist(strsplit(as.character(rawdata[9, 1]), ";")))]
peak <- unlist(strsplit(as.character(rawdata[10, 1]), ";"))[5:length(unlist(strsplit(as.character(rawdata[9, 1]), ";")))]

mz_data_list <- list()
peak_data_list <- list()
combined_batch_data_list <- list()

# Extract data
for (i in 10:nrow(rawdata)){
  mz <- unlist(strsplit(as.character(rawdata[[i, 1]]), ";"))[1]
  peak <- unlist(strsplit(as.character(rawdata[i, 1]), ";"))[5:length(unlist(strsplit(as.character(rawdata[9, 1]), ";")))]
  mz_data_list[[i - 9]] <- mz
  peak_data_list[[i - 9]] <- peak
  combined_batch_data <- c(mz, peak)
  combined_batch_data_list[[i - 9]] <- combined_batch_data
}

# Combine data into a data frame
combined_batch_data_df_TIC_2 <- as.data.frame(do.call(rbind, combined_batch_data_list), stringsAsFactors = FALSE)

# Set column names
colnames(combined_batch_data_df_TIC_2) <- c("mz", peak_header)

# make name column
combined_batch_data_df_TIC_2$name <- combined_batch_data_df_TIC_2$mz  # Assign 'name' column which is same as mz column

# Set 'rt' column to a constant value
combined_batch_data_df_TIC_2$rt <- 666 # Assigning rt a random number

# Reorder columns again
combined_batch_data_df_TIC_2 <- combined_batch_data_df_TIC_2[, c("name", "mz", "rt", peak_header)]

# uncomment to check 
#print(combined_batch_data_df)
#print(colnames(combined_batch_data_df_TIC_2))

# making as a formatted csv file
## Make batch info combined dataframe ##
# dataframe with injection order, batch info, batch data
combined_batch_data_df_transposed_TIC <- as.data.frame(t(combined_batch_data_df_TIC_2[, -(1:3)]))
colnames(combined_batch_data_df_transposed_TIC) <- combined_batch_data_df_TIC_2[, 1]
combined_batch_info_data_TIC_2 <- cbind(batch_info_2[,-1], combined_batch_data_df_transposed_TIC)  

# making as a formatted csv file for batch info data

cat("\033[1mSucessfully formatted TIC normalized datasets (check Dataset folder).\033[0m\n")
# IS normalization on no normalized dataset # 
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
qcs_batch_info_data <- extract_qcs_data(combined_batch_info_data_2, sample_set_2)
batch_info_columns <- qcs_batch_info_data[, 1:2, drop = FALSE]

# extract qcs data
# propranolol
propranolol_peak_data <- qcs_batch_info_data[,colnames(qcs_batch_info_data) == QCS_mz_value_2, drop = FALSE]
col_names <- rownames(propranolol_peak_data)
propranolol_data <- cbind(batch_info_columns, propranolol_peak_data)

propranolol_peak_data_trans <- as.data.frame(t(propranolol_peak_data))
colnames(propranolol_peak_data_trans) <- col_names 
propranolol_peak_data_trans <- as.numeric(propranolol_peak_data_trans)

# IS 
d7_propranolol_peak_data <- qcs_batch_info_data[,colnames(qcs_batch_info_data) == IS_mz_value_2, drop = FALSE]
col_names <- rownames(d7_propranolol_peak_data)
d7_propranolol_data <- cbind(batch_info_columns, d7_propranolol_peak_data)

d7_propranolol_peak_data_trans <- as.data.frame(t(d7_propranolol_peak_data))
colnames(d7_propranolol_peak_data_trans) <- col_names 
d7_propranolol_peak_data_trans <- as.numeric(d7_propranolol_peak_data_trans)

# IS normalization = propranolol / d7_propranolol
ratio <- propranolol_peak_data_trans / d7_propranolol_peak_data_trans
ratio_df <- as.data.frame(ratio)
rownames(ratio_df) <- col_names
ratio_data <- cbind(batch_info_columns,ratio_df)

ratio_data_csv <- as.data.frame(t(ratio_data))
rownames(ratio_data_csv) <- colnames(ratio_data)
#print(ratio_data_app_csv) # uncomment to see the dataset 

# making as a formatted csv file


cat("\033[1mSucessfully formatted IS normalization dataset (check Dataset folder).\033[0m\n")

## Correction ##
# Get user input for normalization type
normalization_type <- readline(prompt = "Please choose a dataset to correct. Enter 'no' for No Normalization or 'tic' for TIC Normalization: ")

# Assign the appropriate data frame based on user input
if (tolower(normalization_type) == "no") {
  combined_batch_data_df_corr <- combined_batch_data_df_2
  combined_batch_info_data_df_corr <- combined_batch_info_data_2
  
} else if (tolower(normalization_type) == "tic") {
  combined_batch_data_df_corr <- combined_batch_data_df_TIC_2
  combined_batch_info_data_df_corr <- combined_batch_info_data_TIC_2
  
} else {
  stop("Invalid input. Please enter 'no' or 'tic'.")
}

# Installing packages to run Combat

# Installing devtools
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools", dependencies = TRUE, verbose = TRUE )
}

# Installing SVA via BiocManager or Github
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager", dependencies = TRUE, verbose = TRUE)
}

# From BiocManager
tryCatch({
  BiocManager::install("sva")
  cat("\033[1m'sva' installed successfully from Bioconductor.\033[0m\n")
}, error = function(e) {
  # If failed, installing from GitHub
  cat("\033[1mFailed to install 'sva' from Bioconductor. Attempting to install from GitHub...\033[0m\n")
  tryCatch({
    devtools::install_github("jtleek/sva", dependencies = TRUE)
    cat("\033[1m'sva' installed successfully from GitHub.\033[0m\n")
  }, error = function(e) {
    cat("\033[1mFailed to install 'sva' from GitHub as well.\033[0m\n")
  })
})

## Combat ## 
# load the packages
library(devtools)
library(sva)

# obtaining peak_data
row_names <- combined_batch_data_df_corr[, 1] 
peak_data <- as.data.frame(combined_batch_data_df_corr[,-(1:3)]) 
rownames(peak_data) <- row_names
peak_data_matrix <- as.matrix(peak_data)
peak_data_matrix <- apply(peak_data_matrix, 2, as.numeric)
rownames(peak_data_matrix) <- row_names

# obtaining batch_info
batch_data <- as.data.frame(t(combined_batch_info_data_df_corr[,-(1)])) 
batch_info_values <- as.vector(unlist(batch_data["batch", , drop = FALSE]))
batch_info_interday <- as.numeric(batch_info_values)
#print(length(batch_info_interday))

# running combat
combat_result_interday <- ComBat(dat = peak_data_matrix, batch = batch_info_interday)

combat_result_interday_df <- as.data.frame(combat_result_interday)


