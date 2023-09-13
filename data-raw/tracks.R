## code to prepare in `tracks` dataset goes here

library(tidyverse)

# Read in csv with GPS points
AllTracks_raw <- read_csv("data-raw/AllCCES_GPS.csv")

# Read in tracks, filter out lost buoys (1,2,3,5,6,9,11) and corrupted buoys (4,17)
AllTracks <- AllTracks_raw %>%
  dplyr::select(Latitude, Longitude, UTC, DriftName) %>%
  #mutate(dateTime = round_date(.$dateTime, "20 minutes")) %>% # round to nearest 20 minutes, will create duplicated in the data
  filter(!DriftName %in% c('CCES_004','CCES_017'))

AllTracks <- AllTracks[!duplicated(AllTracks[c('Longitude', 'Latitude','UTC', 'DriftName')]),]    # Remove duplicate timestamps

# Save as RDS
saveRDS(AllTracks, 'data/AllTracks.rda')
 
