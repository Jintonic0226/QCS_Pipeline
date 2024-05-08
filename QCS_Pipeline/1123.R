### Please edit the file path, file name ###
no_normalization_data <- read.csv("input/119feature_T&QCS_BaseRemoval_noNorm.csv",
                                  header = FALSE,
                                  check.name = FALSE,
                                  stringsAsFactors = FALSE)

TIC_normalization_data <- read.csv("input/119feature_T&QCS_BaseRemoval_TICNorm.csv",
                                   header = FALSE,
                                   check.name = FALSE,
                                   stringsAsFactors = FALSE) 

#propranolol_mz_value <- as.numeric(readline("Enter Propranolol m/z value: ")) ## ie: 260.186

#d7_propranolol_mz_value <- as.numeric(readline("Enter D7-propranolol m/z value: ")) ## ie: 267.187

batch_info <- read.csv("input/batch_info_TIC.csv",
                       header = TRUE,
                       check.name = FALSE,
                       stringsAsFactors = FALSE) 

sample_set <- c("ChickenHeart", "ChickenLiver", "GoatLiver")

propranolol_mz_value <- 260.186
d7_propranolol_mz_value <- 267.187
### Making formatted table no_normalization ###

## Format the csv datasets ##
# Read the CSV file
rawdata <- no_normalization_data
mz_header <- unlist(strsplit(as.character(rawdata[9, 1]), ";"))[1]
peak_header <- unlist(strsplit(as.character(rawdata[9, 1]), ";"))[5:length(unlist(strsplit(as.character(rawdata[9, 1]), ";")))]
peak <- unlist(strsplit(as.character(rawdata[10, 1]), ";"))[5:length(unlist(strsplit(as.character(rawdata[9, 1]), ";")))]

# Initialize lists
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
combined_batch_data_df <- as.data.frame(do.call(rbind, combined_batch_data_list), stringsAsFactors = FALSE)

# Set column names
colnames(combined_batch_data_df) <- c("mz", peak_header)

# make name column
combined_batch_data_df$name <- combined_batch_data_df$mz  # Assign 'name' column which is same as mz column

# Set 'rt' column to a constant value
combined_batch_data_df$rt <- 666 # Assigning rt a random number

# Reorder columns again
combined_batch_data_df <- combined_batch_data_df[, c("name", "mz", "rt", peak_header)]

# check if each sample set exist in columns
sample_set_exist <- logical(length(sample_set))

# Check if each sample set exists in any of the column names
for (i in seq_along(sample_set)) {
  sample_set_exist[i] <- any(grepl(sample_set[i], colnames(combined_batch_data_df)))
}

# Identify sample sets that do not exist in any column names
missing_sample_sets <- sample_set[!sample_set_exist]

if (length(missing_sample_sets) > 0) {
  message("Error: The following sample sets do not exist in any column names: ", paste(missing_sample_sets, collapse = ", ", "check your sample_set"))
} else {
  message("Successfully made formatted table. All sample sets exist in at least one column name.")
}

# Check if m/z values exist in rows
propranolol_mz_exist <- any(combined_batch_data_df$mz == propranolol_mz_value)
d7_propranolol_mz_exist <- any(combined_batch_data_df$mz == d7_propranolol_mz_value)

# Print messages based on existence
if (!propranolol_mz_exist) {
  message("Error: The propranolol m/z value ", propranolol_mz_value, " does not exist in any row.")
} else {
  message("The propranolol m/z value ", propranolol_mz_value, " exists in at least one row.")
}

if (!d7_propranolol_mz_exist) {
  message("Error: The D7-propranolol m/z value ", d7_propranolol_mz_value, " does not exist in any row.")
} else {
  message("The D7-propranolol m/z value ", d7_propranolol_mz_value, " exists in at least one row.")
}

# uncomment to check 
print(combined_batch_data_df)
print(colnames(combined_batch_data_df))

# making as a formatted csv file
#write.csv(combined_batch_data_df,
          #file = "dataset/formatted_no_norm_batch_data.csv",
          #row.names = FALSE)

## Make batch info combined dataframe ##
# dataframe with injection order, batch info, batch data
combined_batch_data_df_transposed <- as.data.frame(t(combined_batch_data_df[, -(1:3)]))
colnames(combined_batch_data_df_transposed) <- combined_batch_data_df[, 1]
combined_batch_info_data <- cbind(batch_info[,-1], combined_batch_data_df_transposed)  

# RSD calculation IS norm
## QCS RSD Calculation ##

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
qcs_batch_info_data <- extract_qcs_data(combined_batch_info_data, sample_set)
batch_info_columns <- qcs_batch_info_data[, 1:2, drop = FALSE]

# extract qcs data
propranolol_peak_data <- qcs_batch_info_data[,colnames(qcs_batch_info_data) == propranolol_mz_value, drop = FALSE]
col_names <- rownames(propranolol_peak_data)
propranolol_data <- cbind(batch_info_columns, propranolol_peak_data)

propranolol_peak_data_trans <- as.data.frame(t(propranolol_peak_data))
colnames(propranolol_peak_data_trans) <- col_names 
propranolol_peak_data_trans <- as.numeric(propranolol_peak_data_trans)


d7_propranolol_peak_data <- qcs_batch_info_data[,colnames(qcs_batch_info_data) == d7_propranolol_mz_value, drop = FALSE]
col_names <- rownames(d7_propranolol_peak_data)
d7_propranolol_data <- cbind(batch_info_columns, d7_propranolol_peak_data)


d7_propranolol_peak_data_trans <- as.data.frame(t(d7_propranolol_peak_data))
colnames(d7_propranolol_peak_data_trans) <- col_names 
d7_propranolol_peak_data_trans <- as.numeric(d7_propranolol_peak_data_trans)

# IS normalization
ratio <- propranolol_peak_data_trans / d7_propranolol_peak_data_trans
ratio_df <- as.data.frame(ratio)
rownames(ratio_df) <- col_names
ratio_data <- cbind(batch_info_columns,ratio_df)


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
rsd_propranolol <- calculate_batch_rsd(propranolol_data, propranolol_mz_value)
cat("m/z value:", propranolol_mz_value, "\n")
print(rsd_propranolol)

rsd_d7_propranolol <- calculate_batch_rsd(d7_propranolol_data, d7_propranolol_mz_value)
cat("m/z value:", d7_propranolol_mz_value, "\n")

rsd_ratio <- calculate_batch_rsd(ratio_data, "IS_norm")
cat("m/z value:", "ratio", "\n")
print(rsd_ratio)

## violin plot

# violin plot for IS_norm
propranolol_data_trans <- as.data.frame(t(ratio_data))
propranolol_data_trans[] <- lapply(propranolol_data_trans, as.numeric)

# Extract slide number
slide_number <- gsub("^.*S(\\d+)_.*", "\\1", names(propranolol_data_trans))
slide_number <- as.numeric(slide_number)

# Create violin plot data frame
violin_data <- data.frame(
  Slide = slide_number,
  Batch = propranolol_data$batch,
  Value = unlist(propranolol_data_trans[3, ])
)

# Sort the data frame based on the Slide column
violin_data <- violin_data %>%
  arrange(Slide)

# find mean of all samples
mean_value <- mean(violin_data$Value)

# format the violin plot
options(repr.plot.width = 10, repr.plot.height = 6)  # Adjust width and height as desired

# Create a violin plot with adjusted width
violin_plot_d7 <- ggplot(violin_data, aes(x = factor(Slide), y = Value, fill = factor(Batch))) +
  geom_violin(position = position_dodge(width = 0.5), trim = FALSE, width = 1) +
  stat_summary(fun = median, geom = "point", shape = 20, size = 3, color = "black") +
  geom_hline(yintercept = mean_value, linetype = "dashed", color = "gray", linewidth = 1) +
  scale_fill_manual(values = c("1" = "#ADD8E6", "2" = "#90EE90", "3" = "#FFA07A")) +
  labs(x = "Slide Number", y = "Peak Data", title = "IS Normalization Raw data") +
  theme_bw() +
  theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, face = "bold"),
    axis.text.y = element_text(angle = 90, vjust = 0.5, hjust = 1, face = "bold"),
    axis.title = element_text(face = "bold", size = 15),  # Bold and increase size of axis titles
    plot.title = element_text(face = "bold", size = 15),  # Bold and increase size of plot title
    axis.text = element_text(size = 10)  # Increase size of axis values
  )

# Display the violin plot
print(violin_plot_d7)

print(rsd_d7_propranolol)