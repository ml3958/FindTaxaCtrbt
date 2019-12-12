
#!/usr/bin/env Rscript

# USAGE:
	# module load r/3.3.2
	# Rscript --vanilla parse_blastx.r [inputdir] [output_dir] [identity_threshold]

suppressMessages(library(dplyr));suppressMessages(library(ggplot2));suppressMessages(library(tidyr));suppressMessages(library(plyr))
args = commandArgs(trailingOnly=TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
  # default output file
  args[2] = getwd()
}


# verbose
print(paste("Processing intput [",args[1],"]",date()))
print(paste("Store output in [",args[2],"]",date()))




# process


input_dir = args[1]
output_dir = args[2]
ident_threshold = as.numeric(args[3])

files = grep("m8$",list.files(input_dir),value=T)
#print(files)

for (i in files){
	input = paste(input_dir,"/",i,sep="")
	output = paste(output_dir,"/",i,"_parse.txt", sep="")
	data = tryCatch(read.delim(input,sep="\t",header=F), error=function(e) NULL)
	if (is.null(data)){
	 message(paste("no input in ",i,", skip....",sep=""))
	}
	else {
		colnames(data) = c("queryID","sequenceID","ident","align_length","mismatch","gap","qstart","qend","sstart","send","evalue","bitscore")	
		data = subset(data,ident>ident_threshold)
		if (nrow(data)==0){
		 message(paste("	no mapping read with identity > ",ident_threshold,", skip....",sep=""))}
		else {
		message(paste("processing ",i,sep=""))
		coverage_read_per_seqeuce <- data %>%
		#dplyr::filter(ident>ident_threshold) %>%
		dplyr::group_by(queryID,sequenceID) %>%
		dplyr::summarise(index = which(bitscore == max(bitscore))[1], # only keep the alignment pair with the largest bitscore
				 sstart = sstart[index],
				 send = send[index],
				 covered_base = paste(sstart:send, collapse=","),
			     ident = ident[index]) %>% 
			     dplyr::group_by(sequenceID) %>%
			     dplyr::summarise(N_of_read = length(unique(queryID)),
				 covered_base = paste(covered_base,collapse=","),
				 ident = mean(ident)) %>%
				 dplyr::group_by(sequenceID) %>%				 
				 dplyr::mutate(N_of_covered_bases = length(unique(unlist(strsplit(covered_base,split=",")))))
		write.table(coverage_read_per_seqeuce,
			output,
			sep="\t",
			quote=F,
			row.names=F)}
	}
}

