## code to prepare `whales` dataset here

library(tidyverse)
library(sf)

# Load raw RDA file
#load("data-raw/CCES2018_BW_Detections.rda")             # Beaked whales only
load("data-raw/CCES2018_BW_and_PM_Detections.rda")       # Beaked + sperm whales

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

# Save object
saveRDS(whales, 'data/whales.rda')
