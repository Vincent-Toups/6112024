# Load necessary libraries

library(ggplot2)

# Read in the sentence embeddings
embeddings <- read.csv("embeddings.csv", header=FALSE)

constant_columns <- which(apply(embeddings, 2, var) == 0)
embeddings <- embeddings[,-constant_columns]

# Print the number of constant columns removed
cat(length(constant_columns), "constant columns removed.\n")

# Perform PCA
pca_result <- prcomp(embeddings, scale. = TRUE, center = TRUE)

# Calculate cumulative variance explained
variance_explained <- summary(pca_result)$importance[3,]
cumulative_variance <- cumsum(variance_explained)

# Plot cumulative variance explained
df <- data.frame(Dimensions = 1:length(cumulative_variance), CumulativeVariance = cumulative_variance)
ggplot(df, aes(x = Dimensions, y = CumulativeVariance)) +
  geom_line() +
  geom_point() +
  labs(title="Cumulative Variance Explained by PCA", x="Principal Component", y="Cumulative Variance Explained") +
  theme_minimal()
