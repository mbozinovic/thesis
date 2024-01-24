# Correlation Matrix

#install.packages("corrplot")
library(corrplot)
library(tidyverse)

load(file = "D:Buoy_dfs/drift_escarpment.rda")

bzz <- drift_escarp %>%
  select(6:21, 25) %>%
  na.omit()

res <- cor(bzz)

corrplot(res, type = "upper", order = "hclust", 
          tl.col = "black", tl.srt = 45)
