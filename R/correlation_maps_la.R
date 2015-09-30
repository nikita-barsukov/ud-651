library('rgdal')
require(maptools)
require(ggplot2)
library('ggmap')
library('grid')
source('R/multiplot.R')

ca.block.groups <- readOGR("raw/tl_2013_06_bg","tl_2013_06_bg")

demo_data = read.csv('clean_datasets/crime_demo_data.csv', colClasses = c('character', 'character', 'numeric', 'numeric','numeric','numeric', 'numeric', 'numeric', 'numeric'))
demo_data$city=rep(NA, nrow(demo_data))
demo_data$city[grep('Los Angeles', demo_data$name)] = 'la'
demo_data$city[grep('Cook', demo_data$name)] = 'chicago'
demo_data$unemp.brackets = cut(demo_data$unemployed, breaks=c(0,0.05,0.1,0.15,0.2,Inf), labels=c('Under 5%','5%-10%','10%-15%','15%-20%','20% and up'))
demo_data$income.brackets = cut(demo_data$median_income, breaks=c(0,25000,50000,75000,100000,Inf), labels=c('Under $25,000','$25,000-$49,999','$50,000-$74,999','$75,000-99,999','$100,000 and up'))
demo_data$edu.brackets = cut(demo_data$education, breaks=c(0,0.2,0.4,0.6,0.8,Inf), labels=c('Under 20%','20%-40%','40%-60%','60%-80%','80% and up'))
demo_data$density.brackets = cut(demo_data$density, breaks=c(0,500,1000,1500,2000,Inf), labels=c('Under 500','500-999','1000-1499','1500-1999','2000 and more'))

la_data = demo_data[demo_data$city == 'la',]
ch_data = demo_data[demo_data$city == 'chicago',]

ca.block.groups = ca.block.groups[ca.block.groups$GEOID %in% la_data$geoid,]
gpclibPermit()
merged.points = fortify(ca.block.groups, region='GEOID')

watercolor_la <- get_map(location=c(lon=-118.3994, lat=34.0731), 
                         source = "stamen",
                         maptype = "toner-lite",
                         zoom=10)
watercolor_ch <- get_map(location=c(lon=-87.6847, lat=41.8369), 
                         source = "stamen",
                         maptype = "toner-lite",
                         zoom=10)

plot_demo_data = function(base_map,demo_ds, map_ds, variable,limx, limy, title, plt) {
  map = ggmap(base_map, extent='normal', maprange=FALSE) + 
    geom_map(inherit.aes = FALSE,
             data = demo_ds, 
             aes_string(map_id = 'geoid', fill = variable, alpha=variable), 
             map = map_ds) + 
    scale_alpha_discrete(range=c(0.5,1),guide = FALSE) +
    guides(fill=guide_legend(title="")) +
    expand_limits(x = map_ds$long, y = map_ds$lat) +
    ggtitle(title)+
    coord_cartesian(xlim = limx, ylim=limy) + 
    scale_fill_brewer(type = "seq", palette = plt) +
    theme_bw() +
    theme(axis.text=element_blank(),
          axis.title=element_blank(),
          axis.ticks=element_blank(),
          plot.margin=unit(c(0.1,0.1,0,0), "cm"))
  return(map)
}
la_income = plot_demo_data(watercolor_la ,
                           la_data,
                           merged.points,
                   'income.brackets',
                   c(-118.7, -118.1),
                   c(34.35,33.8),
                   "Median income,\nLos Angeles, 2013",
                   1)
la_density = plot_demo_data(watercolor_la ,la_data,merged.points,
                   'density.brackets',
                   c(-118.7, -118.1),
                   c(34.35,33.8),
                   "Density, people per sq. km,\nLos Angeles, 2013",
                   2)
la_education = plot_demo_data(watercolor_la ,la_data,merged.points,
                            'edu.brackets',
                            c(-118.7, -118.1),
                            c(34.35,33.8),
                            "Share of people\nwith at least a year in college,\nLos Angeles, 2013",
                            3)
la_unemp = plot_demo_data(watercolor_la ,la_data,merged.points,
                              'unemp.brackets',
                              c(-118.7, -118.1),
                              c(34.35,33.8),
                              "Share of unemployed,\nLos Angeles, 2013",
                              4)
multiplot(la_income, la_density,la_education,la_unemp, layout=matrix(c(1,2,3,4), nrow=2, byrow=TRUE))
