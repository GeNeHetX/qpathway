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
  ref=qpathway::listPathDB
  if("basic" %in% pathlist){
    pathlist=c(pathlist,"BioPlanet","Elsevier_Pathway_Collection","c2.cp.wikipathways","Reactome",
               "c2.cp.kegg_medicus","c2.cp.biocarta","c2.cp.pid","c4.3ca","c6.all","c7.immunesigdb")
  }

  if("cellpop" %in% pathlist){
    pathlist=c(pathlist,"c8.all","Azimuth","CellMarker","Descartes_Cell_Types_and_Tissue",
               "Human_Gene_Atlas","Jensen_TISSUES","Tissue_Protein_Expression_from_Human_Proteome_Map",
               "Tissue_Protein_Expression_from_ProteomicsDB")
  }

  if("all" %in% pathlist){
    pathlist=qpathway::listPathDB$pathwayName
  }

  pathlist=intersect(pathlist, qpathway::listPathDB$pathwayName)

  if(length(pathlist)==0){
    stop(paste("No such pathway list. Choose among:",qpathway::listPathDB$pathwayName,collpase="\n"))
  }


  seldf=qpathway::listPathDB[which(qpathway::listPathDB$pathwayName %in%pathlist ),]



  loadedP=unlist(lapply(1:nrow(seldf),function(i){
    ap=readRDS(system.file("extdata",seldf[i,"pathwayFile"],package = "qpathway"))
    ap=lapply(ap, function(z){sort(unique(setdiff(z,c(NA,"","---"))))})
    names(ap)=paste0(seldf[i,"pathwayName"],"__",names(ap))
    ap
  }),recursive=F)


  loadedP
}



