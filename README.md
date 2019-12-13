FindTaxaCtrbt
=============

Author: Menghan Liu @ [twitter](https://twitter.com/menghan_liu)

Date: December 12, 2019

This computational pipeline is designed to launch an exhaustive

TOC
---

1.  [Installation](#installation)
2.  [Preparation](#preparation)
3.  [Getting started](#get_start)
4.  [Tutorial](#tutorial)

X. [Citation](#citation)

Installation
------------

Preparation
-----------

Preparation involve two steps, where step 1 is to set up a conda
environment with all required dependency; step 2 is to gather data.

**Step 1. Environment setup **

This step needs to be completed for anyone who wants to use this
pipeline.

The environment required for FindTaxaCtrbt can be handled via creating a
conda environment based on the ***FindTaxaCtrbt\_environment.yml*** file
provided, with the following code

    conda env create -n FindTaxaCtrbt --file FindTaxaCtrbt_environment.yml # Create a new conda environment called FindTaxaCtrbt

    conda activate FindTaxaCtrbt # initiate the environment

I created my environment named as FindTaxaCtrbt , you can name the
environment however you want.

If you have the dependencies already, you can skip this step; or install
the dependencies manually,

-   Diamond (v0.9.14 currently included in the
    *FindTaxaCtrbt\_environment.yml*)
-   R
    -   R v3.3.2
    -   R packages: dplyr, tidyr
-   Parallel (v0.9.14)

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

Getting started
---------------

### Prepare

    # Initiate conda environment
    conda activate FindTaxaCtrbt 

    # Switch to your directory
    cd /Users/menghanliu/Documents/FindTaxaCtrbt

    # Build diamond index for protein reference 
    diamond makedb \
       --in frc_oxc_oxdd_uniref100.faa \ # frc_oxc_oxdd_uniref100.faa as input
       --db frc_oxc_oxdd_uniref100.faa  
       
    # Check whether the database is sucesfully built 
    ls frc_oxc_oxdd_uniref100.faa.dmnd

### Run program

    # Make a new folder to store the results 
    mkdir -p output

    # Run the program
    bash scripts/FindTaxaCtrbt.sh  \n
         frc_oxc_oxdd_uniref100.faa \n
         data/MTG/CSM5FZ42.fastq.gz \n
         test_result test_result/

Test run with sample data
-------------------------

For example, I am interested in the oxalyl-coA decarboxylase (OXC),
which is involved in the oxalate degradation function.

Therefore, I found a [homologous protein
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

### Prepare

    # Initiate conda environment
    conda activate FindTaxaCtrbt 

    # Switch to your directory
    cd /Users/menghanliu/Documents/FindTaxaCtrbt

    # Build diamond index for protein reference 
    diamond makedb \
       --in frc_oxc_oxdd_uniref100.faa \ # frc_oxc_oxdd_uniref100.faa as input
       --db frc_oxc_oxdd_uniref100.faa  
       
    # Check whether the database is sucesfully built 
    ls frc_oxc_oxdd_uniref100.faa.dmnd

### Run program

    # Make a new folder to store the results 
    mkdir -p output

    # Run the program
    bash scripts/FindTaxaCtrbt.sh  \n
         frc_oxc_oxdd_uniref100.faa \n
         data/MTG/CSM5FZ42.fastq.gz \n
         test_result test_result/

Citation
--------
