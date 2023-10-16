## code to prepare in `tracks` dataset goes here

library(tidyverse)

# Read in csv with GPS points
AllTracks_raw <- read_csv("data-raw/AllCCES_GPS.csv",show_col_types = FALSE)

## GPS tracks have 30 minute intervals, but note that there are TWO GPS transmitters that record on their own 30-min intervals.
## This is why GPS tracks are usually ~2 or ~30 minutes apart.

# Read in tracks, filter out lost buoys (1,2,3,5,6,9,11) and corrupted buoys (4,17)
AllTracks <- AllTracks_raw %>%
  dplyr::select(Latitude, Longitude, UTC, DriftName) %>%
  filter(!DriftName %in% c('CCES_004','CCES_017'))

AllTracks <- AllTracks[!duplicated(AllTracks[c('Longitude', 'Latitude','UTC', 'DriftName')]),]    # Remove duplicate timestamps


# Create new datafram for each buoy
d <- unique(AllTracks$DriftName)

for (drift in d) {
  assign(paste0("track", substr(drift, 5,8)), AllTracks %>% 
           dplyr::filter(DriftName == drift))
}


# Save as RDS
saveRDS(track_007, 'data/track_007.rda')
saveRDS(track_008, 'data/track_008.rda')
saveRDS(track_010, 'data/track_010.rda')
saveRDS(track_012, 'data/track_012.rda')
saveRDS(track_013, 'data/track_013.rda')
saveRDS(track_014, 'data/track_014.rda')
saveRDS(track_016, 'data/track_016.rda')
saveRDS(track_018, 'data/track_018.rda')
saveRDS(track_019, 'data/track_019.rda')
saveRDS(track_020, 'data/track_020.rda')
saveRDS(track_021, 'data/track_021.rda')
saveRDS(track_022, 'data/track_022.rda')
saveRDS(track_023, 'data/track_023.rda')


