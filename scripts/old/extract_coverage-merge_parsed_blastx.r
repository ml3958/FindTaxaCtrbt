#!/usr/bin/env Rscript

# USAGE:
	# module load r/3.3.2
	# Rscript --vanilla extract_coverage-merge_parsed_blastx.r [inputdir] [output_dir] [prefix] [identity_threhold]
	
	
suppressMessages(library(dplyr));suppressMessages(library(ggplot2));suppressMessages(library(tidyr));suppressMessages(library(plyr))
args = commandArgs(trailingOnly=TRUE)


# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
  # default output file
  args[2] = getwd()
} else if (length(args)==2) {
  args[3] = Sys.Date()
}

inputdir = args[1]
outputdir = args[2]
prefix = args[3]




files = list.files(inputdir,pattern = "_covered_bases_merged.txt",full.names = T)

covered_bases = data.frame()


for (i in files){
  # get study name
  name = gsub("+","_",gsub(pattern="_covered_bases_merged.txt",replacement = "",rev(strsplit(i,"/")[[1]])[1]),fixed = T)
  print(name)
  df = read.delim2(i,sep="\t")
  x = gather(data.frame(uniprotID = row.names(df),df),
             key = "accession", value = "covered_bases",
             colnames(df)[1]:rev(colnames(df))[1]) %>%
    dplyr::filter(covered_bases!="") %>%
    dplyr::mutate(Study=name)
  covered_bases = rbind(covered_bases,x)
  covered_bases$covered_bases = as.character(covered_bases$covered_bases)
}

covered_bases = covered_bases[covered_bases$covered_bases!="",] 



save.image(paste(outputdir,"/",prefix,"_coverage.RData",sep=""))
write.table(covered_bases,paste(outputdir,"/",prefix,"_covered_bases.txt",sep=""),sep="\t")
