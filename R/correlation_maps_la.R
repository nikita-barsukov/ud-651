library('rgdal')
require("maptools")
require("ggplot2")
library('ggmap')
library('grid')
source('R/multiplot.R')
source('R/functions.R')

# Since ID of census block groups are numeric strings often starting with 0
#  we need to explicitly set data tye to character
#  otehrwise they would be coersed to numeric
#  and zeroes would be lost.
ds_column_classes = c('character', 'character', rep('numeric',12))
demo_data = read.csv('clean_datasets/crime_demo_data.csv', 
                     colClasses = ds_column_classes)

demo_data$city=rep(NA, nrow(demo_data))
demo_data$city[grep('Los Angeles', demo_data$name)] = 'la'

# Dividing our continuous variables into bins
#  for choropleth maps
demo_data$unemp.brackets = cut(demo_data$unemployed, 
                               breaks=c(0,0.05,0.1,0.15,0.2,Inf), 
                               labels=c('Under 5%',
                                        '5%-10%',
                                        '10%-15%',
                                        '15%-20%',
                                        '20% and up'))
demo_data$income.brackets = cut(demo_data$median_income, 
                                breaks=c(0,25000,50000,75000,100000,Inf), 
                                labels=c('Under $25,000',
                                         '$25,000-$49,999',
                                         '$50,000-$74,999',
                                         '$75,000-99,999',
                                         '$100,000 and up'))
demo_data$edu.brackets = cut(demo_data$education, 
                             breaks=c(0,0.2,0.4,0.6,0.8,Inf), 
                             labels=c('Under 20%',
                                      '20%-40%',
                                      '40%-60%',
                                      '60%-80%',
                                      '80% and up'))
demo_data$density.brackets = cut(demo_data$density, 
                                 breaks=c(0,2500,5000,7500,10000,Inf), 
                                 labels=c('Under 2500',
                                          '2500-4999',
                                          '5000-7499',
                                          '7500-9999',
                                          '10000 and more'))
la_data = demo_data[demo_data$city == 'la',]

# Creating a layer with census block groups
ca.block.groups <- readOGR("raw/tl_2013_06_bg","tl_2013_06_bg")
ca.block.groups = ca.block.groups[ca.block.groups$GEOID %in% la_data$geoid,]
gpclibPermit()
merged.points = fortify(ca.block.groups, region='GEOID')

# Creating layer with general black-and-white LA map
watercolor_la <- get_map(location=c(lon=-118.3994, lat=34.0731), 
                         source = "stamen",
                         maptype = "toner-lite",
                         zoom=10)

la_income = plot_demo_data(watercolor_la ,
                           la_data,
                           merged.points,
                           'income.brackets',
                           "Median income,\nLos Angeles, 2013",
                           1)
la_density = plot_demo_data(watercolor_la ,
                            la_data,merged.points,
                           'density.brackets',
                           "Density, people per sq. km,\nLos Angeles, 2013",
                           2)
la_education = plot_demo_data(watercolor_la ,
                              la_data,merged.points,
                              'edu.brackets',
                              paste("Share of people",
                                    "with at least high school diploma,",
                                    "Chicago, 2013", sep='\n'),
                              3)
la_unemp = plot_demo_data(watercolor_la,
                          la_data,merged.points,
                          'unemp.brackets',
                          "Share of unemployed,\nLos Angeles, 2013",
                          4)
multiplot(la_income,
          la_density,
          la_education,
          la_unemp, 
          layout=matrix(c(1,2,3,4), nrow=2, byrow=TRUE))
