library('ggplot2')
library('scales')
library(reshape)
library('ggmap')
library('grid')
source('R/multiplot.R')

# Creating data matrices for summary tables of crime rates and crime reports

crime_reports = read.csv('clean_datasets/crime_reports.csv')

# Without that 'other' would be the top level in list of crime types
crime_reports$type = factor(crime_reports$type, 
                            levels=c('personal', 'property', 'other'))
crime_reports_chicago = crime_reports[crime_reports$city == 'Chicago',]
crime_reports_la = crime_reports[crime_reports$city == 'Los Angeles',]

# Relative crime rates in Chicago and LA
#   Chicago population 2013: 2,706,101
#   LA population: 3,792,621

crime_rates = c( sum(crime_reports_chicago$type=='personal')/2706101,
          sum(crime_reports_chicago$type=='property')/2706101, 
          nrow(crime_reports_chicago)/2706101, 
          sum(crime_reports_la$type=='personal')/3792621,
          sum(crime_reports_la$type=='property')/3792621, 
          nrow(crime_reports_la)/3792621)
crime_rates = 100000 * crime_rates #per 100,000 inhabitants
table_data=matrix(crime_rates, 
                  ncol=3, 
                  byrow = TRUE, 
                  dimnames=list(c('Chicago', 'Los Angeles'), 
                                c('personal', 'property', 'total')))
