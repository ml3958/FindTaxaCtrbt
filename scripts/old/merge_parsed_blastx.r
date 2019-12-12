#!/usr/bin/env Rscript

# USAGE:
	# module load r/3.3.2
	# Rscript --vanilla merge_parsed_blastx.r [inputdir] <output_dir> <output_prefix>

library(dplyr);library(ggplot2);library(tidyr);library(plyr)
args = commandArgs(trailingOnly=TRUE)


# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
  # default output file
  args[2] = getwd()
  args[3] = "results"
} else if (length(args)==2) {
  # default output prefix
  args[3] = "results"
}

input_dir = args[1]
output_dir = args[2]
output_prefix = args[3]
print(input_dir)
print(output_dir)
print(output_prefix)


filenames <- list.files(input_dir, pattern="*.txt")

sequenceID = c()

for (i in filenames){
	filename = paste(input_dir,i,sep="") 
	data = read.delim2(filename,stringsAsFactors=F)
	sequenceID = union(sequenceID,data$sequenceID)
	}
	
	
merged_N_of_read = matrix("",nrow=length(sequenceID),ncol = length(filenames),
			dimnames = list(sequenceID,
                            filenames))

merged_N_of_covered_bases = matrix("",nrow=length(sequenceID),ncol = length(filenames),
			dimnames = list(sequenceID,
                            filenames))

merged_identity = matrix("",nrow=length(sequenceID),ncol = length(filenames),
			dimnames = list(sequenceID,
                            filenames))

merged_covered_base = matrix("",nrow=length(sequenceID),ncol = length(filenames),
			dimnames = list(sequenceID,
                            filenames))


for (i in filenames){
	filename = paste(input_dir,i,sep="") 
	data = read.delim2(filename,stringsAsFactors=F)
	
	merged_N_of_read[data$sequenceID,i] = data$N_of_read
	merged_N_of_covered_bases[data$sequenceID,i] = data$N_of_covered_bases
	merged_identity[data$sequenceID,i] = data$ident
	merged_covered_base[data$sequenceID,i] = data$covered_base
	}
	
write.table(merged_N_of_read,paste(output_dir,"/",output_prefix,"_Nread_merged.txt",sep=""),sep="\t",row.names=T,quote=F)
write.table(merged_N_of_covered_bases,paste(output_dir,"/",output_prefix,"_Ncovered_bases_merged.txt",sep=""),sep="\t",row.names=T,quote=F)
write.table(merged_identity,paste(output_dir,"/",output_prefix,"_ident_merged.txt",sep=""),sep="\t",row.names=T,quote=F)
write.table(merged_covered_base,paste(output_dir,"/",output_prefix,"_covered_bases_merged.txt",sep=""),sep="\t",row.names=T,quote=F)
