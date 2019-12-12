#!/bin/bash


# USAGE: 
# FindTaxaCtrbt.sh  [reference] [input] [outputDir] [intermediateDir] 


db=$1
input=$2
outputDir=$3
intermediateDir=$4
input_prefix=$(basename -s .fastq.gz $input)



mkdir -p $outputDir


echo ----------------
echo "Step 1 Diamond"
echo ----------------
time diamond blastx --verbose \
	--db $db \
	--query $input \
	--max-target-seqs 1 \
	--tmpdir $outputDir \
	-o $outputDir/${input_prefix}.m8 \
	--id 90 > $outputDir/${input_prefix}.log

echo Total sequence count in ${input} = $(cat $outputDir/${input_prefix}.log|grep -A1 "Loading query sequences" |grep "Sequences = "|cut -f1 -d","|cut -f3 -d" " |paste -sd+ -|bc ) >> $outputDir/${input_prefix}.log

echo Diamond output saved in $outputDir/${input_prefix}.m8
echo Diamond log saved in $outputDir/${input_prefix}.log


echo ----------------
echo "Step 2 Parse diamond output"
echo ----------------
Rscript --vanilla scripts/parse_blastx.r $outputDir/${input_prefix}.m8 $outputDir/${input_prefix}_protein_summary.csv 90