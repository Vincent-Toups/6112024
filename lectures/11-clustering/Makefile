.PHONY: clean

clean:
	#rm -rf

pca_voltage_project.csv: source_data/voltages_wide.csv calc_voltage_pcs.R
	Rscript calc_voltage_pcs.R
	
spectral_clustering_labels.csv: pca_voltage_project.csv do_spectral_clustering.py
	python3 do_spectral_clustering.py
	
spectral_clustering_figure.png: spectral_clustering_labels.csv\
 make_spectral_clustering_figure.R\
 source_data/voltages_wide.csv
	Rscript make_spectral_clustering_figure.R