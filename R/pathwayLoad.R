#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Install Package:           'Cmd + Shift + B'
#   Check Package:             'Cmd + Shift + E'
#   Test Package:              'Cmd + Shift + T'

loadPath=function(pathlist=c("basic","cellpop","all")[1]){
  ref=qpath::listPathDB
  if("basic" %in% pathlist){
    pathlist=c(pathlist,"BioPlanet","Elsevier_Pathway_Collection","c2.cp.reactome","c2.cp.wikipathways",
               "c2.cp.kegg","c2.cp.biocarta","c2.cp.pid")
  }

  if("cellpop" %in% pathlist){
    pathlist=c(pathlist,"c8.all","Azimuth_Cell_Types","CellMarker_Augmented","Descartes_Cell_Types_and_Tissue",
               "Human_Gene_Atlas","Jensen_TISSUES","Tissue_Protein_Expression_from_Human_Proteome_Map",
               "Tissue_Protein_Expression_from_ProteomicsDB")
  }

  if("all" %in% pathlist){
    pathlist=qpath::listPathDB$pathwayName
  }

  pathlist=intersect(pathlist, qpath::listPathDB$pathwayName)

  if(length(pathlist)==0){
    stop(paste("No such pathway list. Choose among:",qpath::listPathDB$pathwayName,collpase="\n"))
  }


  seldf=qpath::listPathDB[which(qpath::listPathDB$pathwayName %in%pathlist ),]



  loadedP=unlist(lapply(1:nrow(seldf),function(i){
    ap=readRDS(system.file("extdata",seldf[i,"pathwayFile"],package = "qpath"))
    ap=lapply(ap, function(z){sort(unique(setdiff(z,c(NA,"","---"))))})
    names(ap)=paste0(seldf[i,"pathwayName"],"~",names(ap))
    ap
  }),recursive=F)


  loadedP
}


