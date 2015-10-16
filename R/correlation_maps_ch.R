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

# Chicago is in Cook county
demo_data$city[grep('Cook', demo_data$name)] = 'chicago'

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
                                 labels=c('Under 2,500',
                                          '2,500-4,999',
                                          '5,000-7,499',
                                          '7,500-9,999',
                                          '10,000 and more'))

ch_data = demo_data[demo_data$city == 'chicago',]

# Creating layer with general black-and-white Chicago map
watercolor_ch <- get_map(location=c(lon=-87.6847, lat=41.8369), 
                         source = "stamen",
                         maptype = "toner-lite",
                         zoom=11)

# Creating a layer with census block groups
il.block.groups <- readOGR("raw/tl_2013_17_bg/","tl_2013_17_bg")
il.block.groups = il.block.groups[il.block.groups$GEOID %in% ch_data$geoid,]
gpclibPermit()
merged.points.ch = fortify(il.block.groups, region='GEOID')

# Mapping finction from R/functions.R
ch_income = plot_demo_data(watercolor_ch,
                           ch_data,
                           merged.points.ch,
                           'income.brackets',
                           paste("Median income,",
                                 "Chicago, 2013", sep="\n"),
                           1)
ch_density = plot_demo_data(watercolor_ch,
                            ch_data,
                            merged.points.ch,
                            'density.brackets',
                            paste("Density, people per sq. km,",
                                  "Chicago, 2013", sep='\n'),
                            2)
ch_education = plot_demo_data(watercolor_ch,
                              ch_data,
                              merged.points.ch,
                              'edu.brackets',
                              paste("Share of people",
                                    "with at least high school diploma,",
                                    "Chicago, 2013", sep='\n'),
                              3)
ch_unemp = plot_demo_data(watercolor_ch,
                          ch_data,
                          merged.points.ch,
                          'unemp.brackets',
                          paste("Share of unemployed,",
                                "Chicago, 2013", sep="\n"),
                          4)
multiplot(ch_income,
          ch_density,
          ch_education,
          ch_unemp, 
          layout=matrix(c(1,2,3,4),nrow=2, byrow=TRUE))
