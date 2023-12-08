## Adding seafloor gradient variable to drift dataframes

# Required packages
library(tidyverse)
library(terra)
library(sf)
library(mgcv)
library(car)

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
load(file = "data/allDrifts_grad.rda")

## Correlate TOL 2000 levels with seafloor gradient
grad_lm <- lm(magnitude_gradient_mean ~ TOL_2000, allDrifts_grad)
grad_glm <- glm(magnitude_gradient_mean ~ TOL_2000, data = allDrifts_grad)
grad_gam <- gam(magnitude_gradient_mean ~ s(TOL_2000), data = allDrifts_grad)
plot(grad_gam, all.terms = TRUE)
summary(grad_gam)
summary(grad_glm)


ggplot(allDrifts_grad, aes(x = magnitude_gradient_mean, y = TOL_2000)) +
  geom_point() + geom_smooth() +
  labs(title = "Magnitude of Seafloor Gradient mean ~ TOL 2000 for all drifts")

# Show drift points where depth is shallower than 200 meters
ggplot(allDrifts_grad, aes(x = Longitude, y = Latitude)) +
  geom_point(aes(color = depth < 300))


### Distance to gradient ####

seafloor <- rast("D:/Environ_variables/SeafloorGradient.tif")

load("data/allDrifts.rda")
allDrifts_sf <- allDrifts %>%
  st_as_sf(coords = c("Longitude", "Latitude"), crs = 4326)


# Establish bounding box of study area
xmin <- st_bbox(allDrifts_sf)[1]
xmax <- st_bbox(allDrifts_sf)[3]
ymin <- st_bbox(allDrifts_sf)[2]
ymax <- st_bbox(allDrifts_sf)[4]

ext(seafloor) <- c(xmin, xmax, ymin, ymax)
plot(seafloor)

# where are there high magnitudes of gradients?
high_floor <- seafloor > 15
plot(high_floor)
high_floor_vect <- as.contour(high_floor)

trk <- terra::rasterize(vect(allDrifts_sf), seafloor) # rasterize drift track based on seafloor tif

dist <- terra::distance(seafloor, high_floor_vect) #distance from drifts

ext <- terra::extract(dist, vect(allDrifts_sf)) # extract the distance at each allDrifts points

 
# Bind to allDrifts to create new dataframe 
seafloor_grad_drift <- cbind(allDrifts_sf, ext) %>%
  dplyr::select(-ID) %>%
  st_set_geometry(NULL) # remove geometry to prevent buoy dataframe from becoming sf object for future 

save(seafloor_grad_drift, file = "D:/Environ_variables/seafloor_allDrift.rda")
  
# View track lines over seafloor gradient distance raster.
plot(dist)
lines(as.polygons(trk))
###############################################################################

# Correlate distance to seafloor feature to TOL2000 
load(file = "D:/Environ_variables/seafloor_allDrift.rda")



# linear model
grad_lm <- lm(SeafloorGradient ~ TOL_2000, seafloor_grad_drift)
summary(grad_lm)

ggplot(seafloor_grad_drift, aes(x = SeafloorGradient, y = TOL_2000)) +
  geom_point() + geom_smooth() +
  labs(title = "Distance to Seafloor Feature ~ TOL 2000 for all drifts")

# GLM
grad_glm <- glm(SeafloorGradient ~ TOL_2000, data = seafloor_grad_drift)
summary(grad_glm)


grad_gam <- gam(TOL_2000 ~ s(SeafloorGradient), data = seafloor_grad_drift)
summary(grad_gam)
plot(grad_gam, all.terms = TRUE, scale = 0)


##############################################################################
# Using Escarpment shapefile from Global Seafloor Geomorphic Features Map
#P.T. Harris, M. Macmillan-Lawler, J. Rupp, E.K. Baker, Geomorphology of the oceans,
#Marine Geology, Volume 352, 2014, Pages 4-24, ISSN 0025-3227,
#https://doi.org/10.1016/j.margeo.2014.01.011.
#(https://www.sciencedirect.com/science/article/pii/S0025322714000310)

# Load and Make allDrifts an sf object
load("data/allDrifts.rda")
allDrifts_sf <- allDrifts %>%
  st_as_sf(coords = c("Longitude", "Latitude"), crs = 4326) %>%
  st_make_valid()

xmin <- st_bbox(allDrifts_sf)[1]
xmax <- st_bbox(allDrifts_sf)[3]
ymin <- st_bbox(allDrifts_sf)[2]
ymax <- st_bbox(allDrifts_sf)[4]

# Add 0.5 border to the extent of drifts
bnd <- st_bbox(c(xmin - 1.0, xmax + 1.0, 
                 ymin - 1.0, ymax + 1.0))

escarpments <- st_read("D:/Environ_variables/Escarpments.shp") %>%
  st_make_valid() %>%
  st_crop(bnd) %>%
  st_set_crs(4326)

dist2escarp <- st_distance(allDrifts_sf, escarpments)
#g <- geosphere::dist2Line(vect(allDrifts), vect(escarpments))
n <- st_nearest_feature(allDrifts_sf, escarpments)

drift_escarp <- cbind(allDrifts_sf, g) %>%
  mutate(dist2escarp = as.numeric(g))

#Save
load(file = "D:Buoy_dfs/drift_escarpment.rda")
saveRDS(drift_escarp, file = "data/drift_escarp.rda")
