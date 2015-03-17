getwd()
setwd("D:/predmachlearn-012/Proyectos/CourseProject")
train<-read.csv(file="datos/pml-training.csv")
test<-read.csv(file="datos/pml-testing.csv")

library(caret)
library(rattle)
library(pROC)
##analisis exploratorio
str(train)
summary(train)
head(train)
names(train)
sum(is.na(train))/(19622*160)

resumen<-function(df){
        columnas<-names(df)
        cantObs<-dim(df)[1]
        resultado<-data.frame(variable=vector(),
                              na=vector(),
                              pna=vector(),
                              vacio=vector(),
                              pvacio=vector())
        for(i in 1:length(names(df))){
        resultado<-rbind(resultado,data.frame(variable=columnas[i],
                                              na=sum(is.na(df[,i])),
                                              pna=sum(is.na(df[,i]))/cantObs,
                                              vacio=sum(df[,i]==""),
                                              pvacio=sum(df[,i]=="")/cantObs
                                              ))
                
        }
        return(resultado[order(-resultado$na,-resultado$pvacio),])
}
f<-resumen(train)
table(f$na)
##me quedo con aquellas variables que no tiene NA.
## tambien elimino a aquellas que tienen que ver con el tiempo.
f<-f[f$na==0,]
f<-f[f$vacio==0,]
f$variable
trainReducido<-train[,f$variable]
f2<-resumen(trainReducido)
str(trainReducido)
trainReducido<-trainReducido[,-1:-7]
summary(trainReducido)
table(trainReducido$classe)/19622
###Prediccion
inTrain<-createDataPartition(y=trainReducido$classe,p=0.7,list=F)
training<-trainReducido[inTrain,]
table(training$classe)/19622
testing<-trainReducido[-inTrain,]
### CART
modFit<-train(classe~.,method="rpart",data=training)
modFit
fancyRpartPlot(modFit$finalModel)
predccClases<-predict(modFit, newdata = testing)
confusionMatrix(data = predccClases, testing$classe)
#### j48
fitControl <- trainControl(## 10-fold CV
        method = "cv",
        number = 3)
j48Grid <-  expand.grid(C = c(0.1,0.2,0.25,0.3))
set.seed(825)
tunModFit<-train(classe~.,method="J48",
                 data=training,
                 trControl = fitControl,
                 tuneGrid = j48Grid
                 )
predccClases<-predict(tunModFit, newdata = testing)
confusionMatrix(data = predccClases, testing$classe)

trellis.par.set(caretTheme())
plot(tunModFit)