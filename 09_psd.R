# SCript from Anne Simonis 10-20-23
library(tidyverse)
library(PAMscapes)

#Load in median power spectral density (PSD) files
psd13 <- checkSoundscapeInput('D:/Soundscape_metrics/PSD/CCES_13_1Hz_1s_PSD_2min.csv')
psd14 <- checkSoundscapeInput('D:/Soundscape_metrics/PSD/CCES_14_1Hz_1s_PSD_2min.csv')
psd07 <- checkSoundscapeInput('D:/Soundscape_metrics/PSD/CCES_07_1Hz_1s_PSD_2min.csv')
psd08 <- checkSoundscapeInput('D:/Soundscape_metrics/PSD/CCES_08_1Hz_1s_PSD_2min.csv')
psd10 <- checkSoundscapeInput('D:/Soundscape_metrics/PSD/CCES_10_1Hz_1s_PSD_2min.csv')
psd12 <- checkSoundscapeInput('D:/Soundscape_metrics/PSD/CCES_12_1Hz_1s_PSD_2min.csv')
psd16 <- checkSoundscapeInput('D:/Soundscape_metrics/PSD/CCES_16_1Hz_1s_PSD_2min.csv')
psd18 <- checkSoundscapeInput('D:/Soundscape_metrics/PSD/CCES_18_1Hz_1s_PSD_2min.csv')
psd19 <- checkSoundscapeInput('D:/Soundscape_metrics/PSD/CCES_19_1Hz_1s_PSD_2min.csv')
psd20 <- checkSoundscapeInput('D:/Soundscape_metrics/PSD/CCES_20_1Hz_1s_PSD_2min.csv')
psd21 <- checkSoundscapeInput('D:/Soundscape_metrics/PSD/CCES_21_1Hz_1s_PSD_2min.csv')
psd22 <- checkSoundscapeInput('D:/Soundscape_metrics/PSD/CCES_22_1Hz_1s_PSD_2min.csv')
psd23 <- checkSoundscapeInput('D:/Soundscape_metrics/PSD/CCES_23_1Hz_1s_PSD_2min.csv')

# Load in whale/GPS detections
GPSwhale13 <- readRDS(file = "D:/Buoy_dfs/GPSwhale13.rda")
GPSwhale14 <- readRDS(file = "D:/Buoy_dfs/GPSwhale14.rda")
GPSwhale07 <- readRDS(file = "D:/Buoy_dfs/GPSwhale7.rda")
GPSwhale08 <- readRDS(file = "D:/Buoy_dfs/GPSwhale8.rda")
GPSwhale10 <- readRDS(file = "D:/Buoy_dfs/GPSwhale10.rda")
GPSwhale12 <- readRDS(file = "D:/Buoy_dfs/GPSwhale12.rda")
GPSwhale16 <- readRDS(file = "D:/Buoy_dfs/GPSwhale16.rda")
GPSwhale18 <- readRDS(file = "D:/Buoy_dfs/GPSwhale18.rda")
GPSwhale19 <- readRDS(file = "D:/Buoy_dfs/GPSwhale19.rda")
GPSwhale20 <- readRDS(file = "D:/Buoy_dfs/GPSwhale20.rda")
GPSwhale21 <- readRDS(file = "D:/Buoy_dfs/GPSwhale21.rda")
GPSwhale22 <- readRDS(file = "D:/Buoy_dfs/GPSwhale22.rda")
GPSwhale23 <- readRDS(file = "D:/Buoy_dfs/GPSwhale23.rda")

############################################################################

psd13_1hr <- mutate(psd13, UTC = floor_date(UTC, '1 hour')) %>%
  group_by(UTC) %>%
  summarize(across(PSD_20:PSD_24000, mean))

psd14_1hr <- mutate(psd14, UTC = floor_date(UTC, '1 hour')) %>%
  group_by(UTC) %>%
  summarize(across(PSD_20:PSD_24000, mean))

psd07_1hr <- mutate(psd07, UTC = floor_date(UTC, '1 hour')) %>%
  group_by(UTC) %>%
  summarize(across(PSD_20:PSD_24000, mean))

psd08_1hr <- mutate(psd08, UTC = floor_date(UTC, '1 hour')) %>%
  group_by(UTC) %>%
  summarize(across(PSD_20:PSD_24000, mean))

psd10_1hr <- mutate(psd10, UTC = floor_date(UTC, '1 hour')) %>%
  group_by(UTC) %>%
  summarize(across(PSD_20:PSD_24000, mean))

psd12_1hr <- mutate(psd12, UTC = floor_date(UTC, '1 hour')) %>%
  group_by(UTC) %>%
  summarize(across(PSD_20:PSD_24000, mean))

psd16_1hr <- mutate(psd16, UTC = floor_date(UTC, '1 hour')) %>%
  group_by(UTC) %>%
  summarize(across(PSD_20:PSD_24000, mean))

psd18_1hr <- mutate(psd18, UTC = floor_date(UTC, '1 hour')) %>%
  group_by(UTC) %>%
  summarize(across(PSD_20:PSD_24000, mean))

psd19_1hr <- mutate(psd19, UTC = floor_date(UTC, '1 hour')) %>%
  group_by(UTC) %>%
  summarize(across(PSD_20:PSD_24000, mean))

psd20_1hr <- mutate(psd20, UTC = floor_date(UTC, '1 hour')) %>%
  group_by(UTC) %>%
  summarize(across(PSD_20:PSD_24000, mean))

psd21_1hr <- mutate(psd21, UTC = floor_date(UTC, '1 hour')) %>%
  group_by(UTC) %>%
  summarize(across(PSD_20:PSD_24000, mean))

psd22_1hr <- mutate(psd22, UTC = floor_date(UTC, '1 hour')) %>%
  group_by(UTC) %>%
  summarize(across(PSD_20:PSD_24000, mean))

psd23_1hr <- mutate(psd23, UTC = floor_date(UTC, '1 hour')) %>%
  group_by(UTC) %>%
  summarize(across(PSD_20:PSD_24000, mean))

save(psd13_1hr, file = "D:/Soundscape_metrics/PSD/psd13_1hr.rda")
save(psd14_1hr, file = "D:/Soundscape_metrics/PSD/psd14_1hr.rda")
save(psd07_1hr, file = "D:/Soundscape_metrics/PSD/psd07_1hr.rda")
save(psd08_1hr, file = "D:/Soundscape_metrics/PSD/psd08_1hr.rda")
save(psd10_1hr, file = "D:/Soundscape_metrics/PSD/psd10_1hr.rda")
save(psd12_1hr, file = "D:/Soundscape_metrics/PSD/psd12_1hr.rda")
save(psd16_1hr, file = "D:/Soundscape_metrics/PSD/psd16_1hr.rda")
save(psd18_1hr, file = "D:/Soundscape_metrics/PSD/psd18_1hr.rda")
save(psd19_1hr, file = "D:/Soundscape_metrics/PSD/psd19_1hr.rda")
save(psd20_1hr, file = "D:/Soundscape_metrics/PSD/psd20_1hr.rda")
save(psd21_1hr, file = "D:/Soundscape_metrics/PSD/psd21_1hr.rda")
save(psd22_1hr, file = "D:/Soundscape_metrics/PSD/psd22_1hr.rda")
save(psd23_1hr, file = "D:/Soundscape_metrics/PSD/psd23_1hr.rda")



#Define when Zc is present/absent on each drift
#Create separatdesk chaire PSD objects for the times when bw were present and absent 
ZcTimes13 <- filter(GPSwhale13, species == "ZC") #times when Cuvier's beaked whales were present on drift 13
ZcTimes14 <- filter(GPSwhale14, species == "ZC") #times when Cuvier's beaked whales were present on drift 14
#ZcTimes07 <- filter(GPSwhale07, species == "ZC") #times when Cuvier's beaked whales were present on drift 07
ZcTimes08 <- filter(GPSwhale08, species == "ZC") #times when Cuvier's beaked whales were present on drift 08
ZcTimes10 <- filter(GPSwhale10, species == "ZC") #times when Cuvier's beaked whales were present on drift 10
ZcTimes12 <- filter(GPSwhale12, species == "ZC") #times when Cuvier's beaked whales were present on drift 12
ZcTimes16 <- filter(GPSwhale16, species == "ZC") #times when Cuvier's beaked whales were present on drift 16
ZcTimes18 <- filter(GPSwhale18, species == "ZC") #times when Cuvier's beaked whales were present on drift 18
ZcTimes19 <- filter(GPSwhale19, species == "ZC") #times when Cuvier's beaked whales were present on drift 19
ZcTimes20 <- filter(GPSwhale20, species == "ZC") #times when Cuvier's beaked whales were present on drift 20
ZcTimes21 <- filter(GPSwhale21, species == "ZC") #times when Cuvier's beaked whales were present on drift 21
ZcTimes22 <- filter(GPSwhale22, species == "ZC") #times when Cuvier's beaked whales were present on drift 22
ZcTimes23 <- filter(GPSwhale23, species == "ZC") #times when Cuvier's beaked whales were present on drift 23



#Extract rounded hour from Zc detections
ZcTimes13_1hr <- mutate(ZcTimes13, UTC = floor_date(UTC, '1 hour'))
ZcTimes14_1hr <- mutate(ZcTimes14, UTC = floor_date(UTC, '1 hour'))
ZcTimes08_1hr <- mutate(ZcTimes08, UTC = floor_date(UTC, '1 hour'))
ZcTimes10_1hr <- mutate(ZcTimes10, UTC = floor_date(UTC, '1 hour'))
ZcTimes12_1hr <- mutate(ZcTimes12, UTC = floor_date(UTC, '1 hour'))
ZcTimes16_1hr <- mutate(ZcTimes16, UTC = floor_date(UTC, '1 hour'))
ZcTimes18_1hr <- mutate(ZcTimes18, UTC = floor_date(UTC, '1 hour'))
ZcTimes19_1hr <- mutate(ZcTimes19, UTC = floor_date(UTC, '1 hour'))
ZcTimes20_1hr <- mutate(ZcTimes20, UTC = floor_date(UTC, '1 hour'))
ZcTimes21_1hr <- mutate(ZcTimes21, UTC = floor_date(UTC, '1 hour'))
ZcTimes22_1hr <- mutate(ZcTimes22, UTC = floor_date(UTC, '1 hour'))
ZcTimes23_1hr <- mutate(ZcTimes23, UTC = floor_date(UTC, '1 hour'))
  
save(ZcTimes13_1hr, file = "D:/Soundscape_metrics/PSD/ZcTimes13_1hr.rda")
save(ZcTimes14_1hr, file = "D:/Soundscape_metrics/PSD/ZcTimes14_1hr.rda")
#save(ZcTimes07_1hr, file = "D:/Soundscape_metrics/PSD/ZcTimes07_1hr.rda")
save(ZcTimes08_1hr, file = "D:/Soundscape_metrics/PSD/ZcTimes08_1hr.rda")
save(ZcTimes10_1hr, file = "D:/Soundscape_metrics/PSD/ZcTimes10_1hr.rda")
save(ZcTimes12_1hr, file = "D:/Soundscape_metrics/PSD/ZcTimes12_1hr.rda")
save(ZcTimes16_1hr, file = "D:/Soundscape_metrics/PSD/ZcTimes16_1hr.rda")
save(ZcTimes18_1hr, file = "D:/Soundscape_metrics/PSD/ZcTimes18_1hr.rda")
save(ZcTimes19_1hr, file = "D:/Soundscape_metrics/PSD/ZcTimes19_1hr.rda")
save(ZcTimes20_1hr, file = "D:/Soundscape_metrics/PSD/ZcTimes20_1hr.rda")
save(ZcTimes21_1hr, file = "D:/Soundscape_metrics/PSD/ZcTimes21_1hr.rda")
save(ZcTimes22_1hr, file = "D:/Soundscape_metrics/PSD/ZcTimes22_1hr.rda")
save(ZcTimes23_1hr, file = "D:/Soundscape_metrics/PSD/ZcTimes23_1hr.rda")
###############################################################################
## LOAD  ###################
###########################

load(file = "D:/Soundscape_metrics/PSD/ZcTimes13_1hr.rda")
load(file = "D:/Soundscape_metrics/PSD/ZcTimes14_1hr.rda")
load(file = "D:/Soundscape_metrics/PSD/ZcTimes08_1hr.rda")
load(file = "D:/Soundscape_metrics/PSD/ZcTimes10_1hr.rda")
load(file = "D:/Soundscape_metrics/PSD/ZcTimes12_1hr.rda")
load(file = "D:/Soundscape_metrics/PSD/ZcTimes16_1hr.rda")
load(file = "D:/Soundscape_metrics/PSD/ZcTimes18_1hr.rda")
load(file = "D:/Soundscape_metrics/PSD/ZcTimes19_1hr.rda")
load(file = "D:/Soundscape_metrics/PSD/ZcTimes20_1hr.rda")
load(file = "D:/Soundscape_metrics/PSD/ZcTimes21_1hr.rda")
load(file = "D:/Soundscape_metrics/PSD/ZcTimes22_1hr.rda")
load(file = "D:/Soundscape_metrics/PSD/ZcTimes23_1hr.rda")

load(file = "D:/Soundscape_metrics/PSD/psd13_1hr.rda")
load(file = "D:/Soundscape_metrics/PSD/psd14_1hr.rda")
load(file = "D:/Soundscape_metrics/PSD/psd07_1hr.rda")
load(file = "D:/Soundscape_metrics/PSD/psd08_1hr.rda")
load(file = "D:/Soundscape_metrics/PSD/psd10_1hr.rda")
load(file = "D:/Soundscape_metrics/PSD/psd12_1hr.rda")
load(file = "D:/Soundscape_metrics/PSD/psd16_1hr.rda")
load(file = "D:/Soundscape_metrics/PSD/psd18_1hr.rda")
load(file = "D:/Soundscape_metrics/PSD/psd19_1hr.rda")
load(file = "D:/Soundscape_metrics/PSD/psd20_1hr.rda")
load(file = "D:/Soundscape_metrics/PSD/psd21_1hr.rda")
load(file = "D:/Soundscape_metrics/PSD/psd22_1hr.rda")
load(file = "D:/Soundscape_metrics/PSD/psd23_1hr.rda")




#####################################################################
### PLOTTING #######################################################
#############################################


# Individual drifts - presence + absence
psd13ZcPres <- filter(psd13_1hr, UTC %in% ZcTimes13_1hr$UTC) #Zc Present
psd13ZcAbs<- filter(psd13_1hr,!UTC %in% ZcTimes13_1hr$UTC) #Zc Absent

psd14ZcPres<-filter(psd14_1hr,UTC %in% ZcTimes14_1hr$UTC) #Zc Present
psd14ZcAbs<-filter(psd14_1hr,!UTC %in% ZcTimes14_1hr$UTC) #Zc Absent

# skipping buoy 7

psd08ZcPres<-filter(psd08_1hr,UTC %in% ZcTimes08_1hr$UTC) #Zc Present
psd08ZcAbs<-filter(psd08_1hr,!UTC %in% ZcTimes08_1hr$UTC) #Zc Absent

psd10ZcPres<-filter(psd10_1hr,UTC %in% ZcTimes10_1hr$UTC) #Zc Present
psd10ZcAbs<-filter(psd10_1hr,!UTC %in% ZcTimes10_1hr$UTC) #Zc Absent

psd12ZcPres<-filter(psd12_1hr,UTC %in% ZcTimes12_1hr$UTC) #Zc Present
psd12ZcAbs<-filter(psd12_1hr,!UTC %in% ZcTimes12_1hr$UTC) #Zc Absent

psd16ZcPres<-filter(psd16_1hr,UTC %in% ZcTimes16_1hr$UTC) #Zc Present
psd16ZcAbs<-filter(psd16_1hr,!UTC %in% ZcTimes16_1hr$UTC) #Zc Absent

psd18ZcPres<-filter(psd18_1hr,UTC %in% ZcTimes18_1hr$UTC) #Zc Present
psd18ZcAbs<-filter(psd18_1hr,!UTC %in% ZcTimes18_1hr$UTC) #Zc Absent

psd19ZcPres<-filter(psd19_1hr,UTC %in% ZcTimes19_1hr$UTC) #Zc Present
psd19ZcAbs<-filter(psd19_1hr,!UTC %in% ZcTimes19_1hr$UTC) #Zc Absent

psd20ZcPres<-filter(psd20_1hr,UTC %in% ZcTimes20_1hr$UTC) #Zc Present
psd20ZcAbs<-filter(psd20_1hr,!UTC %in% ZcTimes20_1hr$UTC) #Zc Absent

psd21ZcPres<-filter(psd21_1hr,UTC %in% ZcTimes21_1hr$UTC) #Zc Present
psd21ZcAbs<-filter(psd21_1hr,!UTC %in% ZcTimes21_1hr$UTC) #Zc Absent

psd22ZcPres<-filter(psd22_1hr,UTC %in% ZcTimes22_1hr$UTC) #Zc Present
psd22ZcAbs<-filter(psd22_1hr,!UTC %in% ZcTimes22_1hr$UTC) #Zc Absent

psd23ZcPres<-filter(psd23_1hr,UTC %in% ZcTimes23_1hr$UTC) #Zc Present
psd23ZcAbs<-filter(psd23_1hr,!UTC %in% ZcTimes23_1hr$UTC) #Zc Absent

#Combine PSD files from multiple drifts with rbind
#psdZcPres<-rbind(psd13ZcPres,psd14ZcPres)
#psdZcAbs<-rbind(psd13ZcAbs,psd14ZcAbs)


# Plotting 100-10,000 Hz (these are ggplot objects)
#Individual Drifts
a1 <- plotPSD(psd13ZcPres[1:10000], style='quantile', q=.05, title = "Buoy 13 - Zc presence/absence", color = "navyblue")
a2 <- plotPSD(psd13ZcAbs[1:10000], style='quantile', q=.05, title = "Buoy 13 - Zc presence/absence", color = "red")
combined.a <- a1
combined.a$layers <- c(combined.a$layers, a2$layers)
combined.a # absent slightly louder in higher freq


b1 <- plotPSD(psd14ZcPres[1:10000], style='quantile', q=.05, title = "Buoy 14 - Zc presence/absence", color = "navyblue")
b2 <- plotPSD(psd14ZcAbs[1:10000], style='quantile', q=.05, color = "red")
combined.b <- b1
combined.b$layers <- c(combined.b$layers, b2$layers)
combined.b # absent slightly louder in higher freq.


c1 <- plotPSD(psd08ZcPres[1:10000], style='quantile', q=.05, title = "Buoy 08 - Zc presence/absence", color = "navyblue")
c2 <- plotPSD(psd08ZcAbs[1:10000], style='quantile', q=.05, title = "Buoy 08 - Zc presence/absence", color = "red")
combined.c <- c1
combined.c$layers <- c(combined.c$layers, c2$layers)
combined.c #absent slightly louder

# skipping buoy 7 because no ZC detections

d1 <- plotPSD(psd10ZcPres[1:10000], style='quantile', q=.05, title = "Buoy 10 - Zc presence/absence", color = "navyblue")
d2 <- plotPSD(psd10ZcAbs[1:10000], style='quantile', q=.05, title = "Buoy 10 - Zc presence/absence", color = "red")
combined.d <- d1
combined.d$layers <- c(combined.d$layers, d2$layers)
combined.d # absent slightly louder

e1 <- plotPSD(psd12ZcPres[1:10000], style='quantile', q=.05, title = "Buoy 12 - Zc presence/absence", color = "navyblue")
e2 <- plotPSD(psd12ZcAbs[1:10000], style='quantile', q=.05, title = "Buoy 12 - Zc presence/absence", color = "red")
combined.e <- e1
combined.e$layers <- c(combined.e$layers, e2$layers)
combined.e # absent slightly louder


# very sparse presence
f1 <- plotPSD(psd16ZcPres[1:10000], style='quantile', q=.05, title = "Buoy 16 - Zc presence/absence", color = "navyblue")
f2 <- plotPSD(psd16ZcAbs[1:10000], style='quantile', q=.05, title = "Buoy 16 - Zc presence/absence", color = "red")
combined.f <- f1
combined.f$layers <- c(combined.f$layers, f2$layers)
combined.f #absent slightly louder

g1 <- plotPSD(psd18ZcPres[1:10000], style='quantile', q=.05, title = "Buoy 18 - Zc presence/absence", color = "navyblue")
g2 <- plotPSD(psd18ZcAbs[1:10000], style='quantile', q=.05, title = "Buoy 18 - Zc presence/absence", color = "red")
combined.g <- g1
combined.g$layers <- c(combined.g$layers, g2$layers)
combined.g #absent slightly louder in higher freq.

h1 <- plotPSD(psd19ZcPres[1:10000], style='quantile', q=.05, title = "Buoy 19 - Zc presence/absence", color = "navyblue")
h2 <- plotPSD(psd19ZcAbs[1:10000], style='quantile', q=.05, title = "Buoy 19 - Zc presence/absence", color = "red")
combined.h <- h1
combined.h$layers <- c(combined.h$layers, h2$layers)
combined.h #present slightly louder?? though see upper/lower quantiles

i1 <- plotPSD(psd20ZcPres[1:10000], style='quantile', q=.05, title = "Buoy 20 - Zc presence/absence", color = "navyblue")
i2 <- plotPSD(psd20ZcAbs[1:10000], style='quantile', q=.05, title = "Buoy 20 - Zc presence/absence", color = "red")
combined.i <- i1
combined.i$layers <- c(combined.i$layers, i2$layers)
combined.i # absent slightly louder

# very sparse presence.
j1 <- plotPSD(psd21ZcPres[1:10000], style='quantile', q=.05, title = "Buoy 21 - Zc presence/absence", color = "navyblue")
j2 <- plotPSD(psd21ZcAbs[1:10000], style='quantile', q=.05, title = "Buoy 21 - Zc presence/absence", color = "red")
combined.j <- j1
combined.j$layers <- c(combined.j$layers, j2$layers)
combined.j # present louder

# very sparse presence
k1 <- plotPSD(psd22ZcPres[1:10000], style='quantile', q=.05, title = "Buoy 22 - Zc presence/absence", color = "navyblue")
k2 <- plotPSD(psd22ZcAbs[1:10000], style='quantile', q=.05, title = "Buoy 22 - Zc presence/absence", color = "red")
combined.k <- k1
combined.k$layers <- c(combined.k$layers, k2$layers)
combined.k # present slightly louder

# very sparse presence. present generally louder than absent
m1 <- plotPSD(psd23ZcPres[1:10000], style='quantile', q=.05, title = "Buoy 23 - Zc presence/absence", color = "navyblue")
m2 <- plotPSD(psd23ZcAbs[1:10000], style='quantile', q=.05, title = "Buoy 23 - Zc presence/absence", color = "red")
combined.m <- m1
combined.m$layers <- c(combined.m$layers, m2$layers)
combined.m # present louder, but see upper/lower quantiles




#Combined Drifts - Density
plotPSD(psdZcPres[1:10000], style='density', title = "Buoy 13 + 14 - Zc present")
plotPSD(psdZcAbs[1:10000], style='density', title = "Buoy 13 + 14 - Zc absent")


#Combined Drifts 13 and 14 - Quantile
t1 <- plotPSD(psdZcPres[1:10000], style='quantile', q=.05, title = "Buoy 13 + 14 - Zc presence/absence", color = "navyblue")
t2 <- plotPSD(psdZcAbs[1:10000], style='quantile', q=.05, color = "red")

# Create plot with presence/absence on same line
combined.t <- t1
combined.t$layers <- c(combined.t$layers, t2$layers)
combined.t

        