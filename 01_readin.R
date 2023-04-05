
# Read in, load, clean up, and wrangle raw data

# Look into https://bookdown.org/yihui/rmarkdown-cookbook/managing-projects.html for info on 
# managing projects with multiple Rmds and scripts

###########################
# Required packages
###########################

library(tidyverse)
library(lubridate)
library(sf)
library(rerddap)
library(terra)
library(marmap)
library(rnaturalearth)
library(mapproj)
library(raster)
library("rerddapXtracto")
library(PAMpal)
library(maptiles)
library(tmap)
library(spData)
library(tmaptools)
library(grid)
library(ggspatial)
library(here)
library(leaflet)

##########################
# Read in soundscape data, NEED TO MAKE THIS A FUNCTION
# look at http://ohi-science.org/data-science-training/programming.html#automation-with-for-loops for help on automation.
##########################
here()

# Set system time zone to UTC
Sys.setenv(TZ='UTC')

worldmap <- ne_countries(scale = 'medium', type = 'map_units',
                         returnclass = 'sf')
calif <- st_crop(worldmap, 
                 xmin = 33.7,
                 xmax = 40,
                 ymin = -131,
                 ymax = -122)
calif <- st_transform(calif, 4326)

tmap_options(basemaps=c(Terrain = "Esri.WorldTerrain",
                        Imagery = "Esri.WorldImagery", 
                        OceanBasemap = "Esri.OceanBasemap", 
                        Topo="OpenTopoMap",
                        Ortho="GeoportailFrance.orthos"))


# Round to nearest 20 minutes, create dateTime data type
# Drift 8: Broadband
BB_08_csv <- read_csv("Data/CCES_08_1Hz_1s_BB_2min.csv", show_col_types = FALSE)
BB_08 <- BB_08_csv %>% 
  rename(dateTime = `yyyy-mm-ddTHH:MM:SSZ`)
BB_08 <- BB_08 %>%
  mutate(dateTime = round_date(ymd_hms(BB_08$dateTime),"20 minutes"))

# Drift 8: Octave Level
OL_08_csv <- read_csv("Data/CCES_08_1Hz_1s_OL_2min.csv",show_col_types = FALSE)
OL_08 <- OL_08_csv %>% 
  rename(dateTime = `yyyy-mm-ddTHH:MM:SSZ`)
OL_08 <- OL_08 %>%
  mutate(dateTime = round_date(ymd_hms(OL_08$dateTime),"20 minutes"))

# Drift 8: TOL
TOL_08_csv<- read_csv("data/CCES_08_1Hz_1s_TOL_2min.csv", show_col_types = FALSE)
TOL_08 <- TOL_08_csv %>% 
  rename(dateTime = `yyyy-mm-ddTHH:MM:SSZ`)
TOL_08 <- TOL_08 %>%
  mutate(dateTime = round_date(ymd_hms(TOL_08$dateTime),"20 minutes"))
write.csv(TOL_08, "TOL_08.csv", row.names=FALSE)

# Drift 10: Broadband
BB_10_csv <- read_csv("Data/CCES_10_1Hz_1s_BB_2min.csv", show_col_types = FALSE)
BB_10 <- BB_10_csv %>% 
  rename(dateTime = `yyyy-mm-ddTHH:MM:SSZ`)
BB_10 <- BB_10 %>%
  mutate(dateTime = round_date(ymd_hms(BB_10$dateTime),"20 minutes"))

# Drift 10: TOL
TOL_10_csv<- read_csv("data/CCES_10_1Hz_1s_TOL_2min.csv", show_col_types = FALSE)
TOL_10 <- TOL_10_csv %>% 
  rename(dateTime = `yyyy-mm-ddTHH:MM:SSZ`)
TOL_10 <- TOL_10 %>%
  mutate(dateTime = round_date(ymd_hms(TOL_10$dateTime),"20 minutes"))


# Drift 10: Octave level
OL_10_csv <- read_csv("Data/CCES_10_1Hz_1s_OL_2min.csv", show_col_types = FALSE)
OL_10 <- OL_10_csv %>% 
  rename(dateTime = `yyyy-mm-ddTHH:MM:SSZ`)
OL_10 <- OL_10 %>%
  mutate(dateTime = round_date(ymd_hms(OL_10$dateTime),"20 minutes"))


##################
# Read in Tracks
##################

# Read in tracks, filter out lost buoys
tracks <- read_csv("Data/AllTracks.csv", show_col_types = FALSE) %>%
  dplyr::filter(station == "4"| station == "7"| station =="8" |station == "10"|          # filter out lost buoys
                  station == "12"|station == "13"| station == "14"| station == "16"|
                  station == "17"|station == "18"| station == "19"| station == "20"| 
                  station == "21"|station == "22"| station == "23") %>%
  mutate(dateTime = round_date(ymd_hms(.$dateTime), "20 minutes"))                       # round to nearest 20 minutes

# Filter by buoy 8 and 10
tracks_08 <- tracks %>% dplyr::filter(station == "8")
tracks_10 <- tracks %>% dplyr::filter(station == "10")

# Tracks on a map
tracks_sf <- tracks %>% # make tracks an sf object
  st_as_sf(coords= c("long", "lat"), crs=4326, remove=F)

tracks08sf <- tracks_08 %>%
  st_as_sf(coords= c("long", "lat"), crs=4326, remove=F)

tracks10sf <- tracks_10 %>%
  st_as_sf(coords= c("long", "lat"), crs=4326, remove=F)


##########################
# Read in whale detections
##########################


# All whale detections
whales <- read_csv("Data/EventInfo.csv", show_col_types = FALSE) %>%
  mutate(lat = as.numeric(Latitude)) %>%
  mutate(long = as.numeric(Longitude)) %>%
  mutate(bestNumber = as.numeric(bestNumber)) %>%   #convert nClicks from character to numeric
  mutate(nClicks = as.numeric(nClicks)) %>%      # convert nClicks from character to numeric
  mutate(StartTime = mdy_hm(StartTime)) %>%      #convert time from character to datetime
  mutate(EndTime = mdy_hm(EndTime)) %>%
  drop_na(...1)%>%                                 # remove NAs in column labeled "...1"
  dplyr::select(-Project) %>%
  subset(species!= "?BW")

BWsf <- whales %>% st_as_sf(coords = c("long","lat"), crs=4326)   # whales as sf

# Drift 10 whales as sf
whales10_sf <- BWsf %>%                            
  dplyr::filter(Deployment == "10")

whales08_sf <- BWsf %>%                            
  dplyr::filter(Deployment == "8")

# Drift 10 whales
whales10 <- whales %>%
  dplyr::filter(Deployment == "10")

# Drift 8 whales
whales8 <- whales %>%
  dplyr::filter(Deployment == "8")

whales_8_10sf <- BWsf %>%                            
  dplyr::filter(Deployment == "8" | Deployment == "10")

##############################################################
# Joining tracks with soundscape metrics with whale detections
##############################################################

# Drift 08
tracks_SS_08 <- left_join(tracks_08, BB_08, by = "dateTime") %>%   # join tracks with BB 08
  left_join(., TOL_08, by = "dateTime") %>%                        # join TOL
  left_join(., whales8, by = "long") %>%                           # join whales 
  filter(spotID == "0-2571609") %>%                                # filter by one SPOT
  mutate(BWpresence = if_else(is.na(nClicks), 0, 1)) %>%           # Add column to specify BW presence (1) or absence (0)
  dplyr::select(dateTime, lat.x, long, station, `BB_20-24000`,
                TOL_63, TOL_125, TOL_2000, TOL_5000, TOL_20000, species, BWpresence) %>%  # keep necessary columns
  mutate(Latitude = lat.x, 
         Longitude = long, 
         UTC = as.POSIXct(dateTime, format='%Y-%m-%d %H:%M:%S', tz='UTC'))

#Drift 10
tracks_SS_10 <- left_join(tracks_10, BB_10, by = "dateTime") %>%    # join tracks with BB 10
  left_join(., TOL_10, by = "dateTime") %>%                         # join tracks with TOL 10 
  left_join(., whales10, by = "long") %>%                           # join whales 
  filter(spotID == "0-2572490") %>%                                 # filter by one SPOT
  mutate(BWpresence = if_else(is.na(nClicks), 0, 1)) %>%           # Add column to specify BW presence (1) or absence (0)
  dplyr::select(dateTime, lat.x, long, station, `BB_20-24000`, TOL_63, 
                TOL_125, TOL_2000, TOL_5000, TOL_20000, species, BWpresence) %>%  # keep necessary columns
  mutate(Latitude = lat.x, 
         Longitude = long, 
         UTC = as.POSIXct(dateTime, format='%Y-%m-%d %H:%M:%S', tz='UTC'))


#########
# AIS
#########

#For 09-03-18 to 09-11-18
rawAIS <- read_csv("Data/AIS_090318_091118.csv", show_col_types = FALSE)

# Filter by vessels over 100m in length, remove unnecessary columns
AIS <- rawAIS %>%
  filter(Length >= 100) %>%
  dplyr::select(-SOG,-COG, -CallSign, -IMO, -Cargo, -Draft, -Status)

AIS_sf <- AIS %>%
  st_as_sf(coords = c("LON", "LAT"), crs=4326, remove=F)

##################################
# Create 10 km buffer around buoys
##################################

trk <- tracks08sf  # Shorten the object name to trk
pois <- st_transform(trk, crs = 4326)    # Specify a crs
pts_buff <- st_buffer(pois, dist = 10000)  # Buffer all points in trk to 10 km (10000m)
buff <- st_transform(pts_buff, crs = 4326)  # Specify crs

# Plot showing 10km buffer around drift 8
tmap_mode("plot")
tm_shape(buff) + tm_symbols(col = "blue", border.col = NA) +
  tm_shape(trk) + tm_dots(col = "red")
 

### Crop full AIS to 10km buffer around drift 8 ###
AIS_crop <- st_crop(x = AIS_sf, y = pts_buff)

# Intersect buffer with AIS
inters <- st_intersection(buff, AIS_crop[1:10,])

# Plot
ggplot(tracks_SS_08, aes(x = long, y = lat.x)) + geom_point() 
 + geom_sf(data = bbox8, aes(col = "red"))

# Plot showing AIS bouding box around drift 8 tracks
ggplot() + geom_sf(data = bbox8) + geom_sf(data = pts_buff,color = "red")

ggplot() +
  geom_sf(data = calif) + coord_sf(default_crs = sf::st_crs(4326)) + theme_bw()
 # geom_sf(data = AIS_sf)


#Plots
tm_shape(worldmap, bbox = calif) + tm_polygons()
tmap_mode("view")
tm_basemap(leaflet::providers$Esri.OceanBasemap) + tm_shape(worldmap, bbox = bbox8) + tm_polygons()
