#Use a Random Forest to identify most important variables
#in beaked and sperm whale presence
#Modified from Anne Simonis (7/11/2023)

#Required Packages
library(randomForest)
library(dplyr)
library(rfPermute)

# Load in main dataframe
load(file = "allDrifts.rda")

#Define response variable (presence/absence as 0/1)
#I suggest creating a variable for presence of each species, and then create a
#random forest model for each species 

#Descriptive label for analysis
Dep<-'CCES_Zc'

# For ZC only
allDrifts$species<-as.factor(allDrifts$species) %>%
  droplevels(c("BB", "BW43", "BW37V", "PM", "BWC"))

allDrifts$ZcPresence<-factor(ifelse(allDrifts$species=='ZC',1,0))

#List all variables you want to evaluate (I only included a few here, 
#but I know you have more environmental and AIS parameters to add)
#covariate.list<-list(c('ZcPresence','TOL_125','TOL_2000','TOL_5000',
 #                      'sst_mean','dist2slope','depth',
  #                     'chlorophyll_mean','mldDepth'))
#more parameters
covariate.list<-list(c('ZcPresence','BB_20.24000','TOL_63','TOL_125','TOL_2000','TOL_5000',
                       'TOL_20000', 'curl_mean', 'bathy_slope', 'ssh_mean',  
                       'sst_mean','dist2slope','depth',
                       'chlorophyll_mean','mldDepth', 'mldTemp', 'ttDepth',
                       'ttTemp', 'temp400', 'sal400'))

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

# create balanced sample size random forest model
#By ZC
RF.model.ZC <- rfPermute(ZcPresence ~ ., data=DF.modelZC[,include.covars],
                            replace=FALSE, ntree=15000, sampsize=sampsizeZC, proximity=FALSE)
RF.model.ZC
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Use random forest, not rfPermute
# This code associated with PDF from 8/15/23 at 2:53 am
RanFor.model.ZC <- randomForest(ZcPresence ~ ., data=DF.modelZC[,include.covars],
                         replace=FALSE, ntree=70000, sampsize=sampsizeZC, 
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
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#Evaluate RF models
#Create a PDF of summary plots
pdf(paste(Dep,"_",string.covars.used,".pdf"), width=14, height=10)
round(importance(RF.model.ZC),3) #ranking of importance for each variable
plotImportance(RF.model.ZC) #visualize importance
plotTrace(RF.model.ZC)   #model stability w/number of trees (this should be flat!)
plotImpPreds(RF.model.ZC, DF.modelZC, "ZcPresence")  #distribution of predictors 
plotPredictedProbs(RF.model.ZC)
#plotProximity(RF.model.ZC) ## Not working??
dev.off()

#Confusion matrix
confusionMatrix(RF.model.ZC)

#Save a Rdata file with the dataframe & RF model
save.image(paste(Dep,"_", string.covars.used, ".RData", sep=""))



## Could this be difficult due to a "zero-rich dataset" @barlow2019??
