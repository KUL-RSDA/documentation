

# First steps

The GEOSldas source code is available on the NASA GitHub [here](https://github.com/GEOS-ESM/GEOSldas).

To build and run GEOSldas, the so-called Baselibs are required, which are also available on the NASA GitHub [here](https://github.com/GEOS-ESM/ESMA-Baselibs).


## Download/build scripts

The scripts [get_build_baselibs.bash](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/get_build_baselibs.bash) and [get_build_GEOSldas.bash](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/get_build_GEOSldas.bash) automatically download and build the Baselibs and GEOSldas, respectively. They run on both Tier-1 and Tier-2, automatically detecting on which cluster they are executed.

### Baselibs
The Baselibs version 6.1.0 (a note on versions follows below) is pre-built on both Tier-1 and Tier-2. It is generally not necessary (and not advised) to built them again yourself. You merely need to source the [g5_modules](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/g5_modules) file in order to use them (a note on that later). However, if you want to run a GEOSldas version other than 17.9.3 that requires a Baselibs version other than 6.1.0, you can download and build it using [get_build_baselibs.bash](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/get_build_baselibs.bash). The installation directory and desired version can be specified within the script. Important to remember, in this case, is that the Baselibs path in the [g5_modules](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/g5_modules) file (see below) also needs to be adjusted accordingly.

### GEOSldas
Upon first execution, [get_build_GEOSldas.bash](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/get_build_GEOSldas.bash) both downloads and builds GEOSldas with the version and into the directory specified within the script. You should hence change the path to the location where you want to install it (a note on code versions follows below). If the specified directory already exists (i.e., upon each subsequent execution), the script deletes and re-builds any pre-existing installation. Doing so is necessary every time you make alterations to the source code.

**IMPORTANT**: GEOSldas does not work out of the box on the HPC. A few source code alterations are necessary, which are available on [our GitHub](https://github.com/KUL-RSDA/GEOSldas/tree/v17.9.3_KUL) on a separate branch that is tied to a specific GEOSldas version (see below). The script [get_build_GEOSldas.bash](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/get_build_GEOSldas.bash) downloads the source code **from our GitHub including these changes**, that is, you don't have to re-implement them yourself when downloading GEOSldas for the first time!

In other words: Downloading GEOSldas from the [NASA GitHub](https://github.com/GEOS-ESM/GEOSldas) does not work out of the box on the HPC, but downloading it from the [KUL-RSDA GitHub](https://github.com/KUL-RSDA/GEOSldas/tree/v17.9.3_KUL), either manually or using [get_build_GEOSldas.bash](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/get_build_GEOSldas.bash), does.


## A note on code versions

The GEOSldas [release notes](https://github.com/GEOS-ESM/GEOSldas/releases) typically mention which Baselibs version was used for building it. Their versions must also match when building them on the HPC. The above-mentioned scripts use GEOSldas version 17.9.3 and Baselibs version 6.1.0.

**IMPORTANT**: [get_build_GEOSldas.bash](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/get_build_GEOSldas.bash) downloads a particular code version from the [KUL-RSDA GitHub](https://github.com/KUL-RSDA/GEOSldas/tree/v17.9.3_KUL), assuming that there exists a branch called \<version\>\_KUL. If you want to download a different GEOSldas version, you need to make sure that a branch exists with the \_KUL suffix, which has all the necessary source code alterations implemented to make it work on the HPC.


## Source code alterations explained

GEOSldas does not work out of the box on the HPC for two reasons:

* The [g5_modules](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/g5_modules) script, which is required to load the correct modules, does not work on the HPC scripts because it is written for the NASA machines.

* The [lenkf.j](https://github.com/GEOS-ESM/GEOSldas/blob/main/src/Applications/LDAS_App/lenkf.j.template) script, which is created to execute GEOSldas, expects a different ressource manager than the one available on the HPC and contains some (non-essential) pre-processing steps that do not work on the HPC.

To following changes have been made to get GEOSldas running on the HPC:

* A light-weight version of the [g5_modules](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/g5_modules) has been created that merely loads the right modules and sets the right environmental variables.

* The [lenkf.j.template](https://github.com/KUL-RSDA/GEOSldas/blob/v17.9.3_KUL/src/Applications/LDAS_App/lenkf.j.template) file has been altered to use the PBS ressource manager instead of SLURM, the NCO module version has been changed, and some non-mandatory pre-processing has been commented out.

* The [ldas_setup](https://github.com/KUL-RSDA/GEOSldas/blob/v17.9.3_KUL/src/Applications/LDAS_App/ldas_setup) script has been altered to use the modified [lenkf.j.template](https://github.com/KUL-RSDA/GEOSldas/blob/v17.9.3_KUL/src/Applications/LDAS_App/lenkf.j.template) correctly.

The exact changes made to the [lenkf.j.template](https://github.com/KUL-RSDA/GEOSldas/blob/v17.9.3_KUL/src/Applications/LDAS_App/lenkf.j.template) and to [ldas_setup](https://github.com/KUL-RSDA/GEOSldas/blob/v17.9.3_KUL/src/Applications/LDAS_App/ldas_setup) can be found [here](https://github.com/KUL-RSDA/GEOSldas/commit/79c6f116ead677b5ee317238023dc4955c30ed8f).

NOTE: The [g5_modules](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/g5_modules) script is not part of the GEOSldas GitHub repository and hence copied by [get_build_GEOSldas.bash](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/get_build_GEOSldas.bash) from */staging/leuven/stg_00024/GEOSldas_libraries/* (Tier-2) or */scratch/leuven/projects/lt1_2020_es_pilot/project_input/rsda/GEOSldas_libraries/* (Tier-1).

As mentioned, the [get_build_GEOSldas.bash](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/get_build_GEOSldas.bash) script downloads a modified version of GEOSldas from our [KUL-RSDA GitHub](https://github.com/KUL-RSDA/GEOSldas/tree/v17.9.3_KUL), which already includes all these changes. The above is thus merely an FYI.

# Using GEOSldas

## Installation

Use the script [get_build_GEOSldas.bash](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/get_build_GEOSldas.bash) to download and build GEOSldas (adjust the root path and GEOSldas version as needed). When altering the source code, you can simply re-run the script in order to re-build your installation.

## Creating the run files

* csh
* cd ./\<your_GEOSldas_root\>/install/bin/
* source g5_modules
* ldas_setup -v \<output_path\> \<exeinp_file\> \<batinp_file\>

## Specifying the output collection

Before submitting the job to run the model (see the next step), the desired output collection needs to be selected in **\<output_path\>/run/HISTORY.rc**. This file is **re-created every time** by [ldas_setup](https://github.com/KUL-RSDA/GEOSldas/blob/v17.9.3_KUL/src/Applications/LDAS_App/ldas_setup) unless the path to a pre-existing HISTORY.rc file is specified explicitly in the \<exeinp_file\>. However, in this case, you still need to **make sure that the experiment ID in this HISTORY.rc matches that of the experiment for which you are using it**.

## Executing the model

* cd \<output_path\>/run
* qsub lenkf.j (as a batch job)

Instead of qsub, "csh lenkf.j" can be used to run GEOSldas in an interactive session.

**NOTE**: By default, the lenkf.j file is intentionally prohibited from running on our group node (so as to not get launched there accidentally in case the required number of processors is available). If you want to run it on the group node for expirimental purposes anyway, make sure to remove "#PBS -W x=excludenodes=r23i13n23" in line 24 (and make sure not to use too many cores).

## Configuration file templates

Templates for the *\<exeinp_file\>* and *\<batinp_file\>* configuration files, which are used by [ldas_setup](https://github.com/KUL-RSDA/GEOSldas/blob/v17.9.3_KUL/src/Applications/LDAS_App/ldas_setup) to do the relevant pre-processing and to create the run scripts, can be found at */staging/leuven/stg_00024/OUTPUT/alexg/data_sets/GEOSldas/config/*. For the generation of ensembles and for data assimilation, special namelist files ("LDASsa_SPECIAL_inputs_\*.nml") are required, templates of which can also be found in that directory.

## Debugging

GEOSldas allows to have two parallel installations of the same source code, one in "normal mode" and one in "debug mode". The script [get_build_GEOSldas.bash](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/get_build_GEOSldas.bash) accepts a positional debug argument (executed as "./get_build_GEOSldas debug"), in which case a debug build is created in the directory *./\<your_GEOSldas_root\>/install_debug/*

Debugging GEOSldas is done in two steps:

* The lenkf.j must be executed using the debug flag (csh lenkf.j -debug) in order to carry out the necessary pre-procesing.
* GEOSldas.x must be executed using a debugging tool, on the HPC this is ArmForge.

One caveat is that ArmForge is not available on the 2019b toolchain that is loaded by the g5_modules. Hence, the 2018a toolchain needs to be reloaded, which creates some version changes in the loaded modules, but this has not (yet) caused any issues.

The following steps will get GEOSldas executed in debug mode.

Launch an interactive session, making sure to add the -X flag:

* qsub -I -X -lnodes=1:ppn=36 -A lp_ees_swm_ls_001 -l walltime=24:00:00

Create the run files:

* csh
* cd ./\<your_GEOSldas_root\>/install_debug/bin/
* source g5_modules
* ldas_setup -v \<output_path\> \<exeinp_file\> \<batinp_file\>
* cd \<output_path\>/run

Do the relevant preprocessing:

* csh lenkf.j -debug

Launch the debugger:

* module use /apps/leuven/skylake/2018a/modules/all
* module load ArmForge
* ddt mpirun -np 36 -machinefile $PBS_NODEFILE ../build/bin/GEOSldas.x
