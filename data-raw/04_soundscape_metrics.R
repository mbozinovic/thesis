## code to prepare `soundscape` dataset goes here
## adding column for whale detections here
## percentiles are at the bottom

## Required Packages
library(tidyverse)
library(PAMpal)

# Set system time zone to UTC
Sys.setenv(TZ='UTC')

#### Read in GPSwhaleAISenv dataframes for each buoy from external drive.
#Create list of objects
# Be sure to clear global environment of objects like GPSwhaleAISenvSSx
buoylist <- dir("D:/Buoy_dfs", recursive=TRUE, full.names=TRUE, pattern="GPSwhaleAISenv")

# Read though RDA files from external hard drive and assign to object
## Won't work if GPS...SSx is already created in the D drive.
for (i in buoylist) {
  data <- readRDS(file = paste0("D:/Buoy_dfs/GPSwhaleAISenv", substr(i, 27,28), ".rda"))
  assign(x = paste0("GPSwhaleAISenv", substr(i,27,28)), value = data)
}

# To read in one buoy file
GPSwhaleAIS20.alt <- readRDS(file = "D:/Buoy_dfs/GPSwhaleAIS20_alt.rda")


### Read in soundscape metrics (TOL only)
# Path to folder on my external hard drive
dirlist <- dir("D:/Soundscape_metrics/TOL_metrics", recursive=TRUE, full.names=TRUE, pattern="CCES_")

# Read though files from external hard drive, change date format
for (i in dirlist) {
  data <- read_csv(i, show_col_types = FALSE) %>%
    mutate(UTC = as.POSIXct(`yyyy-mm-ddTHH:MM:SSZ`, tz = 'UTC')) %>%
    select(UTC, TOL_125, TOL_2000)
  
  assign(x = paste0("tol_", substr(i, 40, 41)), data)
}

#### To read in one soundscape file
#tol_20 <- read_csv("D:/Soundscape_metrics/TOL_metrics/CCES_20_1Hz_1s_TOL_2min.csv", show_col_types = FALSE) %>%
#  mutate(UTC = as.POSIXct(`yyyy-mm-ddTHH:MM:SSZ`, tz = 'UTC')) %>%
#  select(UTC, TOL_125, TOL_2000)




## timeJoin function with GPSwhaleAISenv and tol metrics
# Add column for Whale presence, where 0 = absent and 1 = present
GPSwhaleAISenvSS07 <- PAMpal::timeJoin(GPSwhaleAISenv07, tol_07, thresh = 3600, interpolate = FALSE) %>%
  select(-timeDiff)
GPSwhaleAISenvSS07 <- GPSwhaleAISenvSS07[!is.na(GPSwhaleAISenvSS07$TOL_125),]
## missing some estimated variables at 400m because buoy is too shallow at that point!


GPSwhaleAISenvSS08 <- PAMpal::timeJoin(GPSwhaleAISenv08, tol_08, thresh = 3600, interpolate = FALSE) %>%
  select(-timeDiff)
GPSwhaleAISenvSS08 <- GPSwhaleAISenvSS08[!is.na(GPSwhaleAISenvSS08$TOL_125),]

GPSwhaleAISenvSS10 <- PAMpal::timeJoin(GPSwhaleAISenv10, tol_10, thresh = 3600, interpolate = FALSE) %>%
  select(-timeDiff)
GPSwhaleAISenvSS10 <- GPSwhaleAISenvSS10[!is.na(GPSwhaleAISenvSS10$TOL_125),]

GPSwhaleAISenvSS12 <- PAMpal::timeJoin(GPSwhaleAISenv12, tol_12, thresh = 3600, interpolate = FALSE)%>%
  select(-timeDiff)
GPSwhaleAISenvSS12 <- GPSwhaleAISenvSS12[!is.na(GPSwhaleAISenvSS12$TOL_125),]
# missing some chlorophyll values

GPSwhaleAISenvSS13 <- PAMpal::timeJoin(GPSwhaleAISenv13, tol_13, thresh = 3600, interpolate = FALSE)%>%
  select(-timeDiff)
GPSwhaleAISenvSS13 <- GPSwhaleAISenvSS13[!is.na(GPSwhaleAISenvSS13$TOL_125),]

GPSwhaleAISenvSS14 <- PAMpal::timeJoin(GPSwhaleAISenv14, tol_14, thresh = 3600, interpolate = FALSE)%>%
  select(-timeDiff)
GPSwhaleAISenvSS14 <- GPSwhaleAISenvSS14[!is.na(GPSwhaleAISenvSS14$TOL_125),]

GPSwhaleAISenvSS16 <- PAMpal::timeJoin(GPSwhaleAISenv16, tol_16, thresh = 3600, interpolate = FALSE)%>%
  select(-timeDiff)
GPSwhaleAISenvSS16 <- GPSwhaleAISenvSS16[!is.na(GPSwhaleAISenvSS16$TOL_125),] # drops SS metrics because soundscape detections end earlier than GPS

GPSwhaleAISenvSS18 <- PAMpal::timeJoin(GPSwhaleAISenv18, tol_18, thresh = 3600, interpolate = FALSE)%>%
  select(-timeDiff)
GPSwhaleAISenvSS18 <- GPSwhaleAISenvSS18[!is.na(GPSwhaleAISenvSS18$TOL_125),] #drops SS metrics because soundscape detections end earlier than GPS

GPSwhaleAISenvSS19 <- PAMpal::timeJoin(GPSwhaleAISenv19, tol_19, thresh = 3600, interpolate = FALSE)%>%
  select(-timeDiff)
GPSwhaleAISenvSS19 <- GPSwhaleAISenvSS19[!is.na(GPSwhaleAISenvSS19$TOL_125),] #drops SS metrics because soundscape detections end earlier than GPS

GPSwhaleAISenvSS20 <- PAMpal::timeJoin(GPSwhaleAISenv20, tol_20, thresh = 3600, interpolate = FALSE)%>%
  select(-timeDiff)
GPSwhaleAISenvSS20 <- GPSwhaleAISenvSS20[!is.na(GPSwhaleAISenvSS20$TOL_125),]

GPSwhaleAISenvSS21 <- PAMpal::timeJoin(GPSwhaleAISenv21, tol_21, thresh = 3600, interpolate = FALSE)%>%
  select(-timeDiff)
GPSwhaleAISenvSS21 <- GPSwhaleAISenvSS21[!is.na(GPSwhaleAISenvSS21$TOL_125),]

GPSwhaleAISenvSS22 <- PAMpal::timeJoin(GPSwhaleAISenv22, tol_22, thresh = 3600, interpolate = FALSE)%>%
  select(-timeDiff)
GPSwhaleAISenvSS22 <- GPSwhaleAISenvSS22[!is.na(GPSwhaleAISenvSS22$TOL_125),]

GPSwhaleAISenvSS23 <- PAMpal::timeJoin(GPSwhaleAISenv23, tol_23, thresh = 3600, interpolate = FALSE)%>%
  select(-timeDiff)
GPSwhaleAISenvSS23 <- GPSwhaleAISenvSS23[!is.na(GPSwhaleAISenvSS23$TOL_125),]


GPSwhaleAISSS20.alt <- PAMpal::timeJoin(GPSwhaleAIS20.alt, tol_20, thresh = 3600, interpolate = FALSE)%>%
  select(-timeDiff)
GPSwhaleAISenvSS20.alt <- GPSwhaleAISSS20.alt[!is.na(GPSwhaleAISSS20.alt$TOL_125),]


# Creates final dataframe for each buoy that combines GPS tracks, whale detections, AIS detections, 
# environmental variables, and soundscape metrics


saveRDS(GPSwhaleAISenvSS10, 'D:/Buoy_dfs/GPSwhaleAISenvSS10.rda')
saveRDS(GPSwhaleAISenvSS12, 'D:/Buoy_dfs/GPSwhaleAISenvSS12.rda')
saveRDS(GPSwhaleAISenvSS13, 'D:/Buoy_dfs/GPSwhaleAISenvSS13.rda')
saveRDS(GPSwhaleAISenvSS14, 'D:/Buoy_dfs/GPSwhaleAISenvSS14.rda')
saveRDS(GPSwhaleAISenvSS16, 'D:/Buoy_dfs/GPSwhaleAISenvSS16.rda')
saveRDS(GPSwhaleAISenvSS18, 'D:/Buoy_dfs/GPSwhaleAISenvSS18.rda')
saveRDS(GPSwhaleAISenvSS19, 'D:/Buoy_dfs/GPSwhaleAISenvSS19.rda')
saveRDS(GPSwhaleAISenvSS20, 'D:/Buoy_dfs/GPSwhaleAISenvSS20.rda')
saveRDS(GPSwhaleAISenvSS21, 'D:/Buoy_dfs/GPSwhaleAISenvSS21.rda')
saveRDS(GPSwhaleAISenvSS22, 'D:/Buoy_dfs/GPSwhaleAISenvSS22.rda')
saveRDS(GPSwhaleAISenvSS23, 'D:/Buoy_dfs/GPSwhaleAISenvSS23.rda')
saveRDS(GPSwhaleAISenvSS07, 'D:/Buoy_dfs/GPSwhaleAISenvSS07.rda')
saveRDS(GPSwhaleAISenvSS08, 'D:/Buoy_dfs/GPSwhaleAISenvSS08.rda')
saveRDS(GPSwhaleAISSS20.alt, 'D:/Buoy_dfs/GPSwhaleAISSS20_alt.rda') # Remember this dataset has no env. variables.





####### Read in Percentiles ###############

# Path to folder on my external hard drive
pclist <- dir("D:/Soundscape_metrics/10_90_percentiles", 
               recursive=TRUE, full.names=TRUE, pattern="CCES_")


#Read through percentiles in external hard drive, change date format
for (i in pclist) {
  data <- read_csv(i, show_col_types = FALSE) %>%
    rename(dateTime = `yyyy-mm-ddTHH:MM:SSZ`) %>%
    mutate(UTC = as.POSIXct(dateTime))
  
  saveRDS(data, file = paste0("data/", substr(i, 60, 64), "_", substr(i, 46, 47), ".rda"))
}

