options(scipen = 99999)
chicago = read.csv('raw/Chicago-Crimes_-_2013.csv')
la = read.csv('raw/LAPD_Crime_and_Collision_Raw_Data_for_2013.csv')

# Dropping all obsolete columns
chicago = chicago[c('Date', 'Primary.Type', 'Latitude', 'Longitude')]
la = la[c('DATE.OCC', 'TIME.OCC','Crm.Cd.Desc','Location.1')]

# Dropping rows with NA
chicago = chicago[complete.cases(chicago),]
la = la[complete.cases(la),]
la$Location.1 = as.character(la$Location.1)
la = la[nchar(la$Location.1) > 0,]

# Proper geo coordiantes for LA
la$Location.1 = gsub('[\\(\\)]', '', la$Location.1)
coords = strsplit(la$Location.1, ',')
coords = do.call(rbind.data.frame, coords)
colnames(coords) = c('lat', 'lon')
coords$lat = as.numeric(as.character(coords$lat))
coords$lon = as.numeric(as.character(coords$lon))

la = cbind(la, coords)
la$Location.1 = NULL
rm(coords)

# Fixing timestamps
#la$TIME.OCC = sprintf("%04d", as.numeric(la$TIME.OCC))
la$time = paste(la$DATE.OCC, sprintf("%04d", la$TIME.OCC), sep=' ')
la$DATE.OCC = NULL
la$TIME.OCC = NULL
la$time = strptime(la$time, '%m/%d/%Y %H%M', tz='America/Los_Angeles')
chicago$Date = strptime(chicago$Date, '%m/%d/%Y %I:%M:%S %p', tz='America/Chicago')

#column names
colnames(chicago) = c('reported_at', 'crime', 'lat', 'lon')
colnames(la) = c('crime', 'lat', 'lon', 'reported_at')
chicago$city='Chicago'
la$city = 'Los Angeles'
crime_reports = rbind(la, chicago)
ct = read.csv('clean_datasets/crime_types.csv', sep=';')
crime_reports = merge(crime_reports, ct, by.x='crime', by.y='crime')
write.csv(crime_reports, 'clean_datasets/crime_reports.csv', row.names=F)
