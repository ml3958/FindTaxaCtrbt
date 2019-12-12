FindTaxaCtrbt
=============

TOC
---

1.  [Installation](#installation)
2.  [Getting started](#get_start)

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
    -   a .fasta file containging their amino acid sequences  
    -   a .csv table containing their taxonomic origin

i.e I am interested in the oxalate degradation function.
<table>
<thead>
<tr>
<th style="text-align:right;">
X
</th>
<th style="text-align:left;">
enzyme
</th>
<th style="text-align:left;">
Class
</th>
<th style="text-align:left;">
Description
</th>
<th style="text-align:left;">
Family
</th>
<th style="text-align:left;">
Gene.Name
</th>
<th style="text-align:left;">
Genus
</th>
<th style="text-align:left;">
name
</th>
<th style="text-align:left;">
Order
</th>
<th style="text-align:left;">
Organism
</th>
<th style="text-align:left;">
Phylum
</th>
<th style="text-align:right;">
Sequence.Length
</th>
<th style="text-align:left;">
Species
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
oxc
</td>
<td style="text-align:left;">
Alphaproteobacteria
</td>
<td style="text-align:left;">
Oxalyl-CoA decarboxylase
</td>
<td style="text-align:left;">
Acetobacteraceae
</td>
<td style="text-align:left;">
AZ09\_06970
</td>
<td style="text-align:left;">
Acetobacter
</td>
<td style="text-align:left;">
A0A063X7E6
</td>
<td style="text-align:left;">
Rhodospirillales
</td>
<td style="text-align:left;">
Acetobacter aceti 1023.
</td>
<td style="text-align:left;">
Proteobacteria
</td>
<td style="text-align:right;">
578
</td>
<td style="text-align:left;">
Acetobacter aceti 1023
</td>
</tr>
<tr>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
oxc
</td>
<td style="text-align:left;">
Alphaproteobacteria
</td>
<td style="text-align:left;">
Oxalyl-CoA decarboxylase
</td>
<td style="text-align:left;">
Acetobacteraceae
</td>
<td style="text-align:left;">
oxc
</td>
<td style="text-align:left;">
Acetobacter
</td>
<td style="text-align:left;">
A9X6P8
</td>
<td style="text-align:left;">
Rhodospirillales
</td>
<td style="text-align:left;">
Acetobacter aceti.
</td>
<td style="text-align:left;">
Proteobacteria
</td>
<td style="text-align:right;">
578
</td>
<td style="text-align:left;">
Acetobacter aceti
</td>
</tr>
<tr>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
oxc
</td>
<td style="text-align:left;">
Alphaproteobacteria
</td>
<td style="text-align:left;">
Oxalyl-CoA decarboxylase
</td>
<td style="text-align:left;">
Acetobacteraceae
</td>
<td style="text-align:left;">
S101447\_02301
</td>
<td style="text-align:left;">
Acetobacter
</td>
<td style="text-align:left;">
A0A1Y0V990
</td>
<td style="text-align:left;">
Rhodospirillales
</td>
<td style="text-align:left;">
Acetobacter ascendens.
</td>
<td style="text-align:left;">
Proteobacteria
</td>
<td style="text-align:right;">
578
</td>
<td style="text-align:left;">
Acetobacter ascendens
</td>
</tr>
<tr>
<td style="text-align:right;">
4
</td>
<td style="text-align:left;">
oxc
</td>
<td style="text-align:left;">
Alphaproteobacteria
</td>
<td style="text-align:left;">
Oxalyl-CoA decarboxylase
</td>
<td style="text-align:left;">
Acetobacteraceae
</td>
<td style="text-align:left;">
AD951\_02190
</td>
<td style="text-align:left;">
Acetobacter
</td>
<td style="text-align:left;">
A0A149USA4
</td>
<td style="text-align:left;">
Rhodospirillales
</td>
<td style="text-align:left;">
Acetobacter malorum.
</td>
<td style="text-align:left;">
Proteobacteria
</td>
<td style="text-align:right;">
578
</td>
<td style="text-align:left;">
Acetobacter malorum
</td>
</tr>
<tr>
<td style="text-align:right;">
5
</td>
<td style="text-align:left;">
oxc
</td>
<td style="text-align:left;">
Alphaproteobacteria
</td>
<td style="text-align:left;">
Oxalyl-CoA decarboxylase
</td>
<td style="text-align:left;">
Acetobacteraceae
</td>
<td style="text-align:left;">
SRCM100623\_02026
</td>
<td style="text-align:left;">
Acetobacter
</td>
<td style="text-align:left;">
A0A1A0DAZ7
</td>
<td style="text-align:left;">
Rhodospirillales
</td>
<td style="text-align:left;">
Acetobacter pasteurianus
</td>
<td style="text-align:left;">
Proteobacteria
</td>
<td style="text-align:right;">
578
</td>
<td style="text-align:left;">
Acetobacter pasteurianus
</td>
</tr>
<tr>
<td style="text-align:right;">
6
</td>
<td style="text-align:left;">
oxc
</td>
<td style="text-align:left;">
Alphaproteobacteria
</td>
<td style="text-align:left;">
Oxalyl-CoA decarboxylase
</td>
<td style="text-align:left;">
Acetobacteraceae
</td>
<td style="text-align:left;">
BJI49\_13215
</td>
<td style="text-align:left;">
Acetobacter
</td>
<td style="text-align:left;">
A0A368A7F9
</td>
<td style="text-align:left;">
Rhodospirillales
</td>
<td style="text-align:left;">
Acetobacter pasteurianus
</td>
<td style="text-align:left;">
Proteobacteria
</td>
<td style="text-align:right;">
579
</td>
<td style="text-align:left;">
Acetobacter pasteurianus
</td>
</tr>
</tbody>
</table>
1.  Metagenomics and metatranscriptomics sample for the microbial
    community you’re interested in.

**Step 3. prepare data**
