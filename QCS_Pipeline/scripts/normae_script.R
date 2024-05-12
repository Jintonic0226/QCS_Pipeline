# NormAE #
## NormAE ##

## dataset preparation
# convert combined_batch_data_df into txt file
write.table(combined_batch_data_df, 
            file = "input/app_metabolomics_data_normae.txt", 
            sep = ",", 
            quote = FALSE, 
            row.names = FALSE)

# edit batch_info
library(dplyr)
batch_info <- read.csv("input/app_batch_info_TIC.csv", 
                       header = TRUE,
                       stringsAsFactors = FALSE)
# add column for group
batch_info <- batch_info %>%
  mutate(group = 1)

# Add a new column called "class"
batch_info <- batch_info %>%
  mutate(class = ifelse(grepl(paste(sample_set, collapse = "|"), sample.name), "Subject", "QC"))

# move the first three columns
combined_batch_data_df_norm <- combined_batch_data_df[, -(1:3)]

# Check if sample names match column names
names_match <- all(batch_info$sample.name %in% colnames(combined_batch_data_df_norm))

if (names_match) {
  print("The sample names in batch_info match the column names of combined_batch_data_df.")
} else {
  print("The sample names in batch_info do not match the column names of combined_batch_data_df.")
  
  # Extract column names from combined_batch_data_df
  col_names_combined <- colnames(combined_batch_data_df_norm)
  
  # Replace sample names in batch_info with column names from combined_batch_data_df
  batch_info$sample.name <- col_names_combined
}

# make it txt file
write.table(batch_info,
            file = "input/app_batch_info_normae.txt",
            sep = ",",
            row.names = FALSE,
            quote = FALSE)

## extract normae data from dataset
normae_result_interday <- read.csv("dataset/app_Rec_nobe_no_norm.csv",
                                   header = TRUE,
                                   stringsAsFactors = FALSE)