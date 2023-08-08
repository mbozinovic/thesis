## code to prepare in `tracks` dataset goes here

library(tidyverse)

# Load raw rda file
load("data-raw/CCES2018_DriftTracks_Modified_03Nov2022.rda")

# Read in tracks, filter out lost buoys (1,2,3,5,6,9,11) and corrupted buoys (4,17)
tracks <- AllTracks %>%
  dplyr::select(-dist, -speed) %>%
  mutate(dateTime = round_date(.$dateTime, "20 minutes")) %>% # round to nearest 20 minutes, will create duplicated in the data
  filter(!station %in% c('1','2','3','4','5','6','9','11', '17')) %>%
  rename(Longitude = long,              # Need these columns to specifically say this for ERDDAP matching
         Latitude = lat,
         UTC = dateTime)
tracks <- tracks[!duplicated(tracks[c('UTC', 'station')]),]    # Remove duplicates

# Save as RDS
saveRDS(tracks, 'data/tracks.rda')

# Filter by buoy
#tracks_08 <- tracks %>% dplyr::filter(station == "8") 
track4 <- AllTracks %>% dplyr::filter(station == "4")



### Option to create AllTracks before rounding to nearest 20 min, for AIS
tracks2 <- AllTracks %>%
  dplyr::select(-dist, -speed) %>%
  filter(!station %in% c('1','2','3','4','5','6','9','11', '17')) %>%
  rename(Longitude = long,            # Need these columns to specifically say this for ERDDAP matching
         Latitude = lat,
         UTC = dateTime)

tracks7 <- tracks2 %>%
  filter(station== 7)
