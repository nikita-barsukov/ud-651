install.packages(c('scales', 'ggplot2','reshape','ggmap','grid','rgdal',
                   'gpclib','maptools', 'devtools'))

download.file('ftp://ftp2.census.gov/geo/tiger/TIGER2013/BG/tl_2013_06_bg.zip', 
              'raw/tl_2013_06_bg.zip')
download.file('ftp://ftp2.census.gov/geo/tiger/TIGER2013/BG/tl_2013_17_bg.zip', 
              'raw/tl_2013_17_bg.zip')
unzip('raw/tl_2013_06_bg.zip',exdir='raw/tl_2013_06_bg/')
unzip('raw/tl_2013_17_bg.zip',exdir='raw/tl_2013_17_bg/')
