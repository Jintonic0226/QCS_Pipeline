version
library(kableExtra)

## IS Normalization ##
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
rawdata <- read.csv("Pipeline_#1_QCS/Dataset/formatted_IS_norm_batch_data.csv",
                    row.names = 1,
                    check.names = FALSE
) 
qcs_batch_info_data <- rawdata #3x108

# get rid of x infront of values
colnames(qcs_batch_info_data)
rownames(qcs_batch_info_data) #3x108

# transpose
propranolol_data_combat <- as.data.frame(t(qcs_batch_info_data))
colnames(propranolol_data_combat) <- rownames(qcs_batch_info_data)
rownames(propranolol_data_combat) <- colnames(qcs_batch_info_data) #108x3




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

## VCA Plotting ##
library(VCA)
data(VCAdata1)
datS5 <- subset(VCAdata1, sample==5)
varPlot(form=y~(device+lot)/day/run, Data=datS5)

# QCS
plot <- propranolol_data_combat %>%
  as.data.frame() %>%
  select(c("injection.order", "batch", "ratio", "row", "slide", "day")) %>%
  mutate(scale = scale(ratio)) # Scaling ratio column

varPlot(form = scale ~ day/slide/row, 
        Data = plot,
        YLabel = list(text = "Raw peak area, scaling", side = 2, line = 2, cex = 1),
        MeanLine = list(var = c("int", "slide", "day"), 
                        col = c("white", "blue", "magenta"), lwd = c(2, 2, 2)), 
        BG = list(var = "day", col = paste0("gray", c(70, 80, 90))))

# Adding Title
title(main = "IS Normalization Dataset")
