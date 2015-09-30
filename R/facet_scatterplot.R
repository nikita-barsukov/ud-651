#facet scatterplot
library('reshape')
library('ggplot2')
demo_data = read.csv('clean_datasets/crime_demo_data.csv')

#removing outliers
demo_data[is.na(demo_data)] = 0
demo_data = demo_data[demo_data$education < 1,]
demo_data = demo_data[demo_data$unemployed < 0.5,]
demo_data = demo_data[demo_data$crime_property < 2000,]
demo_data$crime_all = demo_data$crime_personal + demo_data$crime_property + demo_data$crime_other

demo_data = demo_data[c("geoid","crime_all","crime_property","crime_personal", "density","median_income","unemployed","education")]
crime_params = demo_data[c("geoid","crime_all","crime_property","crime_personal")]
demo_params = demo_data[c("geoid", "density","median_income","unemployed","education")]
crime_params_melt = melt(crime_params, id.vars='geoid')
demo_params_melt = melt(demo_params, id.vars='geoid')

data_melt = merge(crime_params_melt, demo_params_melt, by.x='geoid',by.y='geoid')

pl = ggplot(data_melt, aes(x=value.x, y=value.y)) +
  geom_point(size=1, alpha=0.1) +
  facet_grid(variable.y ~ variable.x, scales="free") +
  theme_bw() +
  ggtitle('Reported crimes and various demographics\nLA and Chicago, 2013') +
  theme(axis.title=element_blank(),
  plot.margin=unit(c(0.1,0.1,0,0), "cm"))
print(pl)
