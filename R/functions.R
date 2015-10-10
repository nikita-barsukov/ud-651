require("maptools")
require("ggplot2")
library('ggmap')
library('grid')

# Generic funciton plotting choropleth map
#   base_map: layer with city map of a city
#   demo_ds: dataset with demographic variables we want to plot
#   map_ds: fortified dataset of borders of census block groups
#   variable: factor variable from demo_ds to be used as color variable
#   title: plot title
#   palette_no: number of color brewer palette
plot_demo_data = function(base_map,demo_ds, map_ds, variable, title, palette_no) {
  map = ggmap(base_map, extent='normal', maprange=FALSE) + 
    geom_map(inherit.aes = FALSE,
             data = demo_ds, 
             aes_string(map_id = 'geoid', fill = variable, alpha=variable), 
             map = map_ds) + 
    scale_alpha_discrete(range=c(0.5,1),guide = FALSE) +
    guides(fill=guide_legend(title="")) +
    expand_limits(x = map_ds$long, y = map_ds$lat) +
    ggtitle(title)+
    coord_map(projection="mercator", 
              xlim=c(attr(base_map, "bb")$ll.lon, attr(base_map, "bb")$ur.lon),
              ylim=c(attr(base_map, "bb")$ll.lat, attr(base_map, "bb")$ur.lat)) +
    scale_fill_brewer(type = "seq", palette = palette_no) +
    theme_bw() +
    theme(axis.text=element_blank(),
          axis.title=element_blank(),
          axis.ticks=element_blank(),
          plot.margin=unit(c(0.1,0.1,0,0), "cm"))
  return(map)
}
