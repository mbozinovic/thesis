## code to assemble clean dataframe for each buoy.
## Prerequisites include whales.R, tracks.R
## Results in dataframe for each buoy containing whale detections and buoy GPS points.

#### libraries #######

library(tidyverse)
library(PAMpal)
library(here)

##### set up #####

# Set system time zone to UTC
Sys.setenv(TZ='UTC')
here()

# Read in whale detections
whale7 <- readRDS('data/whale7.rda')
whale8 <- readRDS('data/whale8.rda')
whale10 <- readRDS('data/whale10.rda')
whale12 <- readRDS('data/whale12.rda')
whale13 <- readRDS('data/whale13.rda')
whale14 <- readRDS('data/whale14.rda')
whale16 <- readRDS('data/whale16.rda')
whale18 <- readRDS('data/whale18.rda')
whale19 <- readRDS('data/whale19.rda')
whale20 <- readRDS('data/whale20.rda')
whale21 <- readRDS('data/whale21.rda')
whale22 <- readRDS('data/whale22.rda')
whale23 <- readRDS('data/whale23.rda')
whale20.alt <- readRDS('data/whale20_alt.rda')

# Read in GPS tracks
track_007 <- readRDS('data/track_007.rda')
track_008 <- readRDS('data/track_008.rda')
track_010 <- readRDS('data/track_010.rda')
track_012 <- readRDS('data/track_012.rda')
track_013 <- readRDS('data/track_013.rda')
track_014 <- readRDS('data/track_014.rda')
track_016 <- readRDS('data/track_016.rda')
track_018 <- readRDS('data/track_018.rda')
track_019 <- readRDS('data/track_019.rda')
track_020 <- readRDS('data/track_020.rda')
track_021 <- readRDS('data/track_021.rda')
track_022 <- readRDS('data/track_022.rda')
track_023 <- readRDS('data/track_023.rda')
track_020.alt <- readRDS('data/track_020_alt.rda')

# timeJoin whales and tracks by buoy. Threshold times differ by buoy
# Results in the same whale detection dataframe but WITH nearest GPS point
# A join to this point happens next.
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
trk_whl20 <- PAMpal::timeJoin(whale20, track_020, 
                             thresh = 7100, interpolate = FALSE)
# Alternative buoy20 for interpolation analysis
trk_whl20.alt <- PAMpal::timeJoin(whale20.alt, track_020.alt,
                                  thresh = 3600, interpolate = FALSE)

trk_whl21 <- PAMpal::timeJoin(whale21, track_021, 
                             thresh = 3600, interpolate = FALSE)
trk_whl22 <- PAMpal::timeJoin(whale22, track_022, 
                             thresh = 54400, interpolate = FALSE) #large threshold to accommodate one
                                                                  # oddly functioning GPS transmission.
                                                                  # Buoy GPS pt and detection have same 
                                                                  # coordinate.
trk_whl23 <- PAMpal::timeJoin(whale23, track_023, 
                             thresh = 3600, interpolate = FALSE)

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
GPSwhale7 <- bind7 %>% 
  mutate(Wpresence = if_else(is.na(species), 0, 1)) %>%
  distinct() %>%
  arrange(UTC)  # whale detections are stratified until this point -- arrange() puts them in chron. order

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
GPSwhale8 <- bind8 %>% 
  mutate(Wpresence = if_else(is.na(species), 0, 1)) %>%
  distinct() %>%
  arrange(UTC)  # whale detections are stratified until this point -- arrange() puts them in chron. order


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
GPSwhale10 <- bind10 %>%
  mutate(Wpresence = if_else(is.na(species), 0, 1)) %>%
  distinct() %>%
  arrange(UTC)  # whale detections are stratified until this point -- arrange() puts them in chron. order


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
GPSwhale12 <- bind12 %>% 
  mutate(Wpresence = if_else(is.na(species), 0, 1)) %>%
  distinct() %>%
  arrange(UTC)  # whale detections are stratified until this point -- arrange() puts them in chron. order


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
GPSwhale13 <- bind13 %>%
  mutate(Wpresence = if_else(is.na(species), 0, 1)) %>%
  distinct() %>%
  arrange(UTC)  # whale detections are stratified until this point -- arrange() puts them in chron. order


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
GPSwhale14 <- bind14 %>%
  mutate(Wpresence = if_else(is.na(species), 0, 1)) %>%
  distinct() %>%
  arrange(UTC)  # whale detections are stratified until this point -- arrange() puts them in chron. order


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
GPSwhale16 <- bind16 %>%
  mutate(Wpresence = if_else(is.na(species), 0, 1)) %>%
  distinct() %>%
  arrange(UTC)  # whale detections are stratified until this point -- arrange() puts them in chron. order


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
GPSwhale18 <- bind18 %>%
  mutate(Wpresence = if_else(is.na(species), 0, 1)) %>%
  distinct() %>%
  arrange(UTC)  # whale detections are stratified until this point -- arrange() puts them in chron. order


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
GPSwhale19 <- bind19 %>%
  mutate(Wpresence = if_else(is.na(species), 0, 1)) %>%
  distinct() %>%
  arrange(UTC)  # whale detections are stratified until this point -- arrange() puts them in chron. order


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
GPSwhale20 <- bind20 %>%
  mutate(Wpresence = if_else(is.na(species), 0, 1)) %>%
  distinct() %>%
  arrange(UTC)  # whale detections are stratified until this point -- arrange() puts them in chron. order


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
GPSwhale21 <- bind21 %>%
  mutate(Wpresence = if_else(is.na(species), 0, 1)) %>%
  distinct() %>%
  arrange(UTC)  # whale detections are stratified until this point -- arrange() puts them in chron. order


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
GPSwhale22 <- bind22 %>%
  mutate(Wpresence = if_else(is.na(species), 0, 1)) %>%
  distinct() %>%
  arrange(UTC)  # whale detections are stratified until this point -- arrange() puts them in chron. order


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
GPSwhale23 <- bind23 %>%
  mutate(Wpresence = if_else(is.na(species), 0, 1)) %>%
  distinct() %>%
  arrange(UTC)  # whale detections are stratified until this point -- arrange() puts them in chron. order


##### Buoy 20.alt ################
#Create empty 'species' column
track20_new.alt <- track_020.alt %>% 
  select(UTC, Latitude, Longitude) %>% 
  add_column(species = NA)

# Select UTC, lat/long species from df
trk_whl_20_new.alt <- trk_whl20.alt %>% 
  select(UTC, Latitude, Longitude, species)

# Bind GPS tracks to whale detection's nearest GPS point. Duplicates are created where spp exist due to rbind.
# Will remove empty spp in next line WITHOUT removing multiple spp per GPS pt.
bind20.alt <- rbind(track20_new.alt, trk_whl_20_new.alt)

# Final output with UTC, lat/long, and Whale detections.
# remove duplicates in this case because there are identical UTC,Lat,Long columns with interpolated pts.
GPSwhale20.alt <- bind20.alt %>%
  mutate(Wpresence = if_else(is.na(species), 0, 1)) %>%
  group_by(UTC) %>%
  slice(which.max(!is.na(species))) %>%
  arrange(UTC)  # whale detections are stratified until this point -- arrange() puts them in chron. order


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
saveRDS(GPSwhale20.alt, file = "D:Buoy_dfs/GPSwhale20_alt.rda")

