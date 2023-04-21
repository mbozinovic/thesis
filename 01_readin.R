## code to assemble clean dataframe for each buoy.
## Prerequisites include whales.R, tracks.R, soundscape_metrics.R.

# Look into https://bookdown.org/yihui/rmarkdown-cookbook/managing-projects.html for info on 
# managing projects with multiple Rmds and scripts

# libraries ##########

library(tidyverse)
library(lubridate)
library(sf)
library(rnaturalearth)
library(tmap)
library(here)

# set up #####

# Set system time zone to UTC
Sys.setenv(TZ='UTC')
here()

# Clear global environment if needed
# rm(list=ls()) 


######################
# Join TRACKS with WHALES (Start Rmd here)
######################
tracks <- readRDS('data/tracks.rda')
whales <- readRDS('data/whales.rda')
# Read in EACH BB and TO rda file??
# Should I add code to remove file if it exists?

trk_whale <- left_join(tracks, whales, by = c("station","UTC")) #%>%
#  filter(!station %in% c('4','17'))  ## Can filter out buoys 4 and 17 here
View(trk_whale)

#Show duplicates (none??)
trk_whale <- trk_whale[!duplicated(trk_whale[c('UTC', 'station')]),]
View(trk_whale)

###############
# Filter whales by drift
##############

# Create list of drifts
d <- unique(trk_whale$station)

# Filter by drifts and assign to new variable
for (drift in d) {
  assign(paste0("trk_whales", drift), trk_whale %>% dplyr::filter(station == drift))
}
# Results in trk_whales7, trk_whales8... objects

##############################################################
# Joining tracks with soundscape metrics with whale detections
# Make loop if possible
##############################################################

### Objects for forloop if I can figure it out.
#bblist <- c(BB08, BB10)
#tolist <- c(TO08, TO10)
#whlist <- c(whales8, whales10)

# to include when I have more BB metrics in my environment       
#BB12, BB13, BB14, BB15, BB16, BB18, BB19, BB20, BB21, BB22, BB23)
#TO12, TO13, TO14, TO15, TO16, TO18, TO19, TO20, TO21, TO22, TO23)


# Make function to join whales + tracks, broadband, and TOL soundscape metrics and edit columns
joinTable <- function(w, s, t) {
  left_join(w, s, by = c("UTC" = "dateTime")) %>%   # join tracks with broadband metrics
    .[!duplicated(.['UTC']),] %>%                   # removes duplicates
  left_join(., t, by = c("UTC"= "dateTime")) %>%
    .[!duplicated(.['UTC']),] %>%                   # removes duplicated again
  mutate(BWpresence = if_else(is.na(nClicks), 0, 1)) %>%    # Add column to specify BW presence (1) or absence (0)
  dplyr::select(UTC, spotID, Latitude, Longitude, station, 
                `BB_20-24000`,TOL_63, TOL_125, TOL_2000, 
                TOL_5000, TOL_20000, species, BWpresence)
}
 
#m <- left_join(trk_whales7, BB_07, by = c("UTC" = "dateTime")) %>%
#  .[!duplicated(.['UTC']),]

# join whales detections, soundscape metrics to each buoy track
# How can I loop this?
tracks_SS_07 <- joinTable(trk_whales7, BB_07, TO_07)
tracks_SS_08 <- joinTable(trk_whales8, BB_08, TO_08)
tracks_SS_10 <- joinTable(trk_whales10, BB_10, TO_10)
tracks_SS_11 <- joinTable(trk_whales11, BB_11, TO_11)
tracks_SS_12 <- joinTable(trk_whales12, BB_12, TO_12)
tracks_SS_13 <- joinTable(trk_whales13, BB_13, TO_13)
tracks_SS_14 <- joinTable(trk_whales14, BB_14, TO_14)
tracks_SS_16 <- joinTable(trk_whales16, BB_16, TO_16)
tracks_SS_18 <- joinTable(trk_whales18, BB_18, TO_18)
tracks_SS_19 <- joinTable(trk_whales19, BB_19, TO_19)
tracks_SS_20 <- joinTable(trk_whales20, BB_20, TO_20)
tracks_SS_21 <- joinTable(trk_whales21, BB_21, TO_21)
tracks_SS_22 <- joinTable(trk_whales22, BB_22, TO_22)
tracks_SS_23 <- joinTable(trk_whales23, BB_23, TO_23)


#### ignore this section below
# Drift 07
tracks_SS_07 <- left_join(trk_whales7, BB_07, by = c("UTC" = "dateTime")) %>%   # join tracks with broadband metrics
  left_join(., TO07, by = c("UTC"= "dateTime")) %>%                        # join tracks with TOL metrics
  mutate(BWpresence = if_else(is.na(nClicks), 0, 1)) %>%             # Add column to specify BW presence (1) or absence (0)
  dplyr::select(UTC, spotID, Latitude, Longitude, station, `BB_20-24000`,
                TOL_63, TOL_125, TOL_2000, TOL_5000, TOL_20000, species, BWpresence)  # keep necessary columns

# Drift 08
tracks_SS_08 <- left_join(trk_whales8, BB_08, by = c("UTC" = "dateTime")) %>%   # join tracks with broadband metrics
  left_join(., TO_08, by = c("UTC"= "dateTime")) %>%                        # join tracks with TOL metrics
  mutate(BWpresence = if_else(is.na(nClicks), 0, 1)) %>%             # Add column to specify BW presence (1) or absence (0)
  dplyr::select(UTC, spotID, Latitude, Longitude, station, `BB_20-24000`,
                TOL_63, TOL_125, TOL_2000, TOL_5000, TOL_20000, species, BWpresence)  # keep necessary columns

# Drift 10 #Need to remove duplicates
tracks_SS_10 <- left_join(trk_whales10, BB_10, by = c("UTC" = "dateTime")) %>%   # join tracks with broadband metrics
  left_join(., TO_10, by = c("UTC"= "dateTime")) %>%                        # join tracks with TOL metrics
  mutate(BWpresence = if_else(is.na(nClicks), 0, 1)) %>%             # Add column to specify BW presence (1) or absence (0)
  dplyr::select(UTC, spotID, Latitude, Longitude, station, `BB_20-24000`,
                TOL_63, TOL_125, TOL_2000, TOL_5000, TOL_20000, species, BWpresence)  # keep necessary columns

# Drift 11
tracks_SS_11 <- left_join(trk_whales11, BB_11, by = c("UTC" = "dateTime")) %>%   # join tracks with broadband metrics
  left_join(., TO_11, by = c("UTC"= "dateTime")) %>%                        # join tracks with TOL metrics
  mutate(BWpresence = if_else(is.na(nClicks), 0, 1)) %>%             # Add column to specify BW presence (1) or absence (0)
  dplyr::select(UTC, spotID, Latitude, Longitude, station, `BB_20-24000`,
                TOL_63, TOL_125, TOL_2000, TOL_5000, TOL_20000, species, BWpresence)  # keep necessary columns

# Drift 12
tracks_SS_12 <- left_join(trk_whales12, BB_12, by = c("UTC" = "dateTime")) %>%   # join tracks with broadband metrics
  left_join(., TO_12, by = c("UTC"= "dateTime")) %>%                        # join tracks with TOL metrics
  mutate(BWpresence = if_else(is.na(nClicks), 0, 1)) %>%             # Add column to specify BW presence (1) or absence (0)
  dplyr::select(UTC, spotID, Latitude, Longitude, station, `BB_20-24000`,
                TOL_63, TOL_125, TOL_2000, TOL_5000, TOL_20000, species, BWpresence)  # keep necessary columns

# Drift 13
tracks_SS_13 <- left_join(trk_whales13, BB_13, by = c("UTC" = "dateTime")) %>%   # join tracks with broadband metrics
  left_join(., TO_13, by = c("UTC"= "dateTime")) %>%                        # join tracks with TOL metrics
  mutate(BWpresence = if_else(is.na(nClicks), 0, 1)) %>%             # Add column to specify BW presence (1) or absence (0)
  dplyr::select(UTC, spotID, Latitude, Longitude, station, `BB_20-24000`,
                TOL_63, TOL_125, TOL_2000, TOL_5000, TOL_20000, species, BWpresence)  # keep necessary columns

# Drift 14
tracks_SS_14 <- left_join(trk_whales14, BB_14, by = c("UTC" = "dateTime")) %>%   # join tracks with broadband metrics
  left_join(., TO_14, by = c("UTC"= "dateTime")) %>%                        # join tracks with TOL metrics
  mutate(BWpresence = if_else(is.na(nClicks), 0, 1)) %>%             # Add column to specify BW presence (1) or absence (0)
  dplyr::select(UTC, spotID, Latitude, Longitude, station, `BB_20-24000`,
                TOL_63, TOL_125, TOL_2000, TOL_5000, TOL_20000, species, BWpresence)  # keep necessary columns

# Drift 15
tracks_SS_15 <- left_join(trk_whales15, BB_15, by = c("UTC" = "dateTime")) %>%   # join tracks with broadband metrics
  left_join(., TO_15, by = c("UTC"= "dateTime")) %>%                        # join tracks with TOL metrics
  mutate(BWpresence = if_else(is.na(nClicks), 0, 1)) %>%             # Add column to specify BW presence (1) or absence (0)
  dplyr::select(UTC, spotID, Latitude, Longitude, station, `BB_20-24000`,
                TOL_63, TOL_125, TOL_2000, TOL_5000, TOL_20000, species, BWpresence)  # keep necessary columns

# Drift 16
tracks_SS_16 <- left_join(trk_whales16, BB_16, by = c("UTC" = "dateTime")) %>%   # join tracks with broadband metrics
  left_join(., TO_16, by = c("UTC"= "dateTime")) %>%                        # join tracks with TOL metrics
  mutate(BWpresence = if_else(is.na(nClicks), 0, 1)) %>%             # Add column to specify BW presence (1) or absence (0)
  dplyr::select(UTC, spotID, Latitude, Longitude, station, `BB_20-24000`,
                TOL_63, TOL_125, TOL_2000, TOL_5000, TOL_20000, species, BWpresence)  # keep necessary columns

# Drift 18
tracks_SS_18 <- left_join(trk_whales18, BB_18, by = c("UTC" = "dateTime")) %>%   # join tracks with broadband metrics
  left_join(., TO_18, by = c("UTC"= "dateTime")) %>%                        # join tracks with TOL metrics
  mutate(BWpresence = if_else(is.na(nClicks), 0, 1)) %>%             # Add column to specify BW presence (1) or absence (0)
  dplyr::select(UTC, spotID, Latitude, Longitude, station, `BB_20-24000`,
                TOL_63, TOL_125, TOL_2000, TOL_5000, TOL_20000, species, BWpresence)  # keep necessary columns

# Drift 19
tracks_SS_19 <- left_join(trk_whales19, BB_19, by = c("UTC" = "dateTime")) %>%   # join tracks with broadband metrics
  left_join(., TO_19, by = c("UTC"= "dateTime")) %>%                        # join tracks with TOL metrics
  mutate(BWpresence = if_else(is.na(nClicks), 0, 1)) %>%             # Add column to specify BW presence (1) or absence (0)
  dplyr::select(UTC, spotID, Latitude, Longitude, station, `BB_20-24000`,
                TOL_63, TOL_125, TOL_2000, TOL_5000, TOL_20000, species, BWpresence)  # keep necessary columns

# Drift 20
tracks_SS_20 <- left_join(trk_whales20, BB_20, by = c("UTC" = "dateTime")) %>%   # join tracks with broadband metrics
  left_join(., TO_20, by = c("UTC"= "dateTime")) %>%                        # join tracks with TOL metrics
  mutate(BWpresence = if_else(is.na(nClicks), 0, 1)) %>%             # Add column to specify BW presence (1) or absence (0)
  dplyr::select(UTC, spotID, Latitude, Longitude, station, `BB_20-24000`,
                TOL_63, TOL_125, TOL_2000, TOL_5000, TOL_20000, species, BWpresence)  # keep necessary columns

# Drift 21
tracks_SS_21 <- left_join(trk_whales21, BB_21, by = c("UTC" = "dateTime")) %>%   # join tracks with broadband metrics
  left_join(., TO_21, by = c("UTC"= "dateTime")) %>%                        # join tracks with TOL metrics
  mutate(BWpresence = if_else(is.na(nClicks), 0, 1)) %>%             # Add column to specify BW presence (1) or absence (0)
  dplyr::select(UTC, spotID, Latitude, Longitude, station, `BB_20-24000`,
                TOL_63, TOL_125, TOL_2000, TOL_5000, TOL_20000, species, BWpresence)  # keep necessary columns

# Drift 22
tracks_SS_22 <- left_join(trk_whales22, BB_22, by = c("UTC" = "dateTime")) %>%   # join tracks with broadband metrics
  left_join(., TO_22, by = c("UTC"= "dateTime")) %>%                        # join tracks with TOL metrics
  mutate(BWpresence = if_else(is.na(nClicks), 0, 1)) %>%             # Add column to specify BW presence (1) or absence (0)
  dplyr::select(UTC, spotID, Latitude, Longitude, station, `BB_20-24000`,
                TOL_63, TOL_125, TOL_2000, TOL_5000, TOL_20000, species, BWpresence)  # keep necessary columns

# Drift 23
tracks_SS_23 <- left_join(trk_whales23, BB_23, by = c("UTC" = "dateTime")) %>%   # join tracks with broadband metrics
  left_join(., TO_23, by = c("UTC"= "dateTime")) %>%                        # join tracks with TOL metrics
  mutate(BWpresence = if_else(is.na(nClicks), 0, 1)) %>%             # Add column to specify BW presence (1) or absence (0)
  dplyr::select(UTC, spotID, Latitude, Longitude, station, `BB_20-24000`,
                TOL_63, TOL_125, TOL_2000, TOL_5000, TOL_20000, species, BWpresence)  # keep necessary columns

#write.csv(tracks_SS_08, "tracks_SS_08.csv", row.names=FALSE)


#Plots
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
tm_shape(worldmap, bbox = calif) + tm_polygons()
tmap_mode("view")
tm_basemap(leaflet::providers$Esri.OceanBasemap) + tm_shape(worldmap, bbox = bbox8) + tm_polygons()
