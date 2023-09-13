## code to assemble clean dataframe for each buoy.
## Prerequisites include whales.R, tracks.R
## Results in dataframe for each buoy containing whale detections and buoy GPS points.


# libraries #######

library(tidyverse)
library(PAMpal)
library(here)

# set up #####

# Set system time zone to UTC
Sys.setenv(TZ='UTC')
here()

# Read in GPS tracks and whale detections
AllTracks <- readRDS('data/AllTracks.rda')
whales <- readRDS('data/whales.rda')

###############
# Filter whales by drift
##############

# Create list of drifts
#d <- unique(trk_whale$station)

# Filter by drifts and assign to new variable
#for (drift in d) {
#  assign(paste0("trk_whales", drift), trk_whale %>% dplyr::filter(station == drift))
#}
# Results in trk_whales7, trk_whales8... objects

##############################################################
# Joining tracks with soundscape metrics with whale detections
##############################################################

## Make list of rda files to read in
#iilist <- c("BB_07", "BB_08", "BB_10", "BB_12", "BB_13", "BB_14", "BB_16", 
#            "BB_18", "BB_19", "BB_20", "BB_21", "BB_22", "BB_23", "TO_07",
#            "TO_08", "TO_10", "TO_12", "TO_13", "TO_14", "TO_16", "TO_18", 
#            "TO_19", "TO_20", "TO_21", "TO_22", "TO_23")

## Read in rda files and assign to object
#for (ii in iilist) {
#  dta <- readRDS(paste0('data/', ii, '.rda'))
  
#  assign(ii, dta)
#}

# Make function to join whales + tracks, broadband, and TOL soundscape metrics and edit columns
#joinTable <- function(w, s, t) {
#  left_join(w, s, by = join_by(closest("UTC" <= "dateTime"))) %>%     # join tracks with broadband metrics
#    .[!duplicated(.['UTC']),] %>%                                     # removes duplicates
#  left_join(., t, by = join_by(closest("UTC" <= "dateTime"))) %>%    # joins tracks/BB with TOL metrics
#    .[!duplicated(.['UTC']),] %>%                                     # removes duplicates formed from new join
#  mutate(Wpresence = if_else(is.na(nClicks), 0, 1)) %>%    # Add column to specify whale presence (1) or absence (0)
#  dplyr::select(UTC, spotID, Latitude, Longitude, station, 
#                `BB_20-24000`,TOL_63, TOL_125, TOL_1600, 
#                TOL_2000, TOL_3150, TOL_5000, TOL_8000, 
#                TOL_10000, TOL_12500, TOL_20000, species, Wpresence)
#}
 

# join whales detections + soundscape metrics (BB and TO) to each buoy track
# How can I loop this?
#tracks_SS_07 <- joinTable(trk_whales7, BB_07, TO_07)
#tracks_SS_08 <- joinTable(trk_whales8, BB_08, TO_08)
#tracks_SS_10 <- joinTable(trk_whales10, BB_10, TO_10)
#tracks_SS_12 <- joinTable(trk_whales12, BB_12, TO_12)
#tracks_SS_13 <- joinTable(trk_whales13, BB_13, TO_13)
#tracks_SS_14 <- joinTable(trk_whales14, BB_14, TO_14)
#tracks_SS_16 <- joinTable(trk_whales16, BB_16, TO_16)
#tracks_SS_18 <- joinTable(trk_whales18, BB_18, TO_18)
#tracks_SS_19 <- joinTable(trk_whales19, BB_19, TO_19)
#tracks_SS_20 <- joinTable(trk_whales20, BB_20, TO_20)
#tracks_SS_21 <- joinTable(trk_whales21, BB_21, TO_21)
#tracks_SS_22 <- joinTable(trk_whales22, BB_22, TO_22)
#tracks_SS_23 <- joinTable(trk_whales23, BB_23, TO_23)


#################################################
# Filter by drifts and assign TRACK to new variable
d <- unique(AllTracks$DriftName)

for (drift in d) {
  assign(paste0("track", substr(drift, 5,8)), AllTracks %>% dplyr::filter(DriftName == drift))
}

# Filter by drifts and assign WHALE to new variable
g <- unique(whales$Deployment)

for (whale in g) {
  assign(paste0("whale", whale), whales %>% dplyr::filter(Deployment == whale))
}


# timeJoin whales and tracks by buoy. Threshold times differ by buoy
trk_whl7 <- PAMpal::timeJoin(whale7, track_007,
                             thresh = 34000, interpolate = FALSE) #large threshold to accommodate one
                                                                  # oddly functioning GPS transmission.
                                                                  # Buoy GPS pt and detection have same 
                                                                  # coordinate.

trk_whl8 <- PAMpal::timeJoin(whale8, track_008, 
                             thresh = 1000, interpolate = FALSE)
trk_whl10 <- PAMpal::timeJoin(whale10, track_010, 
                             thresh = 3600, interpolate = FALSE)
trk_whl12 <- PAMpal::timeJoin(whale12, track_012, 
                             thresh = 7700, interpolate = FALSE)
trk_whl13 <- PAMpal::timeJoin(whale13, track_013, 
                             thresh = 810, interpolate = FALSE)
trk_whl14 <- PAMpal::timeJoin(whale14, track_014, 
                             thresh = 850, interpolate = FALSE)
trk_whl16 <- PAMpal::timeJoin(whale16, track_016, 
                             thresh = 3600, interpolate = FALSE)
trk_whl18 <- PAMpal::timeJoin(whale18, track_018, 
                             thresh = 3600, interpolate = FALSE)
trk_whl19 <- PAMpal::timeJoin(whale19, track_019, 
                             thresh = 3600, interpolate = FALSE)
#trk_whl20 <- PAMpal::timeJoin(whale20, track_020, 
                            # thresh = 36000, interpolate = TRUE)   # Still has some unmatched whale detections

trk_whl21 <- PAMpal::timeJoin(whale21, track_021, 
                             thresh = 3600, interpolate = FALSE)
trk_whl22 <- PAMpal::timeJoin(whale22, track_022, 
                             thresh = 54400, interpolate = FALSE) #large threshold to accommodate one
                                                                  # oddly functioning GPS transmission.
                                                                  # Buoy GPS pt and detection have same 
                                                                  # coordinate.
trk_whl23 <- PAMpal::timeJoin(whale23, track_023, 
                             thresh = 3600, interpolate = FALSE)

# Should I interpolate trk_whl20 to get more refined coordinates for some detections?
#whale20NA <- whale20 %>% 
#  filter(UTC >= "2018-11-15 07:45:11" & UTC <= "2018-11-19 09:35:29")

#x <- c(29.75768, 29.37579)
#y <- c(-116.8591, -116.6891)
#approx(x,y)

#replace(whale20NA[4,2:19], whales20NA$Latitude, NA)
#df.zoo <- zoo(whale20NA)
#na.approx(df.zoo,)

##########################################################
# Create two dfs with identical column names to rbind 'species' with closest timestamp

##### Buoy 7 ######
#Create empty 'species' column within tracks df
track7_new <- track_007 %>% 
  select(UTC, Latitude, Longitude) %>% 
  add_column(species = NA)

# Select UTC, lat/long species from whale detection with GPS pts df
trk_whl_7_new <- trk_whl7 %>% 
  select(UTC, Latitude, Longitude, species)

# Bind GPS tracks to whale detection's nearest GPS point. Duplicates are created where spp exist due to rbind.
# Will remove empty spp in next line WITHOUT removing multiple spp per GPS pt.
bind7 <- rbind(track7_new, trk_whl_7_new)

# Final output with UTC, lat/long, and Whale detections.
# It's important to keep duplicate timestamps because they may be associated with 1) multiple species
# or 2) same species, multiple vocalizations
GPSwhale7 <- bind7 %>% distinct()


##### Buoy 8 #########
#Create empty 'species' column
track8_new <- track_008 %>% 
  select(UTC, Latitude, Longitude) %>% 
  add_column(species = NA)

# Select UTC, lat/long species from df
trk_whl_8_new <- trk_whl8 %>% 
  select(UTC, Latitude, Longitude, species)

# Bind GPS tracks to whale detection's nearest GPS point. Duplicates are created where spp exist due to rbind.
# Will remove empty spp in next line WITHOUT removing multiple spp per GPS pt.
bind8 <- rbind(track8_new, trk_whl_8_new)

# Final output with UTC, lat/long, and Whale detections.
# It's important to keep duplicate timestamps because they may be associated with 1) multiple species
# or 2) same species, multiple vocalizations
GPSwhale8 <- bind8 %>% distinct()



##### Buoy 10 ######
#Create empty 'species' column
track10_new <- track_010 %>% 
  select(UTC, Latitude, Longitude) %>% 
  add_column(species = NA)

# Select UTC, lat/long species from df
trk_whl_10_new <- trk_whl10 %>% 
  select(UTC, Latitude, Longitude, species)

# Bind GPS tracks to whale detection's nearest GPS point. Duplicates are created where spp exist due to rbind.
# Will remove empty spp in next line WITHOUT removing multiple spp per GPS pt.
bind10 <- rbind(track10_new, trk_whl_10_new)

# Final output with UTC, lat/long, and Whale detections.
# It's important to keep duplicate timestamps because they may be associated with 1) multiple species
# or 2) same species, multiple vocalizations
GPSwhale10 <- bind10 %>% distinct()


##### Buoy 12 ######
#Create empty 'species' column
track12_new <- track_012 %>% 
  select(UTC, Latitude, Longitude) %>% 
  add_column(species = NA)

# Select UTC, lat/long species from df
trk_whl_12_new <- trk_whl12 %>% 
  select(UTC, Latitude, Longitude, species)

# Bind GPS tracks to whale detection's nearest GPS point. Duplicates are created where spp exist due to rbind.
# Will remove empty spp in next line WITHOUT removing multiple spp per GPS pt.
bind12 <- rbind(track12_new, trk_whl_12_new)

# Final output with UTC, lat/long, and Whale detections.
# It's important to keep duplicate timestamps because they may be associated with 1) multiple species
# or 2) same species, multiple vocalizations
GPSwhale12 <- bind12 %>% distinct()



##### Buoy 13 ######
#Create empty 'species' column
track13_new <- track_013 %>% 
  select(UTC, Latitude, Longitude) %>% 
  add_column(species = NA)

# Select UTC, lat/long species from df
trk_whl_13_new <- trk_whl13 %>% 
  select(UTC, Latitude, Longitude, species)

# Bind GPS tracks to whale detection's nearest GPS point. Duplicates are created where spp exist due to rbind.
# Will remove empty spp in next line WITHOUT removing multiple spp per GPS pt.
bind13 <- rbind(track13_new, trk_whl_13_new)

# Final output with UTC, lat/long, and Whale detections.
# It's important to keep duplicate timestamps because they may be associated with 1) multiple species
# or 2) same species, multiple vocalizations
GPSwhale13 <- bind13 %>% distinct()


##### Buoy 14 ######
#Create empty 'species' column
track14_new <- track_014 %>% 
  select(UTC, Latitude, Longitude) %>% 
  add_column(species = NA)

# Select UTC, lat/long species from df
trk_whl_14_new <- trk_whl14 %>% 
  select(UTC, Latitude, Longitude, species)

# Bind GPS tracks to whale detection's nearest GPS point. Duplicates are created where spp exist due to rbind.
# Will remove empty spp in next line WITHOUT removing multiple spp per GPS pt.
bind14 <- rbind(track14_new, trk_whl_14_new)

# Final output with UTC, lat/long, and Whale detections.
# It's important to keep duplicate timestamps because they may be associated with 1) multiple species
# or 2) same species, multiple vocalizations
GPSwhale14 <- bind14 %>% distinct()


##### Buoy 16 ######
#Create empty 'species' column
track16_new <- track_016 %>% 
  select(UTC, Latitude, Longitude) %>% 
  add_column(species = NA)

# Select UTC, lat/long species from df
trk_whl_16_new <- trk_whl16 %>% 
  select(UTC, Latitude, Longitude, species)

# Bind GPS tracks to whale detection's nearest GPS point. Duplicates are created where spp exist due to rbind.
# Will remove empty spp in next line WITHOUT removing multiple spp per GPS pt.
bind16 <- rbind(track16_new, trk_whl_16_new)

# Final output with UTC, lat/long, and Whale detections.
# It's important to keep duplicate timestamps because they may be associated with 1) multiple species
# or 2) same species, multiple vocalizations
GPSwhale16 <- bind16 %>% distinct()



##### Buoy 18 ######
#Create empty 'species' column
track18_new <- track_018 %>% 
  select(UTC, Latitude, Longitude) %>% 
  add_column(species = NA)

# Select UTC, lat/long species from df
trk_whl_18_new <- trk_whl18 %>% 
  select(UTC, Latitude, Longitude, species)

# Bind GPS tracks to whale detection's nearest GPS point. Duplicates are created where spp exist due to rbind.
# Will remove empty spp in next line WITHOUT removing multiple spp per GPS pt.
bind18 <- rbind(track18_new, trk_whl_18_new)

# Final output with UTC, lat/long, and Whale detections.
# It's important to keep duplicate timestamps because they may be associated with 1) multiple species
# or 2) same species, multiple vocalizations
GPSwhale18 <- bind18 %>% distinct()


##### Buoy 19 ######
#Create empty 'species' column
track19_new <- track_019 %>% 
  select(UTC, Latitude, Longitude) %>% 
  add_column(species = NA)

# Select UTC, lat/long species from df
trk_whl_19_new <- trk_whl19 %>% 
  select(UTC, Latitude, Longitude, species)

# Bind GPS tracks to whale detection's nearest GPS point. Duplicates are created where spp exist due to rbind.
# Will remove empty spp in next line WITHOUT removing multiple spp per GPS pt.
bind19 <- rbind(track19_new, trk_whl_19_new)

# Final output with UTC, lat/long, and Whale detections.
# It's important to keep duplicate timestamps because they may be associated with 1) multiple species
# or 2) same species, multiple vocalizations
GPSwhale19 <- bind19 %>% distinct()



##### Buoy 20 ######
#Create empty 'species' column
track20_new <- track_020 %>% 
  select(UTC, Latitude, Longitude) %>% 
  add_column(species = NA)

# Select UTC, lat/long species from df
trk_whl_20_new <- trk_whl20 %>% 
  select(UTC, Latitude, Longitude, species)

# Bind GPS tracks to whale detection's nearest GPS point. Duplicates are created where spp exist due to rbind.
# Will remove empty spp in next line WITHOUT removing multiple spp per GPS pt.
bind20 <- rbind(track20_new, trk_whl_20_new)

# Final output with UTC, lat/long, and Whale detections.
# It's important to keep duplicate timestamps because they may be associated with 1) multiple species
# or 2) same species, multiple vocalizations
GPSwhale20 <- bind20 %>% distinct()


##### Buoy 21 ######
#Create empty 'species' column
track21_new <- track_021 %>% 
  select(UTC, Latitude, Longitude) %>% 
  add_column(species = NA)

# Select UTC, lat/long species from df
trk_whl_21_new <- trk_whl21 %>% 
  select(UTC, Latitude, Longitude, species)

# Bind GPS tracks to whale detection's nearest GPS point. Duplicates are created where spp exist due to rbind.
# Will remove empty spp in next line WITHOUT removing multiple spp per GPS pt.
bind21 <- rbind(track21_new, trk_whl_21_new)

# Final output with UTC, lat/long, and Whale detections.
# It's important to keep duplicate timestamps because they may be associated with 1) multiple species
# or 2) same species, multiple vocalizations
GPSwhale21 <- bind21 %>% distinct()



##### Buoy 22 ######
#Create empty 'species' column
track22_new <- track_022 %>% 
  select(UTC, Latitude, Longitude) %>% 
  add_column(species = NA)

# Select UTC, lat/long species from df
trk_whl_22_new <- trk_whl22 %>% 
  select(UTC, Latitude, Longitude, species)

# Bind GPS tracks to whale detection's nearest GPS point. Duplicates are created where spp exist due to rbind.
# Will remove empty spp in next line WITHOUT removing multiple spp per GPS pt.
bind22 <- rbind(track22_new, trk_whl_22_new)

# Final output with UTC, lat/long, and Whale detections.
# It's important to keep duplicate timestamps because they may be associated with 1) multiple species
# or 2) same species, multiple vocalizations
GPSwhale22 <- bind22 %>% distinct()




##### Buoy 23 ######
#Create empty 'species' column
track23_new <- track_023 %>% 
  select(UTC, Latitude, Longitude) %>% 
  add_column(species = NA)

# Select UTC, lat/long species from df
trk_whl_23_new <- trk_whl23 %>% 
  select(UTC, Latitude, Longitude, species)

# Bind GPS tracks to whale detection's nearest GPS point. Duplicates are created where spp exist due to rbind.
# Will remove empty spp in next line WITHOUT removing multiple spp per GPS pt.
bind23 <- rbind(track23_new, trk_whl_23_new)

# Final output with UTC, lat/long, and Whale detections.
# It's important to keep duplicate timestamps because they may be associated with 1) multiple species
# or 2) same species, multiple vocalizations
GPSwhale23 <- bind23 %>% distinct()


# Save files to external drive
saveRDS(GPSwhale7, file = "D:Buoy_dfs/GPSwhale7.rda")
saveRDS(GPSwhale8, file = "D:Buoy_dfs/GPSwhale8.rda")
saveRDS(GPSwhale10, file = "D:Buoy_dfs/GPSwhale10.rda")
saveRDS(GPSwhale12, file = "D:Buoy_dfs/GPSwhale12.rda")
saveRDS(GPSwhale13, file = "D:Buoy_dfs/GPSwhale13.rda")
saveRDS(GPSwhale14, file = "D:Buoy_dfs/GPSwhale14.rda")
saveRDS(GPSwhale16, file = "D:Buoy_dfs/GPSwhale16.rda")
saveRDS(GPSwhale18, file = "D:Buoy_dfs/GPSwhale18.rda")
saveRDS(GPSwhale19, file = "D:Buoy_dfs/GPSwhale19.rda")
saveRDS(GPSwhale20, file = "D:Buoy_dfs/GPSwhale20.rda")
saveRDS(GPSwhale21, file = "D:Buoy_dfs/GPSwhale21.rda")
saveRDS(GPSwhale22, file = "D:Buoy_dfs/GPSwhale22.rda")
saveRDS(GPSwhale23, file = "D:Buoy_dfs/GPSwhale23.rda")

