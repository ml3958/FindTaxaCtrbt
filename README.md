FindTaxaCtrbt
=============

Author: Menghan Liu  
@ [twitter](https://twitter.com/menghan_liu) @
[email](menghan.liu@nyumc.org)

Date: December 12, 2019

This computational pipeline for exhaustive search of taxonomic
contribution to a specific function, within a defined microbiome
community.

*Status: Source code of the pipeline can be found on this repository.
Downstream analyses scripts are available per request.*

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

The multi-omics data I used for the study come from the following
studies

``` r
table_dir = "~/OneDrive - NYU Langone Health/oxalobiome/NatureMicro/Suppl table.xlsx"
read_excel(table_dir,sheet = 1,skip = 2) %>%
   knitr::kable(format = "markdown") %>%
  kable_styling(font_size = 7, full_width = F)
```

<table style="width:100%;">
<colgroup>
<col style="width: 43%" />
<col style="width: 2%" />
<col style="width: 1%" />
<col style="width: 3%" />
<col style="width: 1%" />
<col style="width: 1%" />
<col style="width: 1%" />
<col style="width: 5%" />
<col style="width: 1%" />
<col style="width: 2%" />
<col style="width: 1%" />
<col style="width: 7%" />
<col style="width: 12%" />
<col style="width: 4%" />
<col style="width: 8%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">Study</th>
<th style="text-align: left;">Sample sizea</th>
<th style="text-align: left;">…3</th>
<th style="text-align: left;">Demographic information</th>
<th style="text-align: left;">…5</th>
<th style="text-align: left;">…6</th>
<th style="text-align: left;">…7</th>
<th style="text-align: left;">Sample collection and preservation</th>
<th style="text-align: left;">…9</th>
<th style="text-align: left;">…10</th>
<th style="text-align: left;">…11</th>
<th style="text-align: left;">DNA/RNA extraction</th>
<th style="text-align: left;">…13</th>
<th style="text-align: left;">Sequencing platform</th>
<th style="text-align: left;">Ref</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">NA</td>
<td style="text-align: left;">sample</td>
<td style="text-align: left;">subject</td>
<td style="text-align: left;">Age</td>
<td style="text-align: left;">Sex (M%)</td>
<td style="text-align: left;">BMIb</td>
<td style="text-align: left;">Location</td>
<td style="text-align: left;">collection</td>
<td style="text-align: left;">RNAlater</td>
<td style="text-align: left;">Immedi-ate on ice</td>
<td style="text-align: left;">Storage</td>
<td style="text-align: left;">DNA extraction</td>
<td style="text-align: left;">RNA extraction method</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="even">
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">(mean ± s.d.)</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">method</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="odd">
<td style="text-align: left;">AMP</td>
<td style="text-align: left;">89/ 60</td>
<td style="text-align: left;">33/ 33</td>
<td style="text-align: left;">–</td>
<td style="text-align: left;">65</td>
<td style="text-align: left;">100/ 0/ 0</td>
<td style="text-align: left;">US</td>
<td style="text-align: left;">self</td>
<td style="text-align: left;">yes</td>
<td style="text-align: left;">yes</td>
<td style="text-align: left;">-80</td>
<td style="text-align: left;">PowerSoil DNA Isolation Kit</td>
<td style="text-align: left;">PowerMicrobiome RNA Isolation Kit DNAse treatment using the Turbo DNA-Free Kit</td>
<td style="text-align: left;">Illumina NextSeq and HiSeq</td>
<td style="text-align: left;">(Petersen et al., 2017)</td>
</tr>
<tr class="even">
<td style="text-align: left;">MetaHit</td>
<td style="text-align: left;">563/ 0</td>
<td style="text-align: left;">276/ 0</td>
<td style="text-align: left;">56.0 ± 7.2</td>
<td style="text-align: left;">54</td>
<td style="text-align: left;">29/10/61</td>
<td style="text-align: left;">Europe</td>
<td style="text-align: left;">self</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">yes</td>
<td style="text-align: left;">-80</td>
<td style="text-align: left;">Silica bead method*</td>
<td style="text-align: left;">–</td>
<td style="text-align: left;">Illumina</td>
<td style="text-align: left;">(Li et al., 2014)</td>
</tr>
<tr class="odd">
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">GA system</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="even">
<td style="text-align: left;">US men</td>
<td style="text-align: left;">1,413/743</td>
<td style="text-align: left;">306/ 96</td>
<td style="text-align: left;">–</td>
<td style="text-align: left;">100</td>
<td style="text-align: left;">–</td>
<td style="text-align: left;">US</td>
<td style="text-align: left;">self</td>
<td style="text-align: left;">yes</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">-80</td>
<td style="text-align: left;">MoBio PowerLyzer kit</td>
<td style="text-align: left;">Qiagen AllPrep rRNA depletion: Epicentre Ribo-Zero™ Magnetic Kit</td>
<td style="text-align: left;">Illumina</td>
<td style="text-align: left;">(Abu-Ali et al., 2018)</td>
</tr>
<tr class="odd">
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">(adults)</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">HiSeq</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="even">
<td style="text-align: left;">Fran</td>
<td style="text-align: left;">32/ 48</td>
<td style="text-align: left;">44051</td>
<td style="text-align: left;">–</td>
<td style="text-align: left;">100</td>
<td style="text-align: left;">100/ 0/ 0</td>
<td style="text-align: left;">US</td>
<td style="text-align: left;">self</td>
<td style="text-align: left;">yes</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">-80</td>
<td style="text-align: left;">MoBio PowerLyzer kit</td>
<td style="text-align: left;">Qiagen AllPrep rRNA depletion: Epicentre Ribo-Zero™ Magnetic Kit</td>
<td style="text-align: left;">Illumina</td>
<td style="text-align: left;">(Franzosa et al., 2014)</td>
</tr>
<tr class="odd">
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">(adults)</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">MiSeq</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="even">
<td style="text-align: left;">HMP2</td>
<td style="text-align: left;">326/ 91</td>
<td style="text-align: left;">132/ 39</td>
<td style="text-align: left;">27.7 ± 17.7</td>
<td style="text-align: left;">49</td>
<td style="text-align: left;">–</td>
<td style="text-align: left;">US</td>
<td style="text-align: left;">At center</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">-80</td>
<td style="text-align: left;">Chemagic​ ​DNA​ ​Blood​ ​Kit-96 from​ ​Perkin​ ​Elmer</td>
<td style="text-align: left;">Chemagic​ ​DNA​ ​Blood​ ​Kit-96 from​ ​Perkin​ ​Elmer</td>
<td style="text-align: left;">Illumina</td>
<td style="text-align: left;">(Lloyd-Price et al., 2019; Schirmer et al., 2018)</td>
</tr>
<tr class="odd">
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">HiSeq X</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="even">
<td style="text-align: left;">Total</td>
<td style="text-align: left;">2,423/942</td>
<td style="text-align: left;">755/176</td>
<td style="text-align: left;">–</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="odd">
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="even">
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="odd">
<td style="text-align: left;">a Metagenome / metatranscriptome;  b Lean/Overweight/Obese</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="even">
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="odd">
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="even">
<td style="text-align: left;">*Abu-Ali, G.S., Mehta, R.S., Lloyd-Price, J., Mallick, H., Branck, T., Ivey, K.L., Drew, D.A., DuLong, C., Rimm, E., Izard, J., et al. (2018). Metatranscriptome of human faecal microbial communities in a cohort of adult men. Nat Microbiol 3, 356-366.</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Franzosa, E.A., Morgan, X.C., Segata, N., Waldron, L., Reyes, J., Earl, A.M., Giannoukos, G., Boylan, M.R., Ciulla, D., Gevers, D., et al. (2014). Relating the metatranscriptome and metagenome of the human gut. Proc Natl Acad Sci U S A 111, E2329-2338.</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="even">
<td style="text-align: left;">Li, J., Jia, H., Cai, X., Zhong, H., Feng, Q., Sunagawa, S., Arumugam, M., Kultima, J.R., Prifti, E., Nielsen, T., et al. (2014). An integrated catalog of reference genes in the human gut microbiome. Nat Biotechnol 32, 834-841.</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Lloyd-Price, J., Arze, C., Ananthakrishnan, A.N., Schirmer, M., Avila-Pacheco, J., Poon, T.W., Andrews, E., Ajami, N.J., Bonham, K.S., Brislawn, C.J., et al. (2019). Multi-omics of the gut microbial ecosystem in inflammatory bowel diseases. Nature 569, 655-662.</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="even">
<td style="text-align: left;">Petersen, L.M., Bautista, E.J., Nguyen, H., Hanson, B.M., Chen, L., Lek, S.H., Sodergren, E., and Weinstock, G.M. (2017). Community characteristics of the gut microbiomes of competitive cyclists. Microbiome 5, 98.</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Schirmer, M., Franzosa, E.A., Lloyd-Price, J., McIver, L.J., Schwager, R., Poon, T.W., Ananthakrishnan, A.N., Andrews, E., Barron, G., Lake, K., et al. (2018). Dynamics of metatranscription in the inflammatory bowel disease gut microbiome. Nat Microbiol 3, 337-346.</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
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
