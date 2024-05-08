# rawdata
library(ggplot2)
library(stringr)
library(zoo)
library(dplyr)
# convert all columns combined_batch_data_df as numeric
combined_batch_data_df_numeric <- combined_batch_data_df %>%
  mutate_all(as.numeric)

# extract combined_batch_data df 
adjusted <- combined_batch_data_df_numeric[, -(1:3)]
batch_matrix <- data.frame(adjusted)
sample_ID <- str_extract(colnames(batch_matrix), "(S|m/z)\\d+")

# Create the regular expression pattern for sample_set
pattern <- paste(sample_set, collapse = "|")

# Extract sample types from column names using the defined pattern
sample_types <- str_extract(colnames(batch_matrix), pattern)
sample_types[is.na(sample_types)] <- "QCS"

# Transpose the data so that samples are on rows and features on columns
batch_data_t <- t(as.matrix(batch_matrix))

# Create a new data frame with the transposed matrix
batch_data_t_df <- as.data.frame(batch_data_t)

# Perform PCA, assuming batch_data_t_df contains the transposed data
batch_pca <- prcomp(batch_data_t_df, center = TRUE, scale. = TRUE)

# Create a data frame for plotting the PCA
pca_data <- data.frame(Sample = sample_ID, batch_pca$x)

# Plot PCA with colored sample dots based on sample type
pca_data$Score <- pca_data$PC1 + pca_data$PC2
pca_data$Type <- sample_types

# Calculate the PC1 and PC2 scores
pc1_score <- batch_pca$sdev[1]^2
pc2_score <- batch_pca$sdev[2]^2

# Calculate the total score as the sum of PC1 and PC2 scores
total_score <- pc1_score + pc2_score

# Display the score 
total_score_text_recon <- paste("Total Score:", round(total_score / sum(batch_pca$sdev^2) * 100, 2), "%")
cat(total_score_text_recon)

# Create PCA plot
plot <- ggplot(pca_data, aes(x = PC1, y = PC2, color = sample_types, label = Sample)) +
  geom_point(size = 5) +
  geom_text(hjust = 1.5, vjust = 1.5, size = 8, check_overlap = TRUE) +  # Increased label size
  xlab(paste("PC1 - ", round(batch_pca$sdev[1]^2 / sum(batch_pca$sdev^2) * 100, 2), "% Variance")) +
  ylab(paste("PC2 - ", round(batch_pca$sdev[2]^2 / sum(batch_pca$sdev^2) * 100, 2), "% Variance")) +
  ggtitle("No Normalization Raw Data") +
  theme_bw() +
  theme(legend.position = "right", axis.text = element_text(size = 20, face='bold'), 
        axis.title = element_text(size = 20, face='bold'),
        plot.title = element_text(size = 25, hjust = 0.5, face = 'bold'))
print(plot)

# normae
library(stringr)
sample_set <- c("ChickenHeart", "ChickenLiver", "GoatLiver")
# pca plot for normae
adjusted <- read.csv("dataset/Rec_nobe_no_norm.csv",
                     header = TRUE,
                     stringsAsFactors = FALSE,
                     row.names = 1)

batch_matrix <- data.frame(adjusted)
sample_ID <- str_extract(colnames(batch_matrix), "(S|m/z)\\d+")

# Create the regular expression pattern for sample_set
pattern <- paste(sample_set, collapse = "|")

# Extract sample types from column names using the defined pattern
sample_types_norm <- str_extract(colnames(batch_matrix), pattern)
sample_types_norm[is.na(sample_types)] <- "QCS"

# Transpose the data so that samples are on rows and features on columns
batch_data_t <- t(as.matrix(batch_matrix))

# Create a new data frame with the transposed matrix
batch_data_t_df <- as.data.frame(batch_data_t)

# Perform PCA, assuming batch_data_t_df contains the transposed data
batch_pca_norm <- prcomp(batch_data_t_df, center = TRUE, scale. = TRUE)

# Create a data frame for plotting the PCA
pca_data_norm <- data.frame(Sample = sample_ID, batch_pca_norm$x)

# Plot PCA with colored sample dots based on sample type
pca_data_norm$Score <- pca_data_norm$PC1 + pca_data_norm$PC2
pca_data_norm$Type <- sample_types

# Calculate the PC1 and PC2 scores
pc1_score <- batch_pca_norm$sdev[1]^2
pc2_score <- batch_pca_norm$sdev[2]^2

# Calculate the total score as the sum of PC1 and PC2 scores
total_score <- pc1_score + pc2_score

# Display the score 
total_score_text_recon <- paste("Total Score:", round(total_score / sum(batch_pca_norm$sdev^2) * 100, 2), "%")
cat(total_score_text_recon)

# Create PCA plot
plot_norm <- ggplot(pca_data_norm, aes(x = PC1, y = PC2, color = sample_types_norm, label = Sample)) +
  geom_point(size = 5) +
  geom_text(hjust = 1.5, vjust = 1.5, size = 8, check_overlap = TRUE) +  # Increased label size
  xlab(paste("PC1 - ", round(batch_pca_norm$sdev[1]^2 / sum(batch_pca_norm$sdev^2) * 100, 2), "% Variance")) +
  ylab(paste("PC2 - ", round(batch_pca_norm$sdev[2]^2 / sum(batch_pca_norm$sdev^2) * 100, 2), "% Variance")) +
  ggtitle("NormAE") +
  theme_bw() +
  theme(legend.position = "right", axis.text = element_text(size = 20, face='bold'), 
        axis.title = element_text(size = 20, face='bold'),
        plot.title = element_text(size = 25, hjust = 0.5, face = 'bold'))
print(plot_norm)
print(plot)