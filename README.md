FindTaxaCtrbt
=============

Author: Menghan Liu @ [twitter](https://twitter.com/menghan_liu)

Date: December 12, 2019

This computational pipeline is designed to launch an exhaustive

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
       --in frc_oxc_oxdd_uniref100.faa \ # frc_oxc_oxdd_uniref100.faa as input
       --db frc_oxc_oxdd_uniref100.faa  

**3. \[CORE\] Run diamond **

You can run the program on one sample

    # Run the program
    bash scripts/FindTaxaCtrbt.sh  <path_to_diamond_index> <path_to_MTG/MTS_sample> <directory_to_write_output>

Inputs

1.  <path_to_diamond_index>
2.  <path_to_MTG/MTS_sample> currently accept .fastq.gz file
3.  <directory_to_write_output> **inputs are provided as positional
    manner, thus must follow the order**

Output: 1. diamond output **xx.m8** 2. diamong log file **xx.log**

or, run the program on all samples in one directory
`<directory_of_input_sample>` using paralllel

    parallel \ 
         bash scripts/FindTaxaCtrbt.sh  <path_to_database> {.} <directory_to_write_output> \ # command to loop for via parallel 
         ::: `ls <directory_of_input_sample>/*` # provide value for {.}

**4. \[CORE\] Parse diamond output**

    Rscript --vanilla \
        ../scripts/parse_blastx.r \
        $outputDir/${input_prefix}.m8 \
        $outputDir/${input_prefix}_protein_summary.txt \
        90

**5. Merge batch output into one sample**

### Determine the mapping identity cutoff

Test run with sample data
-------------------------

Download sample data via this
[link](https://drive.google.com/drive/u/1/folders/1zh-nD4X3bhZAx9XbdMjOeJCp-jZc4XL6)

Within the downloaded folder, there is a
**frc\_oxc\_oxdd\_uniref100.faa** that contains the amino acid sequences
of 6067 protein homologs of oxalate degrading enzymes OXDD, FRC and OXC.

Also, there are two folders **MTG/** and **MTS/** that contains 3
metagenomic and 3 metatranscriptomic fastq.gz samples, respectively.
<!-- For example, I am interested in the oxalyl-coA decarboxylase (OXC), which is involved in the oxalate degradation function. -->
<!-- Therefore, I found a [homologous protein family](http://www.ebi.ac.uk/interpro/entry/InterPro/IPR017660/) for OXC at Uniprot. -->

<!-- ```{r example table, echo=FALSE,eval=TRUE} -->
<!-- table_dir='/Volumes/Research/blaserlab/blaserlabspace/Members/Menghan_Liu/ODE/human_metagenomics/0_data/ODE_tnaA_info.csv' -->
<!-- read.csv(table_dir) %>% -->
<!--   head() %>% -->
<!--   dplyr::mutate(UniprotID = name, -->
<!--                 Strain = Species) %>% -->
<!--   tidyr::separate(Species, into = c("Genus","Species"),sep=" ",extra="drop") %>% -->
<!--   dplyr::select(UniprotID,Description,Phylum, Family, Genus, Species, Strain) %>% -->
<!--   knitr::kable(format = "markdown") %>% -->
<!--   kable_styling(font_size = 7, full_width = F)  -->
<!-- ``` -->
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
