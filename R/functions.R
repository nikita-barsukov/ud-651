require("maptools")
require("ggplot2")
library('ggmap')
library('scales')

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

plot_histogram = function(dataset, variable, title, xlim, xaxis_title, perc = FALSE){
  p = ggplot(dataset) + 
    geom_histogram(aes_string(x=variable)) +
    ggtitle(title) +
    scale_y_continuous(name='Census block groups') +
    theme_bw()
  if(perc) {
    # covnert x labels to percent when necessary
    p = p + scale_x_continuous(limits=xlim, name=xaxis_title, labels=percent) 
  } else {
    p = p + scale_x_continuous(limits=xlim, name=xaxis_title)
  }
  return(p)
}

cor_mtrx = function(ds) {
  cor_mat = cor(ds)
  
  #we care only about correlations between demo vars from one side and crimes form other  
  cor_mat = cor_mat[4:7,1:3]
  rownames(cor_mat) = row_names
  colnames(cor_mat) = column_names
  return(cor_mat)
}


