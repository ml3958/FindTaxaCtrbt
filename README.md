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

**Step 2. Download data **

Two part of input data is required

1.
