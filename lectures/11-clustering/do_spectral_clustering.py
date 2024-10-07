from sklearn.cluster import SpectralClustering
import numpy as np
import pandas;

data = pandas.read_csv("pca_voltage_project.csv").values;

clustering = SpectralClustering(n_clusters=3,
        assign_labels='discretize',
        random_state=0).fit(data)
clustering.labels_

print(clustering.labels_)
df = pandas.DataFrame({"labels":clustering.labels_});
df.to_csv("spectral_clustering_labels.csv", index=False);
