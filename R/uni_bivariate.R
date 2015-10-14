library('reshape')
library('ggplot2')
library('plyr')
source('R/functions.R')
source('R/multiplot.R')

# Plotting histograms
#   to get a feeling of data

# reading data
demo_data = read.csv('clean_datasets/crime_demo_data.csv')
demo_data[is.na(demo_data)] = 0
demo_data$city=rep(NA, nrow(demo_data))
demo_data$city[grep('Los Angeles', demo_data$name)] = 'Los Angeles'
demo_data$city[grep('Cook', demo_data$name)] = 'Chicago'

# preparing dataset for plotting
demo_data.crime.melt = melt(demo_data[c('crime_all',
                                        'crime_personal','crime_property')])

demo_data.crime.melt$variable = revalue(demo_data.crime.melt$variable, 
                                  c('crime_all'='All crime',
                                    'crime_property'='Property',
                                    'crime_personal'='Personal'))
# histogram of crime rate by crime type
p = ggplot(demo_data.crime.melt) + 
  geom_histogram(aes(x=value), binwidth = 1000) +
  ggtitle('Crime rate in census blocks') +
  facet_grid(variable ~ .) +
  scale_y_continuous(name='Census block groups') +
  scale_x_continuous(limits=c(0,75000), 
                     name='Crime reports\nper 100,000 inhabitants') +
  theme_bw() 

print(p)

# histograms of demographic variables
# plot_histogram defined in R/functions.R
dens_hist = plot_histogram(demo_data, 'density', 
                           'Population density in census blocks',
                           c(0,50000), 'Population density,\npeople per sq km')

income_hist = plot_histogram(demo_data, 'median_income', 
                           'Median income in census blocks',
                           c(0,150000), 'Individual median income')

edu_hist = plot_histogram(demo_data, 'education', 
                           'Education level in census blocks',
                          c(0,1), 'Share with at least high school degree', TRUE)

unemployment_hist = plot_histogram(demo_data, 'unemployed', 
                          'Share of unemployed in census blocks',
                          c(0,0.5), 'Share of unemployed', TRUE)
