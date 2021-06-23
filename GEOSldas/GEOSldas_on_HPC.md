

# First steps

The GEOSldas source code is available on the NASA GitHub [here](https://github.com/GEOS-ESM/GEOSldas).

To build and run GEOSldas, the so-called Baselibs are required, which are also available on the NASA GitHub [here](https://github.com/GEOS-ESM/ESMA-Baselibs).


## Download/build scripts

The scripts [get_build_baselibs.bash](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/get_build_baselibs.bash) and [get_build_GEOSldas.bash](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/get_build_GEOSldas.bash) automatically download and build the Baselibs and GEOSldas, respectively. They run on both Tier-1 and Tier-2, automatically detecting on which cluster they are executed.

### Baselibs
The Baselibs version 6.1.0 (a note on versions follows below) is pre-built on both Tier-1 and Tier-2. It is generally not necessary (and not advised) to built them again yourself. However, if you want to run a GEOSldas version other than 17.9.3 that requires a Baselibs version other than 6.1.0, you can download and build it using [get_build_baselibs.bash](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/get_build_baselibs.bash) (the installation directory and desired version can be specified within the script). Important to remember, in this case, is that the Baselibs path in the g5_modules file (see below) also needs to be adjusted accordingly.

### GEOSldas
Upon first execution, [get_build_GEOSldas.bash](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/get_build_GEOSldas.bash) both downloads and builds GEOSldas with the version and into the directory specified within the script. If this directory already exists (i.e., upon each subsequent execution), the script deletes and re-builds any pre-existing installation. Doing so is necessary every time you make alterations to the source code.

**IMPORTANT**: GEOSldas does not work out of the box on the HPC. A few source code alterations are necessary, which are available on [our GitHub](https://github.com/KUL-RSDA/GEOSldas/tree/v17.9.3_KUL) on a separate branch that is tied to a specific GEOSldas version (see below). The script [get_build_GEOSldas.bash](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/get_build_GEOSldas.bash) downloads the source code from our GitHub including these changes, that is, you do **not** have to re-implement them yourself when downloading GEOSldas for the first time!

In other words: Downloading GEOSldas from the [NASA GitHub](https://github.com/GEOS-ESM/GEOSldas) does **not** work out of the box on the HPC, downloading it from the [KUL-RSDA GitHub](https://github.com/KUL-RSDA/GEOSldas/tree/v17.9.3_KUL), either manually or using [get_build_baselibs.bash](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/get_build_baselibs.bash), does.


## A note on code versions

The GEOSldas release notes typically mention which Baselibs version was used for building it. Their versions must also match when building them on the HPC. The above-mentioned scripts use GEOSldas version 17.9.3 and Baselibs version 6.1.0.

**IMPORTANT**: [get_build_baselibs.bash](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/get_build_baselibs.bash) downloads a particular code version from the [KUL-RSDA GitHub](https://github.com/KUL-RSDA/GEOSldas/tree/v17.9.3_KUL), assuming that there exists a branch called <version>\_KUL. If you want to download a different GEOSldas version, you need to make sure that a branch exists with the \_KUL suffix, which has all the necessary source code alterations implemented to make it work on the HPC.


## Source code alterations explained

GEOSldas does not work out of the box on the HPC for two reasons:

* The script "g5_modules", which is required to load the correct modules, does not work on the HPC scripts because it is written for the NASA machines.

* The script "lenkf.j", which is created to execute GEOSldas, expects a different ressource manager than the one available on the HPC and contains some (non-essential) pre-processing steps that do not work on the HPC.

The following files need to be altered in order to get it running:

* ./GEOSldas/@env/g5_modules (pre-build) or ./GEOSldas/install/bin/g5_modules (post-build) need to be replaced with the g5_modules found [here](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/altered_source_files/g5_modules).

* ./src/Applications/LDAS_App/lenkf.j.template (pre-build) or ./GEOSldas/install/etc/lenkf.j.template (post-build) need to be replaced with the lenkf.j.template found [here](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/altered_source_files/lenkf.j.template).

* ./src/Applications/LDAS_App/ldas_setup (pre-build) or ./GEOSldas/install/bin/ldas_setup (post-build) need to be replaced with the ldas_setup file found [here](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/altered_source_files/ldas_setup).

**NOTE:** It is always better to change these files in the source folders before building GEOSldas as this will cause the changes to persist in case GEOSldas needs to be built anew.

The changes in a nutshell: *g5_modules* is a very light-weight version of the original one that simply loads the required modules on the HPC and sets some environmental variables (paths). The *lenkf.j.template* has been altered to use the PBS ressource manager instead of SLURM, and the non-functioning pre-processing steps have been outcommented. *ldas_setup* has been altered to correctly use the altered ressource manager specifications.

The exact changes made to the *lenkf.j.template* and *ldas_setup* files can be found [here](https://github.com/KUL-RSDA/GEOSldas/commit/79c6f116ead677b5ee317238023dc4955c30ed8f).

The script *g5_modules* is not part of the GEOSldas GitHub repository and hence copied from */staging/leuven/stg_00024/GEOSldas_libraries/* (Tier-2) or */scratch/leuven/projects/lt1_2020_es_pilot/project_input/rsda/GEOSldas_libraries/* (Tier-1).


# Using GEOSldas

## Building GEOSldas

* Use the script [get_build_GEOSldas.bash](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/get_build_GEOSldas.bash) to download and build GEOSldas (adjust the root path and GEOSldas version as needed)

## Creating the run files

* csh
* cd ./\<your_GEOSldas_root\>/install/bin/
* source g5_modules
* ldas_setup -v \<output_path\> \<exeinp_file\> \<batinp_file\>

## Executing the model

* cd \<output_path\>/run
* qsub lenkf.j (as a batch job)

Instead of qsub, "csh lenkf.j" can be used to run GEOSldas in an interactive session.

**NOTE**: By default, the lenkf.j file is intentionally prohibited from running on our group node (so as to not get launched there accidentally in case the required number of processors is available). If you want to run it on the group node for expirimental purposes anyway, make sure to remove "#PBS -W x=excludenodes=r23i13n23" in line 24.

## A note on the configuration files:

The script "ldas_setup" does all the necessary pre-processing and creates the run scripts that are to be found in \<output_path\>/run.

To do so, it uses the two configuration scripts, \<exeinp_file\> and \<batinp_file\>, templates for which can be found at */staging/leuven/stg_00024/OUTPUT/alexg/data_sets/GEOSldas/config/*. For the generation of ensembles and for data assimilation, special namelist files ("LDASsa_SPECIAL_inputs_\*.nml") are required, templates of which can also be found in the same directory.

**IMPORTANT**: Before submitting the job to run the model (see the next point), the desired output collection needs to be selected in \<output_path\>/run/HISTORY.rc. This script is re-created every time by "ldas_setup" unless the path to a pre-existing HISTORY.rc file is specified expicitly in the \<exeinp_file\>. However, in this case, you still need to **make sure that the experiment ID in this HISTORY.rc matches that of the experiment for which you are using it**.


## Debugging

GEOSldas allows to have two parallel installations of the same source code, one in "normal mode" and one in "debug mode". The script [get_build_GEOSldas.bash](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/get_build_GEOSldas.bash) accepts a positional debug argument: *"./get_build_GEOSldas debug"*, in which case a debug build is created in the directory */\<your_GEOSldas_root\>/install_debug/bin/*

Debugging GEOSldas is done in two parts:

* The lenkf.j must be executed using the debug flag (csh lenkf.j -debug) in order to carry out the necessary pre-procesing.
* GEOSldas.x must be executed using a debugging tool, on the HPC this is ArmForge.

One caveat is that ArmForge is not available on the 2019b toolchain that is loaded by the g5_modules. Hence, the 2018a toolchain needs to be reloaded, which creates some version changes in the loaded modules, but this has not (yet) caused any issues.

The following steps allow you to debug GEOSldas.

Launch an interactive session, making sure to add the -X flag:

* qsub -I -X -lnodes=1:ppn=36 -A lp_ees_swm_ls_001 -l walltime=24:00:00

Creating the run files:

* csh
* cd ./\<your_GEOSldas_root\>/install_debug/bin/
* source g5_modules
* ldas_setup -v \<output_path\> \<exeinp_file\> \<batinp_file\>
* cd \<output_path\>/run

Doing the relevant preprocessing:

* csh lenkf.j -debug

Launching the debugger:

* module use /apps/leuven/skylake/2018a/modules/all
* module load ArmForge
* ddt mpirun -np 36 -machinefile $PBS_NODEFILE ../build/bin/GEOSldas.x
