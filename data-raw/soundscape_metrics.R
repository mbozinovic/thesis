## code to prepare `soundscape` dataset goes here

library(tidyverse)
library(lubridate)
library(here)

# Path to folder in Project/on GitHub
#sslist <- list.files(path = paste0("data-raw/"), pattern = "CCES_", recursive = TRUE)
#### Might not need this - it links to a few raw data files in GitHub ###############

# Read through a few soundscape files on GitHub, change date format
#for (i in sslist) {
#  data <- read_csv(here(paste0("data-raw/", i)), show_col_types = FALSE) %>%
#    rename(dateTime = `yyyy-mm-ddTHH:MM:SSZ`) %>%
#    mutate(dateTime = round_date(ymd_hms(dateTime), "20 minutes")) %>%
#    mutate(variable = paste0(substr(i, 16, 17), substr(i, 6, 7)))
  
#  assign(paste0(substr(i, 16, 17), "_", substr(i, 6, 7)), data)
#}

# Path to folder on my external hard drive
dirlist <- dir("D:/Soundscape_metrics", recursive=TRUE, full.names=TRUE, pattern="CCES_")

# Read though files from external hard drive, change date format
for (i in dirlist) {
  data <- read_csv(i, show_col_types = FALSE) %>%
    rename(dateTime = `yyyy-mm-ddTHH:MM:SSZ`) %>%
    mutate(dateTime = round_date(ymd_hms(dateTime), "20 minutes")) %>%
    mutate(variable = paste0(substr(i, 38, 39), substr(i,28, 29)))
  
  saveRDS(data, file = paste0("data/", substr(i, 38, 39), "_", substr(i, 28, 29), ".rda"))

}
# Creates BB_07, TO_07, BB_08, TO_08, etc. RDA files for each buoy


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

