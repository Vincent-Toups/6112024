.PHONY: clean

clean:
	rm derived_data/*
	rm logs/*

derived_data/deduplicated_%.csv logs/deduplication_%.csv:\
  source_data/%.csv deduplicate.R
	Rscript deduplicate.R $*
