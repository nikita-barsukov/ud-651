library('ggplot2')
library('scales')
library(reshape)
library('ggmap')
library('grid')
source('R/multiplot.R')
crime_reports = read.csv('clean_datasets/crime_reports.csv')
crime_reports$type = factor(crime_reports$type, 
                            levels=c('personal', 'property', 'other'))
crime_reports_chicago = crime_reports[crime_reports$city == 'Chicago',]
crime_reports_la = crime_reports[crime_reports$city == 'Los Angeles',]
chicago_crimes_total = table(crime_reports$city)['Chicago']
la_crimes_total = table(crime_reports$city)['Los Angeles']
brkdn = table(crime_reports$city, crime_reports$type)
ds = melt(brkdn/apply(brkdn, 1, sum))

sums = c(sum(crime_reports_chicago$type=='personal')/2706101,
          sum(crime_reports_chicago$type=='property')/2706101, 
          nrow(crime_reports_chicago)/2706101, 
          sum(crime_reports_la$type=='personal')/3792621,
          sum(crime_reports_la$type=='property')/3792621, 
          nrow(crime_reports_la)/3792621)
table_data=matrix(100000 * sums, 
                  ncol=3, 
                  byrow = TRUE, 
                  dimnames=list(c('Chicago', 'Los Angeles'), 
                                c('personal', 'property', 'total')))
