# Firstly wwe load the library
library(caret)
library(rattle)
source("functions.R")
# load the data sets
train<-read.csv(file="datos/pml-training.csv",na.strings=c("NA",""))
test<-read.csv(file="datos/pml-testing.csv",na.strings=c("NA",""))
# we preproces the train data set and get the tidy data set.
countNA<-resumen(train)
countNA
tidyTrain<-train[,countNA[countNA$na==0,]$variable]
tidyTrain<-tidyTrain[,-1:-6]
dim(tidyTrain)
# exploratory data analysis
# we find the model
inTrain<-createDataPartition(y=tidyTrain$classe,p=0.7,list=F)
training<-tidyTrain[inTrain,]
testing<-tidyTrain[-inTrain,]
fitControl <- trainControl(method = "cv",number = 3)
cps<-seq(0.00001, 0.0001, by= 0.00001)
cartGrid <-  expand.grid(cp = cps)
set.seed(10000)
modCart<-train(classe~.,method="rpart",
              data=training,
              trControl = fitControl
              ,tuneGrid = cartGrid
)
plot(modCart)
accCartTrain<-max(modCart$results$Accuracy)
predCart<-predict(modCart, newdata = testing)
cmCartTest<-confusionMatrix(data = predCart, testing$classe)
accCartTest<-cmCartTest$overall["Accuracy"]

resultCart<-data.frame(method="rpart",sample="train",accuracy=accCartTrain)
# J48
set.seed(10000)
j48Grid<- expand.grid(C = c(0.1,0.2,0.25,0.3))
modJ48<-train(classe~.,method="J48",
                 data=training,
                 trControl = fitControl,
                 tuneGrid = j48Grid
)
trellis.par.set(caretTheme())
plot(modJ48)
accJ48Train<-max(modJ48$results$Accuracy)
predJ48<-predict(modJ48, newdata = testing)
cmJ48Test<-confusionMatrix(data = predJ48, testing$classe)
accJ48Test<-cmJ48Test$overall["Accuracy"]

# Random Forest
library(doParallel)
registerDoParallel(2)
set.seed(10000)
modRF<-train(classe~.,data=training,method="rf",trControl=fitControl)
plot(modRF)
accRfTrain<-max(modRF$results$Accuracy)
predRf<-predict(modRF, newdata = testing)
cmRfTest<-confusionMatrix(data = predRf, testing$classe)
accRfTest<-cmRfTest$overall["Accuracy"]


result<-data.frame(method="rpart",sample="train",accuracy=accCartTrain)
result<-rbind(result,data.frame(method="rpart",sample="test",accuracy=accCartTest))
result<-rbind(result,data.frame(method="j48",sample="train",accuracy=accJ48Train))
result<-rbind(result,data.frame(method="j48",sample="test",accuracy=accJ48Test))
result<-rbind(result,data.frame(method="rf",sample="train",accuracy=accRfTrain))
result<-rbind(result,data.frame(method="rf",sample="test",accuracy=accRfTest))
rownames(result)<-NULL
ggplot(data=result,aes(x=method,y=accuracy,fill=sample))+
        geom_bar(stat="identity",position = "dodge")

# we cmpute the prediccion to new instance.
tidyTest<-test[,names(tidyTrain[,-54])]
answers<-predict(modRF, newdata = tidyTest)
answers
pml_write_files(newClases)

knit('predmachlearnProject.Rmd')
markdownToHTML('predmachlearnProject.md') 
