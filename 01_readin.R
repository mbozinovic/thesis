## code to assemble clean dataframe for each buoy.
## Prerequisites include whales.R, tracks.R, soundscape_metrics.R.


# libraries ##########

library(tidyverse)
library(lubridate)
library(here)

# set up #####

# Set system time zone to UTC
Sys.setenv(TZ='UTC')
here()

######################
# Join TRACKS with WHALES (Start Rmd here)
######################
tracks <- readRDS('data/tracks.rda')
whales <- readRDS('data/whales.rda')

# Join tracks and whales
trk_whale <- left_join(tracks, whales, by = c("station","UTC"))

# Remove duplicates
trk_whale <- trk_whale[!duplicated(trk_whale[c('UTC', 'station')]),]

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
##############################################################

## Make list of rda files to read in
iilist <- c("BB_07", "BB_08", "BB_10", "BB_12", "BB_13", "BB_14", "BB_16", 
            "BB_18", "BB_19", "BB_20", "BB_21", "BB_22", "BB_23", "TO_07",
            "TO_08", "TO_10", "TO_12", "TO_13", "TO_14", "TO_16", "TO_18", 
            "TO_19", "TO_20", "TO_21", "TO_22", "TO_23")

## Read in rda files and assign to object
for (ii in iilist) {
  dta <- readRDS(paste0('data/', ii, '.rda'))
  
  assign(ii, dta)
}

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
 

# join whales detections + soundscape metrics (BB and TO) to each buoy track
# How can I loop this?
tracks_SS_07 <- joinTable(trk_whales7, BB_07, TO_07)
tracks_SS_08 <- joinTable(trk_whales8, BB_08, TO_08)
tracks_SS_10 <- joinTable(trk_whales10, BB_10, TO_10)
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

