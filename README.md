FindTaxaCtrbt
=============

Author: Menghan Liu @ [twitter](https://twitter.com/menghan_liu)

TOC
---

1.  [Installation](#installation)
2.  [Getting started](#get_start)
3.  [Tutorial](#tutorial)

Installation
------------

Getting started
---------------

**Step 1. Environment setup via Conda**

The environment for sucesfully running FindTaxaCtrbt is handled by
creating a conda environment via the file
<p style="color:darkblue">
FindTaxaCtrbt\_environment.yml
</p>
, with the following code

    conda env create -n FindTaxaCtrbt --file FindTaxaCtrbt_environment.yml

we created a conda environment named FindTaxaCtrbt, and in order to
initiate the environment we just simply run

    conda activate FindTaxaCtrbt

Of course, you can name the environment however you want, by just
substitute the conda env name parameter
`conda env create -n <your_customized_environment_name> --file FindTaxaCtrbt_environment.yml`

The dependencies include manually install dependency

-   Diamond (v0.9.14 currently included in the
    *FindTaxaCtrbt\_environment.yml*)
-   R
    -   R v3.3.2
    -   R packages: dplyr, tidyr

**Step 2. Download data**

Two part of input data is required

1.  a comprehensive list of protein homologs for the function of
    interest
    -   a **.fasta file** containging their amino acid sequences  
    -   a **.csv table** containing their taxonomic origin
2.  Metagenomics and metatranscriptomics sample for the microbial
    community you’re interested in.

Step 3.

Tutorial
--------

For example, I am interested in the oxalyl-coA decarboxylase (OXC),
which is involved in the oxalate degradation function.

Therefore, I found a [homologous protein
family](http://www.ebi.ac.uk/interpro/entry/InterPro/IPR017660/) for OXC
at Uniprot.

    ##   X enzyme               Class               Description           Family
    ## 1 1    oxc Alphaproteobacteria Oxalyl-CoA decarboxylase  Acetobacteraceae
    ## 2 2    oxc Alphaproteobacteria Oxalyl-CoA decarboxylase  Acetobacteraceae
    ## 3 3    oxc Alphaproteobacteria Oxalyl-CoA decarboxylase  Acetobacteraceae
    ## 4 4    oxc Alphaproteobacteria Oxalyl-CoA decarboxylase  Acetobacteraceae
    ## 5 5    oxc Alphaproteobacteria Oxalyl-CoA decarboxylase  Acetobacteraceae
    ## 6 6    oxc Alphaproteobacteria Oxalyl-CoA decarboxylase  Acetobacteraceae
    ##          Gene.Name       Genus       name            Order
    ## 1       AZ09_06970 Acetobacter A0A063X7E6 Rhodospirillales
    ## 2              oxc Acetobacter     A9X6P8 Rhodospirillales
    ## 3    S101447_02301 Acetobacter A0A1Y0V990 Rhodospirillales
    ## 4      AD951_02190 Acetobacter A0A149USA4 Rhodospirillales
    ## 5 SRCM100623_02026 Acetobacter A0A1A0DAZ7 Rhodospirillales
    ## 6      BJI49_13215 Acetobacter A0A368A7F9 Rhodospirillales
    ##                    Organism         Phylum Sequence.Length
    ## 1   Acetobacter aceti 1023. Proteobacteria             578
    ## 2        Acetobacter aceti. Proteobacteria             578
    ## 3    Acetobacter ascendens. Proteobacteria             578
    ## 4      Acetobacter malorum. Proteobacteria             578
    ## 5 Acetobacter pasteurianus  Proteobacteria             578
    ## 6 Acetobacter pasteurianus  Proteobacteria             579
    ##                    Species
    ## 1   Acetobacter aceti 1023
    ## 2        Acetobacter aceti
    ## 3    Acetobacter ascendens
    ## 4      Acetobacter malorum
    ## 5 Acetobacter pasteurianus
    ## 6 Acetobacter pasteurianus
