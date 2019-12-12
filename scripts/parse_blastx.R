#!/usr/bin/env Rscript

# Author: Menghan Liu
# Date: December 9, 2019
# Descript: To parse a diamond output .m8 file
# Output: 
# Usage:
    ## module load r/3.3.2
    ## Rscript --vanilla parse_blastx.r [inputdir] [output] [identity_threshold]



suppressMessages(library(dplyr));suppressMessages(library(tidyr))
#suppressMessages(library(plyr))
args = commandArgs(trailingOnly=TRUE)


# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
  # default output file
  args[2] = getwd()
  }


# verbose
message(paste("Processing intput [",args[1],"]",date()))



# process
input = args[1]
output = args[2]
ident_threshold = as.numeric(args[3])


data = tryCatch(read.delim(input,sep="\t",header=F), error=function(e) NULL)

if (is.null(data)){
  message(paste("no input in ",input,", skip....",sep=""))
} else {
  
  colnames(data) = c("queryID","sequenceID","ident","align_length","mismatch","gap","qstart","qend","sstart","send","evalue","bitscore")
  data = subset(data,ident>ident_threshold)
  
  if (nrow(data)==0){
    message(paste("no mapping read with identity > ",ident_threshold,", skip....",date(),sep=""))
    } else {
    message(paste("Store output [",args[2],"]",date()))
    coverage_read_per_seqeuce <- data %>%
      dplyr::filter(ident>ident_threshold) %>% # only keep the alignment pair with the largest bitscore
      
      # if two alignments are returned, keep the one with maximum bitsocre
      dplyr::group_by(queryID,sequenceID) %>%
      dplyr::summarise(index = which(bitscore == max(bitscore))[1], 
                       align_length = align_length[index],
                       sstart = sstart[index],
                       send = send[index],
                       base_covered = paste(sstart:send, collapse=","),
                       ident = ident[index],
                       gap = gap[index]) %>% 
      
      # calculate number of base covered for each refernece
      dplyr::group_by(queryID,sequenceID) %>%
      dplyr::summarise(N_base_covered = send-sstart-gap) %>%
      
      # summary for each reference 
      dplyr::group_by(sequenceID) %>%
      dplyr::summarise(N_of_read = length(unique(queryID)),
                       N_base_covered_mean = mean(N_base_covered)) %>%
    write.csv(output, 
              quote=F,
              row.names=F)
    }
  }
  
