# Crime and demographic factors in Los Angeles and Chicago
Grading paper for Udacity's course "Explore and Summarize data", part of Data Analyst Nanodegree.

Datasets used in the paper were created by me. Citations are given in `supporting_texts\`

## Dependencies
Code is tested on MacOS machine. 

First and foremost, R (and RStudio). Paper contains maps, plotted using geographical files provided by census.gov website. Setup script download these files using console program `wget`.

For data scraping and cleaning (described in detail in a [separate document](https://github.com/nikita-barsukov/ud-651/blob/master/supporting_texts/dataset_construction.md)) you will also need Postgres and Postgis. Loading geographical files are done with `shp2pgsql` command. However you don't need it since the clean datasets are already in folder `clean_datasets`.

## How to run the code

Open folder in RStudio, run `setup.R` and then knit `report.Rmd`. HTML version of this report is checked into the repository.
