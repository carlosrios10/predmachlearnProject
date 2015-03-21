# This function take a data frame and compute for each column
# the number of missing values.
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



pml_write_files = function(x){
    n = length(x)
    for(i in 1:n){
        filename = paste0("problem_id_",i,".txt")
        write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
    }
}