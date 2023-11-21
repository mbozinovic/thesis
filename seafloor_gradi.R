## Adding seafloor gradient variable to drift dataframes

# Required packages
library(tidyverse)
library(terra)

# Read in buoy dataframes
ftlist <- dir("D:/Buoy_dfs/", recursive=TRUE, full.names=TRUE, pattern="GPSwhaleAISenvSS")

for (ft in ftlist) {
  df <- readRDS(ft)
  assign(paste0("GPSwhaleAISenvSS", substr(ft, 29, 30)), df)
}


# Download and attach seafloor gradient magnitude to each buoy
grad07 <- matchEnvData(GPSwhaleAISenvSS07, nc = 'erdEtopoSeafloorGradient', 
             fileName = "D:/Environ_variables/seafloorgradi07", 
             var = c('magnitude_gradient')) %>%
  dplyr::select(-matchLong_mean, -matchLat_mean, -matchTime_mean) %>%
  mutate(Deployment = 07) # add drift number for when I bind

grad08 <- matchEnvData(GPSwhaleAISenvSS08, nc = 'erdEtopoSeafloorGradient', 
                       fileName = "D:/Environ_variables/seafloorgradi08", 
                       var = c('magnitude_gradient')) %>%
  dplyr::select(-matchLong_mean, -matchLat_mean, -matchTime_mean) %>%
  mutate(Deployment = 08)

grad10 <- matchEnvData(GPSwhaleAISenvSS10, nc = 'erdEtopoSeafloorGradient', 
                       fileName = "D:/Environ_variables/seafloorgradi10", 
                       var = c('magnitude_gradient')) %>%
  dplyr::select(-matchLong_mean, -matchLat_mean, -matchTime_mean) %>%
  mutate(Deployment = 10)

grad12 <- matchEnvData(GPSwhaleAISenvSS12, nc = 'erdEtopoSeafloorGradient', 
                       fileName = "D:/Environ_variables/seafloorgradi12", 
                       var = c('magnitude_gradient')) %>%
  dplyr::select(-matchLong_mean, -matchLat_mean, -matchTime_mean) %>%
  mutate(Deployment = 12)

grad13 <- matchEnvData(GPSwhaleAISenvSS13, nc = 'erdEtopoSeafloorGradient', 
                       fileName = "D:/Environ_variables/seafloorgradi13", 
                       var = c('magnitude_gradient')) %>%
  dplyr::select(-matchLong_mean, -matchLat_mean, -matchTime_mean) %>%
  mutate(Deployment = 13)

grad14 <- matchEnvData(GPSwhaleAISenvSS14, nc = 'erdEtopoSeafloorGradient', 
                     fileName = "D:/Environ_variables/seafloorgradi14", 
                     var = c('magnitude_gradient')) %>%
  dplyr::select(-matchLong_mean, -matchLat_mean, -matchTime_mean) %>%
  mutate(Deployment = 14)

grad16 <- matchEnvData(GPSwhaleAISenvSS16, nc = 'erdEtopoSeafloorGradient', 
                       fileName = "D:/Environ_variables/seafloorgradi16", 
                       var = c('magnitude_gradient')) %>%
  dplyr::select(-matchLong_mean, -matchLat_mean, -matchTime_mean) %>%
  mutate(Deployment = 16)

grad18 <- matchEnvData(GPSwhaleAISenvSS18, nc = 'erdEtopoSeafloorGradient', 
                       fileName = "D:/Environ_variables/seafloorgradi18", 
                       var = c('magnitude_gradient')) %>%
  dplyr::select(-matchLong_mean, -matchLat_mean, -matchTime_mean) %>%
  mutate(Deployment = 18)

grad19 <- matchEnvData(GPSwhaleAISenvSS19, nc = 'erdEtopoSeafloorGradient', 
                       fileName = "D:/Environ_variables/seafloorgradi19", 
                       var = c('magnitude_gradient')) %>%
  dplyr::select(-matchLong_mean, -matchLat_mean, -matchTime_mean) %>%
  mutate(Deployment = 19)

grad20 <- matchEnvData(GPSwhaleAISenvSS20, nc = 'erdEtopoSeafloorGradient', 
                       fileName = "D:/Environ_variables/seafloorgradi20", 
                       var = c('magnitude_gradient')) %>%
  dplyr::select(-matchLong_mean, -matchLat_mean, -matchTime_mean) %>%
  mutate(Deployment = 20)

grad21 <- matchEnvData(GPSwhaleAISenvSS21, nc = 'erdEtopoSeafloorGradient', 
                       fileName = "D:/Environ_variables/seafloorgradi21", 
                       var = c('magnitude_gradient')) %>%
  dplyr::select(-matchLong_mean, -matchLat_mean, -matchTime_mean) %>%
  mutate(Deployment = 21)

grad22 <- matchEnvData(GPSwhaleAISenvSS22, nc = 'erdEtopoSeafloorGradient', 
                       fileName = "D:/Environ_variables/seafloorgradi22", 
                       var = c('magnitude_gradient')) %>%
  dplyr::select(-matchLong_mean, -matchLat_mean, -matchTime_mean) %>%
  mutate(Deployment = 22)

grad23 <- matchEnvData(GPSwhaleAISenvSS23, nc = 'erdEtopoSeafloorGradient', 
                       fileName = "D:/Environ_variables/seafloorgradi23", 
                       var = c('magnitude_gradient')) %>%
  dplyr::select(-matchLong_mean, -matchLat_mean, -matchTime_mean) %>%
  mutate(Deployment = 23)

# NEW allDrifts with gradient
allDrifts_grad <- bind_rows(grad07,grad08, grad10, grad12, grad13, grad14,
                           grad16, grad18, grad19, grad20, grad21, grad22, grad23)

save(allDrifts_grad, file = "data/allDrifts_grad.rda")


## Correlate TOL 2000 levels with seafloor gradient
grad_lm <- lm(magnitude_gradient_mean ~ TOL_2000, allDrifts_grad)
grad_glm <- glm(magnitude_gradient_mean ~ TOL_2000, data = allDrifts_grad)

summary(grad_glm)


ggplot(allDrifts_grad, aes(x = magnitude_gradient_mean, y = TOL_2000)) +
  geom_point() + geom_smooth() +
  labs(title = "Magnitude of Seafloor Gradient mean ~ TOL 2000 for all drifts")

# Show drift points where depth is shallower than 200 meters
ggplot(allDrifts_grad, aes(x = Longitude, y = Latitude)) +
  geom_point(aes(color = depth < 300))


### Distance to gradient ####

seafloor <- rast("D:/Environ_variables/SeafloorGradient.tif")

## from 03 ##

agg <- terra::aggregate(bathy, 5)  # Increase cell size by factor of 5 to be visible

cont <- st_as_sf(as.contour(bathy, )) # Create contour lines from bathymetry 
cont_slope <- cont %>% filter(level == -2000) # Establish continental shelf. Is 2000m the correct depth for continental shelf?

#Make sure to clear Global Environment of other objects with "env"
tracklist <- grep(pattern = "env", names(.GlobalEnv), value = T)

for (t in tracklist) {
  sf <- st_as_sf(get(t), coords = c("Longitude", "Latitude"), crs=4326, remove=F)
  trk <- terra::rasterize(vect(sf), agg)
  slop <- terra::distance(trk, vect(cont_slope))
  ext <- terra::extract(slop, vect(sf))
  
  dbind <- cbind(sf, ext) %>%
    dplyr::select(-ID) %>%
    rename("dist2slope" = last) %>%
    st_set_geometry(NULL) # remove geometry to prevent buoy dataframe from becoming sf object for future 
  
  assign(paste0("env", substr(t, 4, 5)), dbind)
}
```
```{r} 
sf <- st_as_sf(get(t), coords = c("Longitude", "Latitude"), crs=4326, remove=F)
trk <- terra::rasterize(vect(sf), agg)
slop <- terra::distance(trk, vect(cont_slope))
ext <- terra::extract(slop, vect(sf))

dbind <- cbind(sf, ext) %>%
  dplyr::select(-ID) %>%
  rename("dist2slope" = last) %>%
  st_set_geometry(NULL) # remove geometry to prevent buoy dataframe from becoming sf object for future 
```

