## code to prepare `whales` dataset here

# Required library
library(tidyverse)

# Load raw RDA file
load("data-raw/CCES2018_BW_and_PM_Detections.rda")

# Change EventInfo object name to "whales" and edit columns
whales <- EventInfo %>%
  dplyr::select(-Project, -UID, -Id, -minNumber, -maxNumber, -bestNumber, -nClicks) %>%   # remove unnecessary columns
  subset(species!="?BW" & species!="BW") %>%        # remove rows containing ?BW and BW
  mutate(UTC = StartTime) %>%
  filter(!Deployment %in% c('1','2','3','4','5','6','9','11', '17'))

## Change Station 15 to Station 14 here. Drift 15 and 14 are the same (mix-up during fieldwork)
whales$Deployment[whales$Deployment == 15] <- 14


# Filter by drifts and assign WHALE to new variable (creates whale7, whale8,...)
g <- unique(whales$Deployment)

for (whale in g) {
  assign(paste0("whale", whale), whales %>% dplyr::filter(Deployment == whale))
}


############################################################################
## For interpolation of whale detections to fill in incorrect coordinates ##
############################################################################

## Interpolation. Need to access track.R first
approxLong <- approx(x = track_020$UTC, y=track_020$Longitude,
                     xout = whale20$UTC)$y
approxLat <- approx(x = track_020$UTC, y=track_020$Latitude,
                    xout = whale20$UTC)$y

# Create whale20.alt with new points
whale20.alt <- whale20 %>% mutate(Longitude = approxLong, Latitude = approxLat)


# Adding newly interpolated points to track_020:
columnselect <- whale20.alt %>% select(Latitude, Longitude, UTC) %>% add_column(DriftName = "CCES_020")
rowselect <- columnselect[51:69,]  #select whale detection rows that are missing from GPS


# Create new track_020.alt for buoy 20 interpolation analysis
# by pasting new points where GPS went dark
track_020.alt <- rbind(track_020[1:800,],
                       rowselect,
                       track_020[801:957,])

##############################################################################
## Removal of incorrect coordinates where buoy 20 GPS was malfunctioning #####
##############################################################################

# Bind top part with bottom part of df, removing questionable rows
whale20 <- rbind(whale20[1:50,], whale20[70:96,])
# whale20 rows go from 96 to 77


#############################################################
# Save newly created objects
saveRDS(whale7, 'data/whale7.rda')
saveRDS(whale8, 'data/whale8.rda')
saveRDS(whale10, 'data/whale10.rda')
saveRDS(whale12, 'data/whale12.rda')
saveRDS(whale13, 'data/whale13.rda')
saveRDS(whale14, 'data/whale14.rda')
saveRDS(whale16, 'data/whale16.rda')
saveRDS(whale18, 'data/whale18.rda')
saveRDS(whale19, 'data/whale19.rda')
saveRDS(whale20, 'data/whale20.rda')
saveRDS(whale21, 'data/whale21.rda')
saveRDS(whale22, 'data/whale22.rda')
saveRDS(whale23, 'data/whale23.rda')
saveRDS(whale20.alt, 'data/whale20_alt.rda')
saveRDS(track_020.alt, 'data/track_020_alt.rda')
