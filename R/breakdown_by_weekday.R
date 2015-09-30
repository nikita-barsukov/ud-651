library('ggplot2')
library('scales')
library(reshape)
library('ggmap')
library('grid')
source('R/multiplot.R')
crime_reports = read.csv('clean_datasets/crime_reports.csv')
crime_reports$type = factor(crime_reports$type, levels=c('personal', 'property', 'other'))
crime_reports_chicago = crime_reports[crime_reports$city == 'Chicago',]
crime_reports_la = crime_reports[crime_reports$city == 'Los Angeles',]

crime_reports_chicago$reported_at = strptime(crime_reports_chicago$reported_at, format='%Y-%m-%d %H:%M:%S', tz='America/Chicago')
crime_reports_la$reported_at = strptime(crime_reports_la$reported_at, format='%Y-%m-%d %H:%M:%S', tz='America/Chicago')
crime_reports = rbind(crime_reports_la, crime_reports_chicago)

crime_reports$by_weekday = weekdays(crime_reports$reported_at)
crime_reports$by_hour = crime_reports$reported_at[['hour']]

brkdn = table(crime_reports$by_weekday, crime_reports$city, crime_reports$type)
brkdn[,,'other'] = brkdn[,,'other']/c(304372, 231540)
brkdn[,,'personal'] = brkdn[,,'personal']/c(304372, 231540)
brkdn[,,'property'] = brkdn[,,'property']/c(304372, 231540)

brkdn.melt = melt(brkdn)
brkdn.melt$Var.1 = factor(brkdn.melt$Var.1, levels = rev(c('Monday', "Tuesday", 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')))

p = ggplot(brkdn.melt, aes(x=Var.1, y=value)) + 
  geom_bar(stat='identity') + 
  coord_flip() +
  facet_grid(Var.2 ~ Var.3) + 
  theme_bw() +
  theme(axis.title.y=element_blank()) +
  ggtitle('Reported crimes by weekday in Los Angeles and Chicago, 2013') +
  scale_y_continuous(name='Share of reported crimes', labels = percent) +
  scale_x_discrete(name='Day of week')

print(p)
