
# Read in, load, clean up, and wrangle raw data

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

here()
#Remove global environment if needed
#rm(list=ls()) 

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


##########################
# Read in soundscape data, NEED TO MAKE THIS A FUNCTION
# look at http://ohi-science.org/data-science-training/programming.html#automation-with-for-loops for help on automation.
##########################

#dlist <- c(4,7,8,10,12,13,14,16,17,18,19,20,21,22,23)
sslist <- list.files(path = paste0("data-raw/"), pattern = "CCES_", recursive = TRUE)

#code doesnt work, can delete
#for (i in sslist) {
#  read_csv(paste0("data-raw/",i), show_col_types = FALSE)%>%
#  rename(dateTime = `yyyy-mm-ddTHH:MM:SSZ`) %>%
#  mutate(dateTime = round_date(ymd_hms(.$dateTime),"20 minutes")) %>%
#  assign(., value = paste0((substr(sslist[i], 16, 17)), substr(sslist[i], 6, 7)))
#}

#From ChatGPT, edited from above
for (i in sslist) {
  data <- read_csv(here(paste0("data-raw/", i)), show_col_types = FALSE) %>%
    rename(dateTime = `yyyy-mm-ddTHH:MM:SSZ`) %>%
    mutate(dateTime = round_date(ymd_hms(dateTime), "20 minutes")) %>%
    mutate(variable = paste0(substr(i, 16, 17), substr(i, 6, 7)))
  
  assign(paste0(substr(i, 16, 17), "_", substr(i, 6, 7)), data)
}


##################
# Read in Tracks
##################

# Load raw rda file
load("data-raw/CCES2018_DriftTracks_Modified_03Nov2022.rda")

# Read in tracks, filter out lost buoys (1,2,3,5,6,9,11) and corrupted buoys (4,17)
tracks <- AllTracks %>%
  dplyr::select(-dist, -speed) %>%
  mutate(dateTime = round_date(.$dateTime, "20 minutes")) %>%      # round to nearest 20 minutes, will create duplicated in the data
  filter(!station %in% c('1','2','3','4','5','6','9','11', '17')) %>%
  rename(Longitude = long,                                 # Need these columns to specifically say this for ERDDAP matching
         Latitude = lat,
         UTC = dateTime)
tracks <- tracks[!duplicated(tracks[c('UTC', 'station')]),]    # Remove duplicates

# Save as RDS
saveRDS(tracks, 'tracks.rds')

# Filter by buoy
#tracks_08 <- tracks %>% dplyr::filter(station == "8") 
track4 <- AllTracks %>% dplyr::filter(station == "4")

# Tracks on a map
#tracks_sf <- tracks %>% # make tracks an sf object
#  st_as_sf(coords= c("Longitude", "Latitude"), crs=4326, remove=F)

#tracks08sf <- tracks_08 %>%
#  st_as_sf(coords= c("Longitude", "Latitude"), crs=4326, remove=F)

#tracks10sf <- tracks_10 %>%
#  st_as_sf(coords= c("Longitude", "Latitude"), crs=4326, remove=F)


##########################
# Read in whale detections
##########################

# Load raw RDA file
#load("data-raw/CCES2018_BW_Detections.rda")             # Beaked whales only
load("data-raw/CCES2018_BW_and_PM_Detections.rda")       # Beaked  + sperm whales

# Change EventInfo object name to "whales" and edit columns
whales <- EventInfo %>%
  dplyr::select(-Project, -UID, -Id) %>%            # remove unnecessary columns
  subset(species!= "?BW") %>%                    # remove rows containing ?BW and BW
  subset(species!= "BW") %>%
  mutate(dateTimeRound = round_date(.$StartTime, "20 minutes")) %>%   # Round to nearest 20 min
  rename(station = Deployment)                    # Rename for common join column name next

## NEED TO CHANGE STATION 15 TO STATION 14 HERE. Drift 15 and 14 are the same.
whales$station[whales$station == 15] <- 14

# Create common UTC field and remove unnecessary fields
whales <- left_join(whales, tracks, by = join_by(station, closest("dateTimeRound" <= UTC))) %>%
  dplyr::select(-Latitude.y, -Longitude.y, -spotID, -minNumber, -maxNumber, -bestNumber)

# Whales data as sf
BWsf <- whales %>% st_as_sf(coords = c("Longitude.x","Latitude.x"), crs=4326)   # whales as sf

######################
# Join TRACKS with WHALES
######################

trk_whale <- left_join(tracks, whales, by = c("station","UTC")) #%>%
#  filter(!station %in% c('4','17'))  ## Can filter out buoys 4 and 17 here
View(trk_whale)

#Show duplicates (none??)
trk_whale <- trk_whale[!duplicated(trk_whale[c('UTC', 'station')]),]
View(trk_whale)

# Save object
saveRDS(trk_whale, 'trk_whale.rds')

###############
# Filter whales by drift
##############

# Create list of drifts
d <- unique(trk_whale$station)

# Filter by drifts and assign to new variable
for (drift in d) {
  assign(paste0("trk_whales", drift), trk_whale %>% dplyr::filter(station == drift))
}


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

#for (bb in bblist) {
#  for (ww in whlist) {
#    left_join(ww, bb, by = c("UTC" = "dateTime")) }}


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
tm_shape(worldmap, bbox = calif) + tm_polygons()
tmap_mode("view")
tm_basemap(leaflet::providers$Esri.OceanBasemap) + tm_shape(worldmap, bbox = bbox8) + tm_polygons()
