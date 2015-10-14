ds = read.csv('raw/ACS_13_5YR_B15003_with_ann.csv', 
              colClasses = c('character', 'character', 'character', 
                             rep('numeric', 50)))

ds = ds[c('Id', 'Id2', 'Geography', colnames(ds)[grep('Estimate',colnames(ds))])]
ds$high_school_or_higher = rowSums(ds[c(19:27)])/ds$Estimate..Total.

ds = ds[c("Id", "Id2", 'Geography','Estimate..Total.','high_school_or_higher')]
colnames(ds) = c('geoid','geoid2','name','total','high_school_or_higher')
ds = ds[complete.cases(ds),]
write.csv(ds,'raw/edu_attainment_2013.csv', row.names = F)
