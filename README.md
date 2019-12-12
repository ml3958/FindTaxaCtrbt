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

The environment required for FindTaxaCtrbt can be handled via creating a
conda environment based on the provided .yml file
*FindTaxaCtrbt\_environment.yml*, with the following code

    conda env create -n <your_env_name> --file FindTaxaCtrbt_environment.yml # Create a new conda environment

    conda activate <your_env_name> # initiate the environment

you can name the environment however you want, by specify and substitute
in `<your_env_name>`, in the following tutorial, we will call it
`FindTaxaCtrbt`

If you have the dependencies already, you can skip this step; or install
the dependencies manually,

-   Diamond (v0.9.14 currently included in the
    *FindTaxaCtrbt\_environment.yml*)
-   R
    -   R v3.3.2
    -   R packages: dplyr, tidyr
-   Parallel (v0.9.14)

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
