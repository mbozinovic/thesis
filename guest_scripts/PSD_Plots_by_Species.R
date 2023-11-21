
library(PAMscapes)

#Load in median power spectral density (PSD) files
psd13 <- checkSoundscapeInput('H:/Soundscape/metrics/CCES_013/CCES_013_PSD_2min.csv')
psd14 <- checkSoundscapeInput('H:/Soundscape/metrics/CCES_014/CCES_014_PSD_2min.csv')

#To-Do
#Marina - you'll need to define when Zc is present/absent on each drift 
#Create separate PSD objects for the times when bw were present and absent 
ZcTimes13<- #times when Cuvier's beaked whales were present on drift 13
ZcTimes14<- #times when Cuvier's beaked whales were present on drift 14
  
psd13ZcPres<-filter(psd13,UTC %in% ZcTimes13) #Zc Present
psd13ZcAbs<-filter(psd13,!UTC %in% ZcTimes13) #Zc Absent

psd14ZcPres<-filter(psd14,UTC %in% ZcTimes14) #Zc Present
psd14ZcAbs<-filter(psd14,!UTC %in% ZcTimes14) #Zc Absent

#Combine PSD files from multiple drifts with rbind
psdZcPres<-rbind(psd13ZcPres,psd14ZcPres)
psdZcAbs<-rbind(psd13ZcAbs,psd14ZcAbs)


# Plotting 100-10,000 Hz (these are ggplot objects)
#Individual Drifts
plotPSD(psd13ZcPres[1:10000], style='density')
plotPSD(psd13ZcAbs[1:10000], style='density')

plotPSD(psd13ZcPres[1:10000], style='quantile', q=.05)
plotPSD(psd13ZcAbs[1:10000], style='quantile', q=.05)

#Combined Drifts 
plotPSD(psdZcPres[1:10000], style='density')
plotPSD(psdZcAbs[1:10000], style='density')

plotPSD(psdZcPres[1:10000], style='quantile', q=.05)
plotPSD(psdZcAbs[1:10000], style='quantile', q=.05)

