Constructing research dataset.
------------

**Downloading raw data files**

I started with downloading crime datasets for the year 2013 for Los Angeles and Chicago. Crime datasets for Los Angeles and Chicago were obtained from Open Data portals of respective cities: 
https://data.cityofchicago.org/Public-Safety/Crimes-2013/a95h-gwzm 
https://data.lacity.org/A-Safe-City/LAPD-Crime-and-Collision-Raw-Data-for-2013/iatr-8mqm

My next step was to obtain geographical shapes of census blocks, to be able to attribute census block based on geographical coordinates in crime dataset. Shapefiles are available for download at [Census government portal](https://www.census.gov/cgi-bin/geo/shapefiles2013/layers.cgi).

Data of various social parameters: educational leel, employment status, population and median income was downloaded from American county survey website.

**Cleaning up the data**

After that I cleaned up raw crime datasets: removed all unecessary columns, transformed geographical coordinates to signle format, constructed time of report from available timestamp column, renamed columns and combined two datasets.

I also normalized raw demographic datasets. I changed headers, removed rows with missing numeric data from all the raw datasets. I kept rows with ID and name of block group. In addition to that I processed two tables in the following way:

1. Emloyment dataset. I left only column representing total size of workforce, number of those not in labor force and number of unemployed.
2. Education dataset. I added columns representing education level of at least a year in college or higher, and put it into a separate column. All the other columns representing various employment and unemployment parameters were removed. 

**Uploading data to database**

Next step was to upload clean CSV file with crime reports, shapefiles with block groups and census data:

Geographical data is uplaoded to table `census_blocks` using this console command: 

```
shp2pgsql -g geom -s 4269 -W LATIN1 tl_2013_17_bg/tl_2013_17_bg.shp block_group crime | psql -d crime

shp2pgsql -a -g geom -s 4269 -W LATIN1 tl_2013_17_tabblock/tl_2013_17_tabblock.shp tab_block census_blocks | psql -d census_blocks
```

Tables with crime reports and census data were created using commands specified here: https://gist.github.com/nikita-barsukov/8a2e085492631d256d53

**Merging datasets**

Having all raw datasets uploaded to database, final step would be to construct merged dataset, containing number of reported crimes by block group and crime type, with respective data from census tables. 

I started with creating indices on geometry columns in my geographic tables:
``` 
CREATE INDEX blocks_geom on block_group using GIST(geom);
CREATE INDEX point_geom on crime using GIST(the_geom);
```
This speeds up further geospatial calculations.

Next step modify crimes database to create a geometry column from longitude and lattitude, and then determine the block group of every reported crime: 

```
UPDATE crime
SET the_geom = ST_GeomFromText('POINT(' || lon || ' ' || lat || ')',4269);

select crime.type, crime.reported_at, block_group.geoid from crime, block_group where st_within(crime.the_geom, block_group.geom)
```

To simplify my queries I created a table view with the latter SQl statement. Then I created a pivot table from the newly created view:

```
SELECT
        *
    FROM
        crosstab (
            'select geoid, 
            ct.type as ty, 
            count(*)::integer from crime_block_data as ct 
            group by geoid, 
            ct.type order by 1,2' ) 
    AS ct (
        "geoid" CHARACTER VARYING,
        "other" INTEGER,
        "personal" INTEGER,
        "property" INTEGER )
```
Resulting table has following structure, wuth numeric columns showing number of reported crimes by type:

| geoid|other|personal|property|
|---|---|---|---|
|060371011101   |2   |12   |14   |
|060371011102   |3   |39   |45   |
|060371011103   |2   |23   |34   |


And finally I merged the table above with demographic tables. Resulting query which is rather complicated is given in following code snippet: https://gist.github.com/nikita-barsukov/8a2e085492631d256d53#file-get_final_dataset-sql
