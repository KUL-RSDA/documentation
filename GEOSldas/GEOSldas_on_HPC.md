

# First steps

## Installation

The GEOSldas source code can be obtained from the NASA GitHub [here](https://github.com/GEOS-ESM/GEOSldas).

To build and run GEOSldas, the so-called Baselibs are required, which are also available on the NASA GitHub [here](https://github.com/GEOS-ESM/ESMA-Baselibs).

The scripts "get_build_baselibs.bash" and "get_build_baselibs.bash" automatically download and build the Baselibs and GEOSldas, respectively. They run on both Tier-1 and Tier-2, automatically detecting  on which cluster they are executed.

## Code versions

The GEOSldas release notes typically mention which Baselibs version was used for building it. These must also match when building them on the HPC. The above-mentioned scripts use GEOSldas version 17.9.3 and Baselibs version 6.1.0.

## Required source code alterations

GEOSldas does not readily run on the HPC for two reasons:

* The script "g5_modules", which is required to load the correct modules, does not work on the HPC scripts because it is written for the NASA machines.

* The script "lenkf.j", which is created to execute GEOSldas expects a different ressource manager than the one available on the HPC.

These issues can be resolved with the following source code alterations:

(TBD)


# GEOSldas in a nutshell

## Baselibs

The Baselibs version 6.1.0 is pre-built on both Tier-1 and Tier-2. It is generally not necessary (and not advised) to built them again yourself. However, if you want to run a GEOSldas version other than 17.9.3 that requires a Baselibs version other than 6.1.0 you can download and build it using the script "get_build_baselibs.bash". In this case, the Baselibs path in "g5_modules" needs to be adjusted accordingly.

## Building GEOSldas

A ready-to-use GEOSldas build is available on staging (/staging/leuven/stg_00024/GEOSldas). If you merely want to run GEOSldas without any source code alterations, you can skip the following and directly jump to the next section "Running GEOSldas".

* Use the script "get_build_GEOSldas.bash" to download and build GEOSldas (adjust the root path and GEOSldas version as needed)

* Move the altered versions of "g5_modules" and "ldas_setup" to ./GEOSldas/install/bin/, and the altered version of "lenkf.j.template" to ./GEOSldas/install/etc/. If you use your own Baselibs build, adjust the path in the g5_modules accordingly.

## Running GEOSldas

The following assumes the use of the ready-to-use GEOSldas build that can be found on staging.

### Creating the run files

* csh

* cd /staging/leuven/stg_00024/GEOSldas/GEOSldas_17.9.3/install/bin/

* source g5_modules

* ldas_setup -v \<output_path\> \<exeinp_file\> \<batinp_file\>

The script "ldas_setup" does all the necessary pre-processing and creates the run scripts that are to be found in \<output_path\>/run. To do so, it requires two configuration scripts, \<exeinp_file\> and \<batinp_file\>, templates for which can be found at /staging/leuven/stg_00024/GEOSldas/config. For the generation of ensembles and for data assimilation, special namelist files are required, templates of which can also be found in the same directory.

*IMPORTANT*: Before submitting the job to run the model (see the next point), the desired output collection needs to be selected in \<output_path\>/run/HISTORY.rc. This script is re-created every time by "ldas_setup" unless the path to a pre-existing HISTORY.rc file is specified expicitly in the \<exeinp_file\>. However, in this case, you still need to make sure that the experiment ID in this HISTORY.rc matches that of the experiment for which you are using it.


### Execute the model

* cd \<output_path\>/run

* qsub lenkf.j

*IMPORTANT*: If you want to submit the lenkf.j file to the group node, the line "#PBS -W x=excludenodes=r23i13n23" needs to be deleted first.
