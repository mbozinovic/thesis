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

# Save object
saveRDS(whales, 'data/whales.rda')



