CREATE TABLE "public"."crime" (
    "id" serial,
    "crime" character varying,
    "lat" numeric,
    "lon" numeric,
    "reported_at" timestamp,
    "type" character varying,
    "the_geom" geometry,
    PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "public"."population" (
    "id" serial,
    "geoid" character varying,
    "geoid2" character varying,
    "name" text,
    "population" numeric,
    "margin_of_error" numeric,
    PRIMARY KEY ("id")
);

CREATE TABLE "public"."income" (
    "id" serial,
    "geoid" character varying,
    "geoid2" character varying,
    "name" text,
    "median_income" numeric,
    "margin_of_error" numeric,
    PRIMARY KEY ("id")
);
CREATE TABLE "public"."unemployment" (
    "id" serial,
    "geoid" character varying,
    "geoid2" character varying,
    "name" text,
    "total_labor_force" numeric,
    "in_labor_force" numeric,
    "unemployed" numeric,
    "not_in_labor_force" numeric,
    PRIMARY KEY ("id")
);
CREATE TABLE "public"."education" (
    "id" serial,
    "geoid" character varying,
    "geoid2" character varying,
    "name" text,
    "total" numeric,
    "college_or_higher" numeric,
    PRIMARY KEY ("id")
);

copy crime (crime,lat,lon,reported_at,type) from '/Users/nikita/Documents/crime_factors_USA/crime_reports.csv' DELIMITER ',' CSV header
copy population (geoid,geoid2,name,population,margin_of_error) from '/Users/nikita/Documents/crime_factors_USA/raw/population/ACS_13_5YR_B01003_with_ann.csv' DELIMITER ',' CSV header
copy income (geoid,geoid2,name,median_income,margin_of_error) from '/Users/nikita/Documents/crime_factors_USA/raw/percapita_income/ACS_13_5YR_B19301_with_ann.csv' DELIMITER ',' CSV header
copy unemployment (geoid,geoid2,name,total_labor_force,in_labor_force,unemployed, not_in_labor_force) from '/Users/nikita/Documents/crime_factors_USA/raw/employment_status/employment_status_2013.csv' DELIMITER ';' CSV header
copy education (geoid,geoid2,name,total,college_or_higher) from '/Users/nikita/Documents/crime_factors_USA/raw/edu_attainment/edu_attainment_2013.csv' DELIMITER ';' CSV header

