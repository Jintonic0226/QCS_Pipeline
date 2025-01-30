## TIC Normalization ##
# read QCS data
library(dplyr)
library(tidyverse)

# extract tissue samples away function
extract_qcs_data <- function(dataset, sample_set) {
  pattern <- paste(sample_set, collapse = "|")
  
  # Extract tissue rows
  tissue_rows <- grep(pattern, rownames(dataset))
  
  # Subset dataframe to exclude tissue rows
  qcs_data <- dataset[-tissue_rows, , drop = FALSE]
  
  return(qcs_data)
}


# Dataset Upload
rawdata <- read.csv("Pipeline_#2_(QCS+Tissue)/Dataset/formatted_TIC_norm_combined_batch_data.csv",
                    row.names = 1,
                    check.names = FALSE) #126x121

sample_set_2 <- c("ChickenHeart", "ChickenLiver", "GoatLiver") ## change sample type names ### Preparing dataset

# get rid of tissue samples
qcs_batch_info_data <- extract_qcs_data(rawdata, sample_set_2)
batch_info_columns <- qcs_batch_info_data[, 1:2, drop = FALSE]

# get rid of x infront of values
colnames(qcs_batch_info_data)

# extract qcs data
QCS_mz_value_2 <- 260.186
IS_mz_value_2 <- 267.187

propranolol_peak_data <- qcs_batch_info_data[,colnames(qcs_batch_info_data) == QCS_mz_value_2, drop = FALSE]
propranolol_data_combat <- cbind(batch_info_columns, propranolol_peak_data)

d7_propranolol_peak_data <- qcs_batch_info_data[,colnames(qcs_batch_info_data) == IS_mz_value_2, drop = FALSE]
d7_propranolol_data_combat <- cbind(batch_info_columns, d7_propranolol_peak_data)

## Adding row, slide, day columns and ordering function ##
add_day_slide_row <- function(data) {
  # Extract slide numbers from rownames
  slide_numbers <- as.numeric(sub(".*S(\\d+)_.*", "\\1", rownames(data)))
  
  # Add the 'slide' column
  data$slide <- slide_numbers
  
  # Add the 'day' column based on slide ranges
  data$day <- ifelse(slide_numbers >= 1 & slide_numbers <= 6, 1,
                     ifelse(slide_numbers >= 7 & slide_numbers <= 12, 2,
                            ifelse(slide_numbers >= 13 & slide_numbers <= 18, 3, NA)))
  
  # Add the 'row' column based on QCS ranges
  data$row <- ifelse(
    as.numeric(sub(".*QCS_(\\d+).*", "\\1", rownames(data))) <= 3, 
    1, 
    2
  )
  
  # Order the data by slide_numbers
  data <- data[order(slide_numbers), ]
  
  # Return the modified and ordered dataset
  return(data)
}


# adding columns to datas
propranolol_data_combat <- add_day_slide_row(propranolol_data_combat)
d7_propranolol_data_combat <- add_day_slide_row(d7_propranolol_data_combat)

# replacing colname value into QCS/IS
colnames(propranolol_data_combat)[colnames(propranolol_data_combat) == "260.186"] <- "QCS"
colnames(d7_propranolol_data_combat)[colnames(d7_propranolol_data_combat) == "267.187"] <- "IS"

## VCA Plotting ##
library(VCA)
data(VCAdata1)
datS5 <- subset(VCAdata1, sample==5)
varPlot(form=y~(device+lot)/day/run, Data=datS5)

# QCS
plot <- propranolol_data_combat %>%
  as.data.frame() %>%
  select(c("injection.order", "batch", "QCS", "row", "slide", "day")) %>%
  mutate(scale = scale(QCS)) # Scaling QCS column

varPlot(form = scale ~ day/slide/row, 
        Data = plot,
        YLabel = list(text = "Raw peak area, scaling", side = 2, line = 2, cex = 1),
        MeanLine = list(var = c("int", "slide", "day"), 
                        col = c("white", "blue", "magenta"), lwd = c(2, 2, 2)), 
        BG = list(var = "day", col = paste0("gray", c(70, 80, 90))))

# Adding Title
title(main = "TIC Normalization Dataset (QCS)")

# IS
plot <- d7_propranolol_data_combat %>%
  as.data.frame() %>%
  select(c("injection.order", "batch", "IS", "row", "slide", "day")) %>%
  mutate(scale = scale(IS)) # Scaling QCS column

varPlot(form = scale ~ day/slide/row, 
        Data = plot,
        YLabel = list(text = "Raw peak area, scaling", side = 2, line = 2, cex = 1),
        MeanLine = list(var = c("int", "slide", "day"), 
                        col = c("white", "blue", "magenta"), lwd = c(2, 2, 2)), 
        BG = list(var = "day", col = paste0("gray", c(70, 80, 90))))

# Adding Title
title(main = "TIC Normalization Dataset (IS)")

dev.off()