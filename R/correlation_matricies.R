source('R/functions.R')
# Constructing matrices with correlation coefficients: 
#   Correlation of every demographic variable with 
#   every crime type in Chicago and LA 
library('reshape')

demo_data = read.csv('clean_datasets/crime_demo_data.csv')
demo_data$city=rep(NA, nrow(demo_data))
demo_data$city[grep('Los Angeles', demo_data$name)] = 'la'
demo_data$city[grep('Cook', demo_data$name)] = 'chicago'
demo_data[is.na(demo_data)] = 0

# these are columns that we need for our matrices
columns =  c("crime_all","crime_property","crime_personal","density",
             "median_income","unemployed","education")
# and these are names of rows and columns in our tables
row_names = c('Population density', 'Median Income','% of unemployed', 
              '% of high school diploma or more')
column_names = c('Total crimes', 'Property crimes', 'Personal crimes')

# cor_mtrx is a function from functions.R
mtrx = cor_mtrx(demo_data[,columns])
mtrx_la = cor_mtrx(demo_data[demo_data$city=='la',columns])
mtrx_ch = cor_mtrx(demo_data[demo_data$city=='chicago',columns])

plot_data = rbind(mtrx_ch, mtrx_la)
plot_data = melt(plot_data[,c(2,3)])

ch_correlations = plot_corr_coefficients(melt(mtrx_ch[,c(2,3)]),
                    "Crime rate and demographics,\ncorrelation in Chicago")
la_correlations = plot_corr_coefficients(melt(mtrx_la[,c(2,3)]),
                    "Crime rate and demographics,\ncorrelation in Los Angeles")
total_correlations = plot_corr_coefficients(melt(mtrx[,c(2,3)]),
                    "Crime rate and demographics,\ncorrelation in both cities")
