## code to prepare soundscape dataset goes here

##########################
#NEED TO MAKE THIS A FUNCTION
# look at http://ohi-science.org/data-science-training/programming.html#automation-with-for-loops for help on automation.
##########################

library(tidyverse)
library(lubridate)


#dlist <- c(4,7,8,10,12,13,14,16,17,18,19,20,21,22,23)
sslist <- list.files(path = paste0("data/"), pattern = "CCES_", recursive = TRUE)

#code doesnt work, can delete
#for (i in sslist) {
#  read_csv(paste0("data/",i), show_col_types = FALSE)%>%
#  rename(dateTime = `yyyy-mm-ddTHH:MM:SSZ`) %>%
#  mutate(dateTime = round_date(ymd_hms(.$dateTime),"20 minutes")) %>%
#  assign(., value = paste0((substr(sslist[i], 16, 17)), substr(sslist[i], 6, 7)))
#}

#From ChatGPT, edited from above
for (i in sslist) {
  data <- read_csv(here(paste0("data/", i)), show_col_types = FALSE) %>%
    rename(dateTime = `yyyy-mm-ddTHH:MM:SSZ`) %>%
    mutate(dateTime = round_date(ymd_hms(dateTime), "20 minutes")) %>%
    mutate(variable = paste0(substr(i, 16, 17), substr(i, 6, 7)))
  
  assign(paste0(substr(i, 16, 17), "_", substr(i, 6, 7)), data)
}

# Need to save as .rda