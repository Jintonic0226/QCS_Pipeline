# Making everypart into a Function Confirmation #

# Inputs # 
no_normalization_data_2 <- read.csv("Pipeline_#2_(QCS+Tissue)/input/119feature_T&QCS_BaseRemoval_noNorm.csv", ## change file path ##
                                    header = FALSE,
                                    check.name = FALSE,
                                    stringsAsFactors = FALSE)

TIC_normalization_data_2 <- read.csv("Pipeline_#2_(QCS+Tissue)/input/119feature_T&QCS_BaseRemoval_TICNorm.csv", ## change file path ##
                                     header = FALSE,
                                     check.name = FALSE,
                                     stringsAsFactors = FALSE) 

propranolol_mz_value_2 <- as.numeric(readline("Enter Propranolol m/z value: ")) ## ie: 260.186 ##

d7_propranolol_mz_value_2 <- as.numeric(readline("Enter D7-propranolol m/z value: ")) ## ie: 267.187 ##

batch_info_2 <- read.csv("Pipeline_#2_(QCS+Tissue)/input/batch_info_TIC.csv", ## change file path ##
                         header = TRUE,
                         check.name = FALSE,
                         stringsAsFactors = FALSE) 

sample_set_2 <- c("ChickenHeart", "ChickenLiver", "GoatLiver") ## change sample type names ##

## Dataset preparation ##
prepare_no_normalization_data <- function(rawdata, sample_set_2, propranolol_mz_value_2, d7_propranolol_mz_value_2) {
  # Extract headers
  mz_header <- unlist(strsplit(as.character(rawdata[9, 1]), ";"))[1]
  peak_header <- unlist(strsplit(as.character(rawdata[9, 1]), ";"))[5:length(unlist(strsplit(as.character(rawdata[9, 1]), ";")))]
  
  mz_data_list <- list()
  peak_data_list <- list()
  combined_batch_data_list <- list()
  
  # Extract data into datalist
  for (i in 10:nrow(rawdata)) {
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
  
  # Add name column and set rt to a constant value
  combined_batch_data_df_2$name <- combined_batch_data_df_2$mz
  combined_batch_data_df_2$rt <- 666 # Assigning rt a random number
  
  # Reorder columns
  combined_batch_data_df_2 <- combined_batch_data_df_2[, c("name", "mz", "rt", peak_header)]
  
  # Check if each sample set exists in columns
  sample_set_exist <- logical(length(sample_set_2))
  
  for (i in seq_along(sample_set_2)) {
    sample_set_exist[i] <- any(grepl(sample_set_2[i], colnames(combined_batch_data_df_2)))
  }
  
  # Identify missing sample sets
  missing_sample_sets <- sample_set_2[!sample_set_exist]
  
  if (length(missing_sample_sets) > 0) {
    message("Error: The following sample sets do not exist in any column names: ", paste(missing_sample_sets, collapse = ", "), " check your sample_set")
  } else {
    message("Successfully made formatted table. All sample sets exist in at least one column name.")
  }
  
  # Check if m/z values exist in rows
  propranolol_mz_exist <- any(combined_batch_data_df_2$mz == propranolol_mz_value_2)
  d7_propranolol_mz_exist <- any(combined_batch_data_df_2$mz == d7_propranolol_mz_value_2)
  
  if (!propranolol_mz_exist) {
    message("Error: The propranolol m/z value ", propranolol_mz_value_2, " does not exist in any row.")
  } else {
    message("The propranolol m/z value ", propranolol_mz_value_2, " exists in at least one row.")
  }
  
  if (!d7_propranolol_mz_exist) {
    message("Error: The D7-propranolol m/z value ", d7_propranolol_mz_value_2, " does not exist in any row.")
  } else {
    message("The D7-propranolol m/z value ", d7_propranolol_mz_value_2, " exists in at least one row.")
  }
  
  return(combined_batch_data_df_2)
}

no_normalization_formatted_data <- prepare_no_normalization_data(no_normalization_data_2, sample_set_2, propranolol_mz_value_2, d7_propranolol_mz_value_2)
TIC_normalization_formatted_data <- prepare_no_normalization_data(TIC_normalization_data_2, sample_set_2, propranolol_mz_value_2, d7_propranolol_mz_value_2 )


## Downloading ##
# Installing packages to run Combat

# Installing devtools
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}

# Installing SVA via BiocManager or Github
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
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

library (sva)





