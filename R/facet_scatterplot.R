library('reshape')
library('ggplot2')
library('plyr')
demo_data = read.csv('clean_datasets/crime_demo_data.csv')

# Removing outliers from dataset
demo_data[is.na(demo_data)] = 0
demo_data = demo_data[demo_data$education < 1,]
demo_data = demo_data[demo_data$density < 100000,]
demo_data = demo_data[demo_data$unemployed < 0.5,]
demo_data = demo_data[demo_data$crime_personal < 50000,]
demo_data = demo_data[demo_data$crime_property < 100000,]

# Preparing data for facet plot
demo_data = demo_data[c("geoid",
                        "crime_all",
                        "crime_property",
                        "crime_personal",
                        "density",
                        "median_income",
                        "unemployed",
                        "education")]
crime_params = demo_data[c("geoid",
                           "crime_all",
                           "crime_property",
                           "crime_personal")]
demo_params = demo_data[c("geoid",
                          "density",
                          "median_income",
                          "unemployed",
                          "education")]
crime_params_melt = melt(crime_params, id.vars='geoid')
demo_params_melt = melt(demo_params, id.vars='geoid')
plot_data_melt = merge(crime_params_melt, demo_params_melt, by.x='geoid',by.y='geoid')

# Renaming factor levels for better labels on plot
plot_data_melt$variable.x = revalue(plot_data_melt$variable.x, 
                                    c('crime_all'='All crime',
                                      'crime_property'='Property',
                                      'crime_personal'='Personal'))
plot_data_melt$variable.y = revalue(plot_data_melt$variable.y, 
                                    c('density'='Density',
                                      'median_income'='Median income',
                                      'unemployed'='Unemployment',
                                      'education'='Education'))

pl = ggplot(plot_data_melt, aes(x=value.x, y=value.y)) +
  geom_point(size=1, alpha=0.1) +
  facet_grid(variable.y ~ variable.x, scales="free") +
  theme_bw() +
  ggtitle('Reported crimes and various demographics\nLA and Chicago, 2013') +
  theme(axis.title=element_blank(),
  plot.margin=unit(c(0.1,0.1,0,0), "cm"))
print(pl)
