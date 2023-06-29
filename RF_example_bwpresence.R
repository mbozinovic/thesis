#Use a Random Forest to identify most important variables
#in beaked and sperm whale presence
#Anne Simonis 6/23/2023

#Required Packages
library(randomForest)
library(dplyr)
library(rfPermute)

#Define response variable (presence/absence as 0/1)
#I suggest creating a variable for presence of each species, and then create a
#random forest model for each species 
allDrifts$Bwpresence<-as.factor(allDrifts$BWpresence)

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
DF.model <- na.omit(allDrifts)
DF.modelZC <- na.omit(allDrifts)

# create balanced sample sizes of response for tree construction to 
# avoid biases associated with imbalanced data
sampsize <- balancedSampsize(DF.model$Bwpresence)

# For ZC only
sampsizeZC <- balancedSampsize(DF.modelZC$BWpresence)

# set seed for reproducibility
set.seed(123)

# create balanced sample size random forest model
RF.model <- rfPermute(DF.model$Bwpresence ~ ., DF.model[,include.covars], ntree=1000)
RF.model

#By ZC, doesn't work
RF.model.ZC <- rfPermute(DF.modelZC$BWpresence ~ ., DF.modelZC[,include.covars], ntree=1000)
RF.model.ZC

#Evaluate RF models
#Create a PDF of summary plots
pdf(paste(Dep,"_",string.covars.used,".pdf"), width=14, height=10)
round(importance(RF.model),3) #ranking of importance for each variable
plotImportance(RF.model.ZC) #visualize importance
plotTrace(RF.model.ZC)   #model stability w/number of trees (this should be flat!)
plotImpPreds(RF.model, DF.model, "Bwpresence")  #distribution of predictors 
plotPredictedProbs(RF.model)
plotProximity(RF.model) 
dev.off()

#Confusion matrix
confusionMatrix(RF.model)

#Save a Rdata file with the dataframe & RF model
save.image(paste(Dep,"_", string.covars.used, ".RData", sep=""))




