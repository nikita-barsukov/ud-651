library('ggplot2')
library('ggmap')
library('grid')
source('R/multiplot.R')

crime_reports = read.csv('clean_datasets/crime_reports.csv')

la_data_personal = crime_reports[crime_reports$city=='Los Angeles' & 
                                   crime_reports$type=='personal',]
la_data_property = crime_reports[crime_reports$city=='Los Angeles' & 
                                   crime_reports$type=='property',]
ch_data_personal = crime_reports[crime_reports$city=='Chicago' & 
                                   crime_reports$type=='personal',]
ch_data_property = crime_reports[crime_reports$city=='Chicago' & 
                                   crime_reports$type=='property',]

watercolor_la <- get_map(location=c(lon=-118.3994, lat=34.0731), 
                      source = "stamen",
                      maptype = "toner-lite",
                      zoom=11)
watercolor_ch <- get_map(location=c(lon=-87.6847, lat=41.8369), 
                         source = "stamen",
                         maptype = "toner-lite",
                         zoom=11)

plot_map = function(base_map, plot_data, title, high_color) {
  m = ggmap(base_map)  +
    stat_density2d(data = plot_data, aes(x=lon, y=lat, fill=..level..), 
                   geom="polygon",
                   alpha=0.6) +
    scale_fill_gradient(low = "#e8e8e8", high = high_color, name='Density') +
    ggtitle(title) +
    theme(
      axis.line = element_blank(),
      axis.text.y = element_blank(),
      axis.text.x = element_blank(),
      axis.ticks = element_blank(),
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      panel.border = element_blank(),
      panel.background = element_blank(),
      plot.margin=unit(c(0.1,0.1,0,0), "cm")
    )
  return(m)   
}

multiplot(plot_map(watercolor_la, 
                   la_data_personal, 
                   'Personal crimes in LA, 2013', 
                   "brown"),
          plot_map(watercolor_la, 
                   la_data_property, 
                   'Property crimes in LA, 2013', 
                   "blue"),
          plot_map(watercolor_ch, 
                   ch_data_personal, 
                   'Personal crimes in Chicago, 2013', 
                   "brown"),
          plot_map(watercolor_ch, ch_data_property, 
                   'Property crimes in Chicago, 2013', 
                   "blue"),
          layout=matrix(c(1,2,3,4), nrow=2, byrow=TRUE))
