#Testing for Multicollinearity

library(tidyverse)
library(car)


load(file = "D:Buoy_dfs/drift_escarpment.rda")

############################################################################

# All covariates except mldTemp
# Won't run due to aliased coefficients unless I remove mldTemp or ttTemp
GLM.VIF1 <- glm(Wpresence>0 ~ dist2slope + mldDepth + curl_mean + sst_mean +
                  depth + bathy_slope + chlorophyll_mean + dist2shore +
                  ssh_mean + ttTemp + ttDepth + dist2escarp + sal400 + temp400,
                data = drift_escarp)

vif(GLM.VIF1)

vif_values1 <- tibble(vif(GLM.VIF1)) %>%
  cbind(var = c("dist2slope", "mldDepth", "curl_mean", "sst_mean", "depth", 
                "bathy_slope", "chlorophyll_mean", "dist2shore", "ttTemp", 
                "ssh_mean", "sal400", "temp400",
                "ttDepth", "dist2escarp")) %>%
  rename(val = "vif(GLM.VIF1)")

ggplot(vif_values1, aes(y = var, x = val)) + 
  geom_col() + 
  geom_vline(xintercept = 5, col = "red") +
  labs(title = "VIF Values, ALL Env. Variables")


###############################################################################
# Remove highest of collinear pairs.
# Colinear pairs with removed covariate in UPPERCASE: 
# dist2slope/DIST2SHORE, ttTemp/SST_MEAN, temp400/SAL400, TTDEPTH/mldDepth, ttTemp/TEMP400

GLM.VIF2 <- glm(Wpresence>0 ~ dist2slope + mldDepth + curl_mean +
                  depth + bathy_slope + chlorophyll_mean +
                  ssh_mean + ttTemp + dist2escarp,
                data = drift_escarp)

vif(GLM.VIF2)

vif_values2 <- tibble(vif(GLM.VIF2)) %>%
  cbind(var = c("dist2slope", "mldDepth", "curl_mean", "depth", 
                "bathy_slope", "chlorophyll_mean", "ssh_mean", 
                "ttTemp", "dist2escarp")) %>%
  rename(val = "vif(GLM.VIF2)")

ggplot(vif_values2, aes(y = var, x = val)) + 
  geom_col() + 
  geom_vline(xintercept = 5, col = "red") +
  labs(title = "VIF Values by Env. Variable, no multicollinearity")



##############################################################################
# Which pairs are collinear? Try out here.
GLM.VIF3 <- glm(Wpresence>0 ~ temp400 + ttTemp,
                data = drift_escarp)

vif(GLM.VIF3)

vif_values3 <- tibble(vif(GLM.VIF3)) %>%
  cbind(var = c("temp400", "ttTemp")) %>%
  rename(val = "vif(GLM.VIF3)")

ggplot(vif_values3, aes(y = var, x = val)) + 
  geom_col() + 
  geom_vline(xintercept = 5, col = "red") +
  labs(title = "Test out VIF Values by Pairs")

###############################################################################



