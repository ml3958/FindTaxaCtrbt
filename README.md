FindTaxaCtrbt
=============

Author: Menghan Liu @ [twitter](https://twitter.com/menghan_liu)

Date: December 12, 2019

This computational pipeline for exhaustive search of taxonomic
contribution to a specific function, within a defined microbiome
community.

*Status: The core shell scripts are up, R scripts are being cleaned up
and pending for uploading.*

TOC
---

1.  [Installation](#installation)
2.  [Getting started](#Getting-started)
3.  [Tutorial](#tutorial)
4.  [Determine mapping identity
    cutoff](#determine-the-mapping-identity-cutoff)
5.  [Test run with sample data](#Test-run-with-sample-data)
6.  [Citation](#citation)

Installation
------------

    git clone https://github.com/ml3958/FindTaxaCtrbt

This command will download all relevent scripts to your local computer.

In order to use these scripts, you either need to be inside this
downloaded folder via `cd <Downloaded_FindTaxaCtrbt_folder>`, or add the
full path when calling the script.

Getting started
---------------

Preparation involve two steps, where step 1 is to set up a conda
environment with all required dependency; step 2 is to gather data.

**Step 1. Environment setup**

This step needs to be completed for anyone who wants to use this
pipeline.

The environment required for FindTaxaCtrbt can be handled via creating a
conda environment based on the ***FindTaxaCtrbt\_environment.yml*** file
provided, with the following code

    conda env create -n FindTaxaCtrbt --file FindTaxaCtrbt_environment.yml # Create a new conda environment called FindTaxaCtrbt

    conda activate FindTaxaCtrbt # initiate the environment

*you can customize your environment name by replacing FindTaxaCtrbt with
<name_of_your_choice>*

You can also manually install the core dependencies (Diamond,
[Parallel](https://www.gnu.org/software/parallel/parallel_tutorial.html)
*v0.9.14*, R *v3.3.2*, r packages
[dplyr](https://cran.r-project.org/web/packages/dplyr/index.html) and
[tidyr](https://cran.r-project.org/web/packages/tidyr/index.html))

**Step 2. Download data**

Depending upon experimental design and research purpose, this step needs
to be customized performed.

-   First, **Reference protein**: a list of protein homologs for the
    microbiome function/enzyme of interest
    -   a **.fasta file** containging their amino acid sequences
    -   a **.csv table** containing their taxonomic origin
-   Second, **microbiome meta’omics samples** from publicaly avaiable
    samples, or freshly generated
    -   metagenome or metatranscriptome samples

Tutorial
--------

**1. Initiate conda environment**

    conda activate FindTaxaCtrbt 

**2. Build diamond index for protein reference**

For each protein fasta file, you only need to build index for once upon
first usage.

    diamond makedb \
       --in <ref_protein_homolog.fa> \ # path to input fasta file for reference protein homologs
       --db <path_of_database_to_write_to>  # output directory of database

**3. \[CORE\] Run diamond**

You can run the program on one sample

    # Run the program
    bash scripts/FindTaxaCtrbt.sh  <path_to_diamond_index> <path_to_MTG/MTS_sample> <directory_to_write_output>

Inputs:

1.  <path_to_diamond_index>
2.  <path_to_MTG/MTS_sample> currently accept .fastq.gz file
3.  <directory_to_write_output> *provided as positional manner, thus
    must follow the order*

Outputs:

1.  diamond output **xx.m8**
2.  diamong log file **xx.log**

or, run the program on all samples in one directory
`<directory_of_input_sample>` using paralllel

    parallel \ 
         bash scripts/FindTaxaCtrbt.sh  <path_to_database> {.} <directory_to_write_output> \ # command to loop for via parallel 
         ::: `ls <directory_of_input_sample>/*` # provide value for {.}

**4. \[CORE\] Parse diamond output**

    Rscript --vanilla ../scripts/parse_blastx.R <path_to_diamond_m8_output> <output_file> <identity_cutoff>

or parallel

    dir=<.m8_file_directory>
    parallel \
       Rscript --vanilla ../scripts/parse_blastx.R {1} {1}_protein_summary.txt <identity_cutoff> \
       ::: \
          `ls ${dir}/* |grep m8$`

**5. Merge batch output into one sample**

Determine the mapping identity cutoff
-------------------------------------

Test run with sample data
-------------------------

Download sample data via this
[link](https://drive.google.com/drive/u/1/folders/1zh-nD4X3bhZAx9XbdMjOeJCp-jZc4XL6)

Within the downloaded folder, there is a
**frc\_oxc\_oxdd\_uniref100.faa** that contains the amino acid sequences
of 6067 protein homologs of oxalate degrading enzymes OXDD, FRC and OXC.

Also, there are two folders **MTG/** and **MTS/** that contains 3
metagenomic and 3 metatranscriptomic fastq.gz samples, respectively.

For example, I am interested in the oxalyl-coA decarboxylase (OXC),
which is involved in the oxalate degradation function. Therefore, I
found a [homologous protein
family](http://www.ebi.ac.uk/interpro/entry/InterPro/IPR017660/) for OXC
at Uniprot.

<table>
<colgroup>
<col style="width: 9%" />
<col style="width: 21%" />
<col style="width: 12%" />
<col style="width: 14%" />
<col style="width: 10%" />
<col style="width: 11%" />
<col style="width: 21%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">UniprotID</th>
<th style="text-align: left;">Description</th>
<th style="text-align: left;">Phylum</th>
<th style="text-align: left;">Family</th>
<th style="text-align: left;">Genus</th>
<th style="text-align: left;">Species</th>
<th style="text-align: left;">Strain</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">A0A063X7E6</td>
<td style="text-align: left;">Oxalyl-CoA decarboxylase</td>
<td style="text-align: left;">Proteobacteria</td>
<td style="text-align: left;">Acetobacteraceae</td>
<td style="text-align: left;">Acetobacter</td>
<td style="text-align: left;">aceti</td>
<td style="text-align: left;">Acetobacter aceti 1023</td>
</tr>
<tr class="even">
<td style="text-align: left;">A9X6P8</td>
<td style="text-align: left;">Oxalyl-CoA decarboxylase</td>
<td style="text-align: left;">Proteobacteria</td>
<td style="text-align: left;">Acetobacteraceae</td>
<td style="text-align: left;">Acetobacter</td>
<td style="text-align: left;">aceti</td>
<td style="text-align: left;">Acetobacter aceti</td>
</tr>
<tr class="odd">
<td style="text-align: left;">A0A1Y0V990</td>
<td style="text-align: left;">Oxalyl-CoA decarboxylase</td>
<td style="text-align: left;">Proteobacteria</td>
<td style="text-align: left;">Acetobacteraceae</td>
<td style="text-align: left;">Acetobacter</td>
<td style="text-align: left;">ascendens</td>
<td style="text-align: left;">Acetobacter ascendens</td>
</tr>
<tr class="even">
<td style="text-align: left;">A0A149USA4</td>
<td style="text-align: left;">Oxalyl-CoA decarboxylase</td>
<td style="text-align: left;">Proteobacteria</td>
<td style="text-align: left;">Acetobacteraceae</td>
<td style="text-align: left;">Acetobacter</td>
<td style="text-align: left;">malorum</td>
<td style="text-align: left;">Acetobacter malorum</td>
</tr>
<tr class="odd">
<td style="text-align: left;">A0A1A0DAZ7</td>
<td style="text-align: left;">Oxalyl-CoA decarboxylase</td>
<td style="text-align: left;">Proteobacteria</td>
<td style="text-align: left;">Acetobacteraceae</td>
<td style="text-align: left;">Acetobacter</td>
<td style="text-align: left;">pasteurianus</td>
<td style="text-align: left;">Acetobacter pasteurianus</td>
</tr>
<tr class="even">
<td style="text-align: left;">A0A368A7F9</td>
<td style="text-align: left;">Oxalyl-CoA decarboxylase</td>
<td style="text-align: left;">Proteobacteria</td>
<td style="text-align: left;">Acetobacteraceae</td>
<td style="text-align: left;">Acetobacter</td>
<td style="text-align: left;">pasteurianus</td>
<td style="text-align: left;">Acetobacter pasteurianus</td>
</tr>
</tbody>
</table>

Now, let’s start a test run on those sample data

    # Initiate conda environment
    conda activate FindTaxaCtrbt 

    # Switch to your directory
    cd /Users/menghanliu/Documents/FindTaxaCtrbt_sample_data

    # Build diamond index for protein reference 
    diamond makedb \
       --in frc_oxc_oxdd_uniref100.faa \ # frc_oxc_oxdd_uniref100.faa as input
       --db frc_oxc_oxdd_uniref100.faa  # prefix for databae, output: frc_oxc_oxdd_uniref100.faa.dmnd
       
    # Check whether the database is sucesfully built 
    ls frc_oxc_oxdd_uniref100.faa.dmnd


    # Make a new folder to store the results 
    mkdir -p output

Next we can run the program on either one sample,

    # Run the program on one sample MTG/CSM5FZ42.fastq.gz
    bash <path_to_your_FindTaxaCtrbt_folder>/scripts/FindTaxaCtrbt.sh  \
         frc_oxc_oxdd_uniref100.faa \
         MTG/CSM5FZ42.fastq.gz \
         test_result test_result/

Or parallel on all samples within one folder

    parallel \
         bash <path_to_your_FindTaxaCtrbt_folder>/scripts/FindTaxaCtrbt.sh  \
             frc_oxc_oxdd_uniref100.faa \
             {.} \
             test_result test_result \
        ::: ls MTG/*

Citation
--------

Pending
