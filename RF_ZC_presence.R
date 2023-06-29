#Use a Random Forest to identify most important variables
#in beaked and sperm whale presence
#Modified from Anne Simonis (6/23/2023)

#Required Packages
library(randomForest)
library(dplyr)
library(rfPermute)

#Define response variable (presence/absence as 0/1)
#I suggest creating a variable for presence of each species, and then create a
#random forest model for each species 

# For ZC only
allDrifts$BWpresence<-as.factor(allDrifts$BWpresence) %>%
  droplevels(c("BB", "BW43", "BW37V", "PM", "BWC"))


#List all variables you want to evaluate (I only included a few here, 
#but I know you have more environmental and AIS parameters to add)
covariate.list<-list(c('TOL_125','TOL_2000','TOL_5000',
                       'sst_mean','dist2slope','depth',
                       'chlorophyll_mean','mldDepth'))

include.covars <- which(names(allDrifts) %in% covariate.list[[1]])

#make a text string of all covariates considered for a file name 
string.covars.used <- paste0(names(allDrifts)[include.covars], sep="+", collapse="")

#Create a dataframe for the RF model
DF.modelZC <- na.omit(allDrifts)

# create balanced sample sizes of response for tree construction to 
# avoid biases associated with imbalanced data
# For ZC only
sampsizeZC <- balancedSampsize(DF.modelZC$BWpresence)

# set seed for reproducibility
set.seed(123)

# create balanced sample size random forest model

#By ZC, doesn't work
RF.model.ZC <- rfPermute(DF.modelZC$BWpresence ~ ., DF.modelZC[,include.covars], ntree=1000)
RF.model.ZC

#Evaluate RF models
#Create a PDF of summary plots
pdf(paste(Dep,"_",string.covars.used,".pdf"), width=14, height=10) ## Not working?
round(importance(RF.model.ZC),3) #ranking of importance for each variable
plotImportance(RF.model.ZC) #visualize importance
plotTrace(RF.model.ZC)   #model stability w/number of trees (this should be flat!)
plotImpPreds(RF.model.ZC, DF.model, "Bwpresence")  #distribution of predictors 
plotPredictedProbs(RF.model.ZC)
plotProximity(RF.model.ZC) ## Not working?? 
dev.off()

#Confusion matrix
confusionMatrix(RF.model.ZC)

#Save a Rdata file with the dataframe & RF model
save.image(paste(Dep,"_", string.covars.used, ".RData", sep="")) ## Not working??




