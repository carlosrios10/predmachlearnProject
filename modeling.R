# Here we create some model through carte package
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
