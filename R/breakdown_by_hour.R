library('ggplot2')
library('scales')
library('reshape')
library('ggmap')
library('grid')
source('R/multiplot.R')

# Line plots, % of reported crimes of each type in each city by hour.
crime_reports = read.csv('clean_datasets/crime_reports.csv')
crime_reports$type = factor(crime_reports$type, 
                            levels=c('personal', 'property', 'other'))
crime_reports_chicago = crime_reports[crime_reports$city == 'Chicago',]
crime_reports_la = crime_reports[crime_reports$city == 'Los Angeles',]

# Chicago and LA are in different timezone, 
#   so we need to parse reported time differently
crime_reports_chicago$reported_at = strptime(crime_reports_chicago$reported_at, 
                                             format='%Y-%m-%d %H:%M:%S', 
                                             tz='America/Chicago')
crime_reports_la$reported_at = strptime(crime_reports_la$reported_at, 
                                        format='%Y-%m-%d %H:%M:%S', 
                                        tz='America/Los_Angeles')
crime_reports = rbind(crime_reports_la, crime_reports_chicago)

crime_reports$by_hour = crime_reports$reported_at[['hour']]

# Summary table: total crime reports per city, type and hour
brkdn = table(crime_reports$by_hour, crime_reports$city, crime_reports$type)

# Dividing each column by sum of crime reports in Chicago and LA
sum_by_city = as.vector(table(crime_reports$city))
brkdn[,,'other'] = brkdn[,,'other']/sum_by_city
brkdn[,,'personal'] = brkdn[,,'personal']/sum_by_city
brkdn[,,'property'] = brkdn[,,'property']/sum_by_city

brkdn.melt = melt(brkdn)

p = ggplot(brkdn.melt, aes(x=Var.1, y=value)) + 
  geom_line() + 
  facet_grid(Var.2 ~ Var.3) + 
  theme_bw() +
  ggtitle('Reported crimes by hour in Los Angeles and Chicago, 2013') +
  scale_y_continuous(name='Share of reported crimes', labels = percent) +
  scale_x_continuous(name='Hour')

print(p)
