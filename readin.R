
# Read in, load, and wrangle raw data

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


##########################
# Read in soundscape data, NEED TO MAKE THIS A FUNCTION
##########################

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
  dplyr::select(-Project)

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
                TOL_63, TOL_125, TOL_2000, TOL_5000, TOL_20000, species, BWpresence)  # keep necessary columns

#Drift 10
tracks_SS_10 <- left_join(tracks_10, BB_10, by = "dateTime") %>%    # join tracks with BB 10
  left_join(., TOL_10, by = "dateTime") %>%                         # join tracks with TOL 10 
  left_join(., whales10, by = "long") %>%                           # join whales 
  filter(spotID == "0-2572490") %>%                                 # filter by one SPOT
  mutate(BWpresence = if_else(is.na(nClicks), 0, 1)) %>%           # Add column to specify BW presence (1) or absence (0)
  dplyr::select(dateTime, lat.x, long, station, `BB_20-24000`, TOL_63, 
                TOL_125, TOL_2000, TOL_5000, TOL_20000, species, BWpresence)  # keep necessary columns

#########
# AIS
#########

#For 10-01-18 to 10-10-18

rawAIS <- read_csv("Data/AIS_100118_101018.csv", show_col_types = FALSE) # Vessel data from 10-01-18 to 10-10-18
drift <- tracks_10


# Filter by vessels over 100m in length, remove unnecessary columns
AIS <- rawAIS %>%
  filter(Length >= 100) %>%
  dplyr::select(-SOG,-COG, -CallSign, -IMO, -Cargo, -Draft, -Status)

# Currently unused
bbox <- st_bbox(c(xmin = min(drift$lat-0.7), 
                  xmax = max(drift$lat + 0.7), 
                  ymax = max(drift$long + 0.7), 
                  ymin = min(drift$long-0.7)), crs = st_crs(4326))

AIS_sf <- AIS %>%
  st_as_sf(coords = c("LON", "LAT"), crs=4326, remove=F) #%>%
#st_crop(y = bbox)

AIS_sf <- AIS_sf %>% 
  filter(BaseDateTime > "2018-10-05 00:00:00")  # Shorten time range to 10/05/2018 to 10/10/2018