# Constructing matrices with correlation coefficients: 
#   Correlation of every demographic variable with 
#   every crime type in Chicago and LA 

demo_data = read.csv('clean_datasets/crime_demo_data.csv')
demo_data$city=rep(NA, nrow(demo_data))
demo_data$city[grep('Los Angeles', demo_data$name)] = 'la'
demo_data$city[grep('Cook', demo_data$name)] = 'chicago'
demo_data[is.na(demo_data)] = 0
demo_data$crime_all = demo_data$crime_personal + 
  demo_data$crime_property + 
  demo_data$crime_other

# these are columns that we need for our matrices
columns =  c("crime_all","crime_property","crime_personal","density",
             "median_income","unemployed","education")
# and these are names of rows and columns in our tables
row_names = c('Population density', 'Median Income','% of unemployed', 
              '% of at least a year in college')
column_names = c('Total crimes', 'Property crimes', 'Personal crimes')

dd_la = demo_data[demo_data$city=='la',columns]
mtrx_la = cor(dd_la)
# columns are crime types, rows are demographic parameters
mtrx_la = mtrx_la[4:7,1:3]
rownames(mtrx_la) = row_names
colnames(mtrx_la) = column_names

dd_ch = demo_data[demo_data$city=='chicago', columns]
mtrx_ch = cor(dd_ch)
mtrx_ch = mtrx_ch[4:7,1:3]
rownames(mtrx_ch) = row_names
colnames(mtrx_ch) = column_names
