# Firstly wwe load the library
library(caret)
library(rattle)
# load the data sets
train<-read.csv(file="datos/pml-training.csv")
test<-read.csv(file="datos/pml-testing.csv")
# we preproces the train data set and get the tidy data set.
str(trainReducido)
# exploratory data analysis
summary(trainReducido)
# we find the model
inTrain<-createDataPartition(y=trainReducido$classe,p=0.7,list=F)
training<-trainReducido[inTrain,]
testing<-trainReducido[-inTrain,]
tunModFit
# we compute de accuracy in test set.
predccClases<-predict(tunModFit, newdata = testing)
confusionMatrix(data = predccClases, testing$classe)
# we cmpute the prediccion to new instance.
variables<-names(trainReducido[,-53])
testReducido<-test[,variables]
newClases<-predict(tunModFit, newdata = testReducido)

answers = rep("A", 20)
pml_write_files(newClases)
