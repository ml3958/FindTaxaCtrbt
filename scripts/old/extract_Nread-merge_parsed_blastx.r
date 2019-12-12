#!/usr/bin/env Rscript

# USAGE:
	# module load r/3.3.2
	# Rscript --vanilla extract_Nread-merge_parsed_blastx.r [inputdir] [output_dir] [prefix] [identity_threshold]
	
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





files = list.files(inputdir,pattern = "_Nread_merged.txt",full.names = T)

Nread = data.frame()

for (i in files){
  # get study name
  name = gsub("+","_",gsub(pattern="_Nread_merged.txt",replacement = "",rev(strsplit(i,"/")[[1]])[1]),fixed = T)
  print(name)
  df = read.delim2(i)
  x = gather(data.frame(uniprotID = row.names(df),df),
             key = "accession", value = "N_of_read",
             colnames(df)[1]:rev(colnames(df))[1]) %>%
    dplyr::filter(!is.na(N_of_read)) %>%
    dplyr::mutate(Study=name)
  Nread = rbind(Nread,x)
}

save.image(paste(outputdir,"/",prefix,"_Nread.RData",sep=""))
write.table(Nread,paste(outputdir,"/",prefix,"_Nread.txt",sep=""),sep="\t")