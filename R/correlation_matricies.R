demo_data = read.csv('clean_datasets/crime_demo_data.csv')
demo_data$city=rep(NA, nrow(demo_data))
demo_data$city[grep('Los Angeles', demo_data$name)] = 'la'
demo_data$city[grep('Cook', demo_data$name)] = 'chicago'
demo_data[is.na(demo_data)] = 0
demo_data$crime_all = demo_data$crime_personal + demo_data$crime_property + demo_data$crime_other

dd_la = demo_data[demo_data$city=='la',c("crime_all","crime_property","crime_personal","density","median_income","unemployed","education")]
mtrx_la = cor(dd_la)
mtrx_la = mtrx_la[4:7,1:3]
rownames(mtrx_la) = c('Population density', 'Median Income','% of unemployed', '% of at least a year in college')
colnames(mtrx_la) = c('Total crimes', 'Property crimes', 'Personal crimes')

dd_ch = demo_data[demo_data$city=='chicago',c("crime_all","crime_property","crime_personal","density","median_income","unemployed","education")]
mtrx_ch = cor(dd_ch)
mtrx_ch = mtrx_ch[4:7,1:3]
rownames(mtrx_ch) = c('Population density', 'Median Income','% of unemployed', '% of at least a year in college')
colnames(mtrx_ch) = c('Total crimes', 'Property crimes', 'Personal crimes')
