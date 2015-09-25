Crime and demographic factors in selected US cities.
===============

Introduction
=========
I've been alsways interested in statistics and sociology of crime. Questions like 'Is there a connection between crime and poverty?', 'Does level of educaiton correlates with crime rate?' or 'Are factors correlated with property and personal crimes different or not?' have been dragging my attention for a long time.

This paper is an attempt to find which demographic factors correlate with level of crime using techniques from Udacity's course 'Exploratory data analysis with R'. I'll try to select demographic factors that might correlate with crime rate and cover the following broad topics:
 * determine which of selected factors correlate with level of crime,
 * is there different correlation factors between personal and property crimes.

Research dataset.
-------------
My starting point was to figure out how to get as granular dataset as possible both for crime and for demographic data. As it turns out, several major cities in US provide a dataset of every reported crime, with crime description and, which is even more important, geographical locations of reported crime. I obtained these datasets for two large US cities: Los Angeles and Chicago for the year 2013.

Primary source of varous demographic data for US is US census bureau and its site. It provides demographic data at various geographic levels. The smallest geographical unit for which the bureau publishes sample data is [census block group](https://en.wikipedia.org/wiki/Census_block_group). Additionally, bureau provides geographical shapes of these block groups. This allows us to determine block group of every reported crime, since our initial crime dataset contains information about geographical coordinates of the crime.

There is plenty of research around factors influencing crime. Most of the research describe following demographic factors, incluencing crime the most

 * Level of urbanization
 * Median income
 * Unemployment
 * Education level
 * Concentraiton of youth
 * Family condition, especially in respect to divorse, family composition etc.

Within the current paper I decided to focus on following variables:

 * Population density,
 * Median personal income,
 * Share of unemployed,
 * Share of those with educaiton level of at elast one year of college or higher.

All this data is available for download on census block group level through census.gov.

Constructing research dataset.
-----------------
Creating clean dataset for this paper was a long and time consuming task. It contained multiple steps, involving multiple technologies, like Excel, GIS, R and SQL. I used SQL for loading and merging data, and geographical extentions for Postgres database named PostGIS for geographical calculations. I also used Excel and R for cleaning up downloaded datasets. The process is described in detail in a separate document.

As part of cleaning up dataset, I had to assign manually if the crime was personal or property crime. Original crime datasets contained a column "crime type", however these were more granular crime types. More over, each police departments has its own set of crime types. In my case this column contained rather obvious types, such as 'Arson', 'Assault', 'Homicide' or 'Theft', as well as more obscure or granular types, such as 'OTHER MISCELLANEOUS CRIME' or 'THEFT, COIN MACHINE. I constructed a separate dataset with matches between reported crime type form dataset, and crime types used in this research: 'personal', 'property', 'other'. 

At the end I constructed two datasets about crime and demographic statistics in Los Angeles and Chicago:

1. crime_reports.csv, containing crime reports for 2013 in Los Angeles and Chicago. Its columns are: 
    1.1. crime, crime type as found in report. 
    1.2. lat and lon - latitude and longitue associated with the crime report
    1.3. reported_at. Date and hour when crime was reported to happen.
    1.4. city. Los Angeles or Chicago
    1.5. type. Personal, property or other.

2. crime_demo_data.csv, amount of personal, property and other crime by census block group, with demographic variables. FIn addition to census block identificator and crime levels, following demographic variables are present:
    2.1. population density, persons per sqkare kilometer;
    2.2. Median personal income, US DOllars;
    2.3. Share of unemployed
    2.4. Share of people with at least a year of college education.

