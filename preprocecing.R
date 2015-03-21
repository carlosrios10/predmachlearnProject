# In this scrip we make a tydy data set
# me quedo con aquellas variables que no tiene NA.
# tambien elimino a aquellas que tienen que ver con el tiempo.
resumen<-resumen(train)
resumen<-resumen[resumen$na==0,]
resumen<-resumen[resumen$vacio==0,]
trainReducido<-train[,resumen$variable]
trainReducido<-trainReducido[,-1:-7]
