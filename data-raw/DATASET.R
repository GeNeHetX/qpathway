## code to prepare `DATASET` dataset goes here

#usethis::use_data(DATASET, overwrite = TRUE)
setwd("/Users/remy.nicolle/Workspace/DEV/PATHWAYS/qpath")

library(devtools)


suffix="v7.5.1.symbols.gmt"
d="../msigdb_v7.5.1_GMTs"
allmspf=grep("symbols",list.files("../msigdb_v7.5.1_GMTs/"),value=T)
selpf=c(grep("all|^c2\\.cp\\.v|^c5\\.go\\.v",grep("^c",allmspf,value=T),invert=T,value=T),grep("c1.all|c6.all|c8.all",allmspf,value=T))


mpath=do.call(rbind,lapply(selpf,function(pf){
  print(pf)
  n=sub(paste0("\\.",suffix),"",pf)
  gsl=strsplit(scan(file.path(d,pf),what="character",sep="\n"),"\t")
  names(gsl)=sapply(gsl,function(x){x[1]})
  gsl=lapply(gsl,function(x){x[3:length(x)]})

  saveRDS(gsl,file=paste0("inst/extdata/",n,".rds") )

  data.frame(dbOrigin="msigDB",pathwayName=n,pathwayFile=paste0(n,".rds"),
             nPaths=length(gsl),nMedGene=median(sapply(gsl,length)),v="v7.5.1")
}))



enrchd="../enrichr/"
allenrichf=grep("txt$",list.files(enrchd),value=T)

epath=do.call(rbind,lapply(allenrichf,function(pf){
  print(pf)
  funa=sub(".txt$","",pf)
  smna=sub("_20..","",funa)

  gsl=strsplit(scan(file.path(enrchd,pf),what="character",sep="\n"),"\t")
  names(gsl)=gsub(" ","_",sapply(gsl,function(x){x[1]}))
  gsl=lapply(gsl,function(x){x[3:length(x)]})
  saveRDS(gsl,file=paste0("inst/extdata/",funa,".rds") )

  data.frame(dbOrigin="enrichr",pathwayName=smna,pathwayFile=paste0(funa,".rds"),
             nPaths=length(gsl),nMedGene=median(sapply(gsl,length)),v="feb2022")
}))

listPathDB=rbind(mpath,epath)
listPathDB$nMedGene=as.integer(round(listPathDB$nMedGene))

use_data(listPathDB,overwrite = TRUE)
