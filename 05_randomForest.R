#Use a Random Forest to identify most important variables
#in beaked and sperm whale presence
#Modified from Anne Simonis (7/11/2023)

#Required Packages
library(randomForest)
library(dplyr)
library(rfPermute)

# Load in main dataframe
load(file = "data/allDrifts.rda")

# Create new row with random samples, make sure to add to covariates list
allDrifts$randSamp <- sample(10000, size = nrow(allDrifts), replace = TRUE)

# Load in main dataframe with seafloor gradient(?)
#load(file = "data/allDrifts_grad.rda")


#Define response variable (presence/absence as 0/1)
#Create a variable for presence of each species, and then create a
#random forest model for each species 

#####################################################################
## Cuvier's BW ####
#####################################################################

#Descriptive label for analysis
Dep<-'CCES_Zc'

# For ZC only
allDrifts$species<-as.factor(allDrifts$species) %>%
  droplevels(c("BB", "BW43", "PM"))

allDrifts$ZcPresence<-factor(ifelse(allDrifts$species=='ZC',1,0))

#List all variables for evaluation
covariate.list<-list(c('ZcPresence','curl_mean', 'bathy_slope',
                       'sst_mean','dist2slope','depth','dist2slope','chlorophyll_mean',
                       'chlorophyll_mean','mldDepth','ssh_mean',
                       'mldDepth', 'mldTemp', 'ttDepth','ttTemp', 'temp400', 'sal400',
                       'randSamp'))

include.covars <- which(names(allDrifts) %in% covariate.list[[1]])

#make a text string of all covariates considered for a file name 
string.covars.used <- paste0(names(allDrifts)[include.covars], sep="+", collapse="")

#Create a dataframe for the RF model
DF.modelZC <- na.omit(allDrifts)

# create balanced sample sizes of response for tree construction to 
# avoid biases associated with imbalanced data
# For ZC only
sampsizeZC <- balancedSampsize(DF.modelZC$ZcPresence)

# set seed for reproducibility
set.seed(123)

# Use random forest
RanFor.model.ZC <- randomForest(ZcPresence ~ ., data=DF.modelZC[,include.covars],
                         replace=FALSE, ntree=4400, sampsize=sampsizeZC, 
                         proximity=FALSE, importance = TRUE)
RanFor.model.ZC

pdf(paste(Dep,"_",string.covars.used,".pdf"), width=14, height=10)
round(importance(RanFor.model.ZC),3) #ranking of importance for each variable
plotImportance(RanFor.model.ZC) #visualize importance
plotTrace(RanFor.model.ZC)   #model stability w/number of trees (this should be flat!)
plotImpPreds(RanFor.model.ZC, DF.modelZC, "ZcPresence")  #distribution of predictors 
plotPredictedProbs(RanFor.model.ZC)
dev.off()
save.image(paste(Dep,"_", string.covars.used, ".RData", sep=""))

# Top 5 variables are:
# depth, timeaftership, sst_mean, curl_mean, TOL_2000

# Top 5 variables with only environmental variables
# depth, sst_mean, curl_mean, mldTemp, bathy_slope


#####################################################################
## Sperm Whale ####
#####################################################################

# Reload without ZC filter
load(file = "data/allDrifts.rda")

#Descriptive label for analysis
Dep<-'CCES_Pm'

# For PM only
allDrifts$species<-as.factor(allDrifts$species) %>%
  droplevels(c("BB", "BW43", "ZC"))

allDrifts$PmPresence<-factor(ifelse(allDrifts$species=='PM',1,0))

#List all variables for evaluation
covariate.list<-list(c('PmPresence','curl_mean', 'bathy_slope',
                       'sst_mean','dist2slope','depth','dist2slope','chlorophyll_mean',
                       'chlorophyll_mean','mldDepth','ssh_mean',
                       'mldDepth', 'mldTemp', 'ttDepth','ttTemp', 'temp400', 'sal400',
                       'randSamp'))

include.covars <- which(names(allDrifts) %in% covariate.list[[1]])

#make a text string of all covariates considered for a file name 
string.covars.used <- paste0(names(allDrifts)[include.covars], sep="+", collapse="")

#Create a dataframe for the RF model
DF.modelPM <- na.omit(allDrifts)

# create balanced sample sizes of response for tree construction to 
# avoid biases associated with imbalanced data
# For PM only
sampsizePM <- balancedSampsize(DF.modelPM$PmPresence)

# set seed for reproducibility
set.seed(123)

# Use random forest, not rfPermute
RanFor.model.PM <- randomForest(PmPresence ~ ., data=DF.modelPM[,include.covars],
                                replace=FALSE, ntree=3000, sampsize=sampsizePM, 
                                proximity=FALSE, importance = TRUE)
RanFor.model.PM

pdf(paste(Dep,"_",string.covars.used,".pdf"), width=14, height=10)
round(importance(RanFor.model.PM),3) #ranking of importance for each variable
plotImportance(RanFor.model.PM) #visualize importance
plotTrace(RanFor.model.PM)   #model stability w/number of trees (this should be flat!)
plotImpPreds(RanFor.model.PM, DF.modelPM, "PmPresence")  #distribution of predictors 
plotPredictedProbs(RanFor.model.PM)
dev.off()
save.image(paste(Dep,"_", string.covars.used, ".RData", sep=""))

# Top 5 variables are:
# TOL_2000, dist2slope, timeaftership, ttDepth, depth

# Top 5 environmental variables only:
# dist2slope, ttDepth, mldDepth, ssh_mean, depth



###############################################################
##### Using rfPermute rather than Random Forest ##############
##############################################################

## Cuvier's BW

# Estimate Permutation p-values for Random Forest Importance Metrics
# takes over 1 hr to run.
RF.model.ZC <- rfPermute(ZcPresence ~ ., data=DF.modelZC[,include.covars],
                                replace=FALSE, ntree=7000, sampsize=sampsizeZC, 
                                proximity=FALSE, importance = TRUE)
RF.model.ZC

pdf(paste(Dep,"_",string.covars.used,".pdf"), width=14, height=10)
round(importance(RF.model.ZC),3) #ranking of importance for each variable
plotImportance(RF.model.ZC) #visualize importance
plotTrace(RF.model.ZC)   #model stability w/number of trees (this should be flat!)
plotImpPreds(RF.model.ZC, DF.modelZC, "ZcPresence")  #distribution of predictors 
plotPredictedProbs(RF.model.ZC)
dev.off()
save.image(paste(Dep,"_", string.covars.used, ".RData", sep=""))

# Top 5 variables are:
# 

# Top 5 variables with only environmental variables
# depth, sst_mean, curl+mean, mldTemp, ssh_mean

###################################################################

## Sperm whale

# Use rfPermute
RF.model.PM <- rfPermute(PmPresence ~ ., data=DF.modelPM[,include.covars],
                                replace=FALSE, ntree=1000, sampsize=sampsizePM, 
                                proximity=FALSE, importance = TRUE)
RF.model.PM

pdf(paste(Dep,"_",string.covars.used,".pdf"), width=14, height=10)
round(importance(RF.model.PM),3) #ranking of importance for each variable
plotImportance(RF.model.PM) #visualize importance
plotTrace(RF.model.PM)   #model stability w/number of trees (this should be flat!)
plotImpPreds(RF.model.PM, DF.modelPM, "PmPresence")  #distribution of predictors 
plotPredictedProbs(RF.model.PM)
dev.off()
save.image(paste(Dep,"_", string.covars.used, ".RData", sep=""))

# Top 5 variables are:
# 

# Top 5 environmental variables only:
# 