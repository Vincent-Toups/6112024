import pandas as pd
from sklearn.manifold import MDS

# Read subset_distances from CSV
distances_df = pd.read_csv("subset_distances.csv")

# Convert DataFrame to 2D array
distances_array = distances_df.to_numpy()

# Initialize and fit MDS
mds = MDS(dissimilarity="precomputed")
results = mds.fit_transform(distances_array)

# Write results to CSV
results_df = pd.DataFrame(results)
results_df.to_csv("results.csv", index=False)
