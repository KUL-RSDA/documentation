
<31/06/2021> : Alexander Gruber> : First version of the documentation, for GEOSldas v17.9.3 and Baselibs v6.1.0

<08/09/2021> : Alexander Gruber> : Updated documentation for GEOSldas v17.9.4 and Baselibs v6.2.4

<14/02/2022> : Alexander Gruber> : Updated documentation for Catchment-CN

<16/03/2022> : Alexander Gruber> : Updated documentation on Baselib versioning and source code alterations

# First steps

The GEOSldas source code is available on the NASA GitHub [here](https://github.com/GEOS-ESM/GEOSldas).

To build and run GEOSldas, the so-called Baselibs are required, which are also available on the NASA GitHub [here](https://github.com/GEOS-ESM/ESMA-Baselibs).


## Download/build scripts

The scripts [get_build_baselibs.bash](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/get_build_baselibs.bash) and [get_build_GEOSldas.bash](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/get_build_GEOSldas.bash) automatically download and build the Baselibs and GEOSldas, respectively. They run on both Tier-1 and Tier-2, automatically detecting on which cluster they are executed.

### Baselibs
Some Baselibs versions (a note on versions follows below) are pre-built on both Tier-1 and Tier-2. It is generally not necessary (and not advised) to built them again yourself. You merely need to source the [g5_modules](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/g5_modules) file in order to use them (a note on that later).

### Finding the correct baselibs version

There are two ways to finding out which Baselibs version is required for the GEOSldas version that you want to run:

* You can check the [release notes](https://github.com/GEOS-ESM/GEOSldas/releases) of the version. Sometimes, but not always, the Baselibs version is mentioned there.

* In the [./components.yaml](https://github.com/GEOS-ESM/GEOSldas/blob/main/components.yaml) file in the root of the [GEOSldas source code directory](https://github.com/GEOS-ESM/GEOSldas), you find a tag to the external `env` package. Then, go to the external [GEOS-ESM/ESMA_env](https://github.com/GEOS-ESM/ESMA_env) repository and look into the [g5_modules](https://github.com/GEOS-ESM/ESMA_env/blob/main/g5_modules) file of the code version with that particular tag. There, the required Baselibs version is set in the `basedir` variable.

### Checking if a baselibs version exists and is built correctly.

The default installation directories for the Baselibs are
* `/scratch/leuven/projects/lt1_2020_es_pilot/project_input/ldas/GEOSldas_libraries` on Tier-1
* `staging/leuven/stg_00024/GEOSldas_libraries` on Tier-2.

Once you know which Baselibs version you need, go in there check whether a directory with the correct version number exists. If it does, go into the `src` subdirectory of the correct version and execute:

`ESMF_COMM=openmpi`  
`make verify`
or
`make install ESMF_COMM=openmpi`

This verifies if all modules have been built correctly, and the output should look as follows:

-------+---------+---------+--------------  
Config | Install |  Check  |   Package  
-------+---------+---------+--------------  
  ok   |   ok    |   --    | antlr2  
  ok   |   ok    |   --    | gsl  
  ok   |   ok    |   --    | jpeg  
  ok   |   ok    |   --    | zlib  
  ok   |   ok    |   --    | szlib  
  ok   |   ok    |   --    | curl  
  ok   |   ok    |   --    | hdf4  
  ok   |   ok    |   --    | hdf5  
  ok   |   ok    |   --    | netcdf  
  ok   |   ok    |   --    | netcdf-fortran  
  ok   |   ok    |   --    | netcdf-cxx4  
  ok   |   ok    |   --    | udunits2  
  ok   |   ok    |   --    | nco  
  ok   |   ok    |   --    | cdo  
  ok   |   ok    |   --    | nccmp  
  ok   |   ok    |   --    | esmf  
  ok   |   ok    |   --    | gFTL  
  ok   |   ok    |   --    | gFTL-shared  
  ok   |   ok    |   --    | fArgParse  
  ok   |   ok    |   --    | pFUnit  
  ok   |   ok    |   --    | yaFyaml  
  ok   |   ok    |   --    | pFlogger  
  ok   |   ok    |   --    | FLAP  
  ok   |   ok    |   --    | hdfeos  
  ok   |   ok    |   --    | hdfeos5  
  ok   |   ok    |   --    | SDPToolkit  
-------+---------+---------+--------------  

If it does, great, you can use them. If not, see the section on troubleshooting below


#### Bulding a new baselibs version.
If you want to run a GEOSldas version that requires a Baselibs version that does not exist already, you can download and build it using [get_build_baselibs.bash](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/get_build_baselibs.bash). The installation directory and desired version can be specified within the script. Important to remember, in this case, is that the Baselibs path in the [g5_modules](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/g5_modules) file (see below) also needs to be adjusted accordingly.

**NOTE:** If you build a new baselibs version, best do it for everyone in the two default directories for Tier-1 (`/scratch/leuven/projects/lt1_2020_es_pilot/project_input/ldas/GEOSldas_libraries`) and Tier-2 (`/staging/leuven/stg_00024/GEOSldas_libraries`).

**NOTE:** The Baselibs repository on GitHub allows to be cloned with external submodules. However, there were some issues with remote path changes in the external submodule repositories (i.e., downloads failed). Therefore, the [get_build_baselibs.bash](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/get_build_baselibs.bash) script downloads the complete tarballs.


#### Troubleshooting

The [get_build_baselibs.bash](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/get_build_baselibs.bash) in the beginning loads a specific tool chain and some modules on the HPC required to build the Baselibs.

If the `make verify` command does not produce the output shown above, there is usually an issue with these modules. This usually happens when you install a new Baselibs version that requires newer module versions.

For [baselibs versions](https://github.com/GEOS-ESM/ESMA-Baselibs/releases) later than v6.2.8 there might be missing subdirectories in the [FLAP package](https://github.com/mathomp4/FLAP). This can be fixed by adding a line in the [get_build_baselibs.bash](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/get_build_baselibs.bash) script:

```
cd $root/ESMA-Baselibs-v${version}
**cp -r $root/ESMA-Baselibs-v6.2.8/src/FLAP/src/third_party $root/ESMA-Baselibs-v${version}/FLAP/src**
mkdir Linux
```
where your root is where v6.2.8 is already installed.

Since we don't have rights to fiddle with the HPC modules, there is not really a point in trying to fix this issue yourself. Therefore, best ask Alexander Vapiev (*alexander.vapirev@kuleuven.be*) from the HPC team to help you with getting that baselibs version installed.

Best drop him an email with the Baselibs version that you want to install, more specifically to the tarball link, and also mention which modules specifically you tried to install it with and provide the  `make verify` output so that he knows what might give the issue.


### GEOSldas
Upon first execution, [get_build_GEOSldas.bash](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/get_build_GEOSldas.bash) both downloads and builds GEOSldas with the version and into the directory specified within the script. You should hence change the path to the location where you want to install it (a note on code versions follows below). If the specified directory already exists (i.e., upon each subsequent execution), the script deletes and re-builds any pre-existing installation. Doing so is necessary every time you make alterations to the source code.

**IMPORTANT:** On Tier-1, GEOSldas builds are not compatible on both skylake and broadwell nodes. If you want to run GEOSldas on skylake, it needs to be compiled on skylake, and the same for broadwell (more on that in the section "Using GEOSldas")

**IMPORTANT:** GEOSldas does not work out of the box on the HPC. A few source code alterations are necessary, which are available on [our GitHub](https://github.com/KUL-RSDA/GEOSldas/tree/v17.9.4_KUL) on a separate branch that is tied to a specific GEOSldas version (see below). The script [get_build_GEOSldas.bash](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/get_build_GEOSldas.bash) downloads the source code **from our GitHub including these changes**, that is, you don't have to re-implement them yourself when downloading GEOSldas for the first time. In other words: Downloading GEOSldas from the [NASA GitHub](https://github.com/GEOS-ESM/GEOSldas) does not work out of the box on the HPC, but downloading it from the [KUL-RSDA GitHub](https://github.com/KUL-RSDA/GEOSldas/tree/v17.9.4_KUL), either manually or using [get_build_GEOSldas.bash](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/get_build_GEOSldas.bash), does.

**IMPORTANT #2:** GEOSldas (and hence the [get_build_GEOSldas.bash](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/get_build_GEOSldas.bash) script) requires [mepo](https://github.com/GEOS-ESM/mepo), which is a wrapper around git to download various external sub-repositories. It is sufficient to just dowload or clone [mepo](https://github.com/GEOS-ESM/mepo) onto your machine, but the mepo directory needs to be added to the PATH environmental variable (best done in the .bashrc for future use).

**IMPORTANT #3:** [mepo](https://github.com/GEOS-ESM/mepo) pulls modules from the git remote repository named "origin", which needs to be the [GEOS-ESM](https://github.com/GEOS-ESM/GEOSldas.git). Hence, even though [get_build_GEOSldas.bash](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/get_build_GEOSldas.bash) pulls the source code from the [KUL-RSDA GitHub](https://github.com/KUL-RSDA/GEOSldas/tree/v17.9.4_KUL), the remotes are slightly altered. Keep this in mind should you want to work on your own GitHub fork!

## A note on code versions

The GEOSldas [release notes](https://github.com/GEOS-ESM/GEOSldas/releases) typically mention which Baselibs version was used for building it (see above). Their versions must also match when building them on the HPC. The above-mentioned scripts use GEOSldas version 17.9.4 and Baselibs version 6.2.4.

**IMPORTANT**: [get_build_GEOSldas.bash](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/get_build_GEOSldas.bash) downloads a particular code version from the [KUL-RSDA GitHub](https://github.com/KUL-RSDA/GEOSldas/tree/v17.9.4_KUL), assuming that there exists a branch called \<version\>\_KUL. If you want to download a different GEOSldas version, you need to make sure that a branch exists with the \_KUL suffix, which has all the necessary source code alterations implemented to make it work on the HPC.


## Source code alterations explained

GEOSldas does not work out of the box on the HPC for two reasons:

* The [g5_modules](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/g5_modules) script, which is required to load the correct modules, does not work on the HPC scripts because it is written for the NASA machines.

* The [lenkf.j](https://github.com/GEOS-ESM/GEOSldas/blob/main/src/Applications/LDAS_App/lenkf.j.template) script, which is created to execute GEOSldas, expects a different ressource manager than the one available on the HPC and contains some (non-essential) pre-processing steps that do not work on the HPC.

To following changes have been made to get GEOSldas running on the HPC:

* A light-weight version of the [g5_modules](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/g5_modules) has been created that merely loads the right modules and sets the right environmental variables.

* The [lenkf.j.template](https://github.com/KUL-RSDA/GEOSldas/blob/v17.9.4_KUL/src/Applications/LDAS_App/lenkf.j.template) file has been altered to use the PBS ressource manager instead of SLURM, the NCO module version has been changed, and some non-mandatory pre-processing has been commented out.

* The [ldas_setup](https://github.com/KUL-RSDA/GEOSldas/blob/v17.9.4_KUL/src/Applications/LDAS_App/ldas_setup) script has been altered to use the modified [lenkf.j.template](https://github.com/KUL-RSDA/GEOSldas/blob/v17.9.4_KUL/src/Applications/LDAS_App/lenkf.j.template) correctly.

* **Only for running Catchment-CN**: Hardcoded paths to CO2 and FPAR parameter files (*CO2_MonthlyMean_DiurnalCycle.nc4* and *FPAR_CDF_Params-M09.nc4*) that are set in the [lenkf.j.template](https://github.com/KUL-RSDA/GEOSldas/blob/v17.9.4_KUL/src/Applications/LDAS_App/lenkf.j.template) file need to be changed from NASA machine locations to the correct locations on the HPC.

The exact changes made to the [lenkf.j.template](https://github.com/KUL-RSDA/GEOSldas/blob/v17.9.4_KUL/src/Applications/LDAS_App/lenkf.j.template) and to [ldas_setup](https://github.com/KUL-RSDA/GEOSldas/blob/v17.9.4_KUL/src/Applications/LDAS_App/ldas_setup) can be found in the commit history [here](https://github.com/KUL-RSDA/GEOSldas/commit/26ac6b24626ee7b45b198751332f1267cae75a1c).

**TODO:** The commit mentioned above includes some removed trailing blanks, which makes it quite tedious to find the actually relevant changes... Whoever next implements the correct changes for another GEOSldas version and pushes it as a *_KUL branch should best make sure that trailing blanks are preserved and change the reference above to this new 'clean' commit.  

**NOTE:** The [g5_modules](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/g5_modules) script is not part of the GEOSldas GitHub repository and hence copied by [get_build_GEOSldas.bash](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/get_build_GEOSldas.bash) from `/staging/leuven/stg_00024/GEOSldas_libraries/` (Tier-2) or `/scratch/leuven/projects/lt1_2020_es_pilot/project_input/rsda/GEOSldas_libraries/` (Tier-1).

As mentioned, the [get_build_GEOSldas.bash](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/get_build_GEOSldas.bash) script downloads a modified version of GEOSldas from our [KUL-RSDA GitHub](https://github.com/KUL-RSDA/GEOSldas/tree/v17.9.4_KUL), which already includes all these changes. The above is thus merely an FYI.

**NOTE:** GEOSldas v17.9.4 did not install with the above-mentioned source code changes due to a bug in the external ESMA_cmake repository that is downloaded by mepo. The fix has been pushed as v3.5.5 (see [here](https://github.com/GEOS-ESM/ESMA_cmake/pull/203)). Accordingly, this version needed to be updated in the components.yaml file of the v17.9.4_KUL branch. This fix is only necessary for this version and will become obsolete with the next official GEOSldas release!

# Using GEOSldas

## Installation

Use the script [get_build_GEOSldas.bash](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/build_scripts/get_build_GEOSldas.bash) to download and build GEOSldas (adjust the root path and GEOSldas version as needed). When altering the source code, you can simply re-run the script in order to re-build your installation.

**IMPORTANT:** On Tier-1, GEOSldas builds are not compatible on both skylake and broadwell nodes. If you want to run GEOSldas on skylake, it needs to be compiled on skylake, and the same for broadwell. The corect node thus needs to be specified in the job submission parameters!

## Creating the run files

* csh
* cd ./\<your_GEOSldas_root\>/install/bin/
* source g5_modules
* ./ldas_setup setup -v \<output_path\> \<exeinp_file\> \<batinp_file\>

## Specifying the output collection

Before submitting the job to run the model (see the next step), the desired output collection needs to be selected in **\<output_path\>/run/HISTORY.rc**. This file is **re-created every time** by [ldas_setup](https://github.com/KUL-RSDA/GEOSldas/blob/v17.9.4_KUL/src/Applications/LDAS_App/ldas_setup) unless the path to a pre-existing HISTORY.rc file is specified explicitly in the \<exeinp_file\>. However, in this case, you still need to **make sure that the experiment ID in this HISTORY.rc matches that of the experiment for which you are using it**.

## Executing the model

* cd \<output_path\>/run
* qsub lenkf.j (as a batch job)

Instead of qsub, "csh lenkf.j" can be used to run GEOSldas in an interactive session.

**NOTE**: By default, the lenkf.j file is intentionally prohibited from running on our group node (so as to not get launched there accidentally in case the required number of processors is available). If you want to run it on the group node for expirimental purposes anyway, make sure to remove "#PBS -W x=excludenodes=r23i13n23" in line 24 (and make sure not to use too many cores).

**NOTE:** Since the run needs to be executed on the same node type (skylake/broadwell) for which it has been compiled (see above), the correct nodetype needs to be specified in the resource parameters of the lenkf.j file! For v17.11.0, "skylake" is automatically added since this is the recommended node type to run on.

## Configuration file templates

Templates for the *\<exeinp_file\>* and *\<batinp_file\>* configuration files, which are used by [ldas_setup](https://github.com/KUL-RSDA/GEOSldas/blob/v17.9.4_KUL/src/Applications/LDAS_App/ldas_setup) to do the relevant pre-processing and to create the run scripts, can be found at */staging/leuven/stg_00024/OUTPUT/alexg/GEOSldas/config/*.

Separate templates are available for running the regular CLSM and for running Catchment-CN.

For the generation of ensembles and for data assimilation, special namelist files ("LDASsa_SPECIAL_inputs_\*.nml") are required, templates of which can be found in the same directory.

## Boundary conditions

Model parameter sets, also referred to as boundary conditions (BCS) need to be provided when running GEOSldas. Paths to these BCS are specified in the configuration files, and several versions are available. An explanation of BCS versions can be found [here](https://github.com/GEOS-ESM/GEOSldas/blob/main/doc/README.MetForcing_and_BCS.md).

Two sets of BCS sets can be found on the HPC at */staging/leuven/stg_00024/l_data/model_param/geos5/bcs/*:

* **Icarus-NLv4**: These are the BCS recommended when running the **regular CLSM**.
* **NLv5**: These are the BCS recommended when running the **northern PEATCLSM**.
* **NLv5_TN**: These are the BCS recommended when running the **natural tropical PEATCLSM**.
* **NLv5_TD**: These are the BCS recommended when running the **drained tropical PEATCLSM**.

* **Heracles_NL_bcs_new**: These are recommended when running **Catchment-CN**. Although they are quite old, thery are still the only science-validated BCS for Catchment-CN, and creating restarts for Catchment-CN with a newer BCS set would require extremely long spin-up times (contact Rolf Reichle for questions on that).

Each of these BCS sets contains two separate subfolders: one for the M09 grid and one for the M36 grid. **The choice of the BCS resolution determines at which resolution GEOSldas will run!**

**IMPORTANT when running Catchment-CN**: Catchment-CN requires two additional BCS files (*CO2_MonthlyMean_DiurnalCycle.nc4* and *FPAR_CDF_Params-M09.nc4*). These files can be found at */staging/leuven/stg_00024/OUTPUT/alexg/GEOSldas/CLSM_params/*. The paths to these files are **currently hardcoded** in the [lenkf.j.template](https://github.com/KUL-RSDA/GEOSldas/blob/v17.9.4_KUL/src/Applications/LDAS_App/lenkf.j.template) and need to be adjusted accordingly before compiling GEOSldas (see above).

### A note on coldstarts with GEOSldas

Completely cold-starting GEOSldas (RESTART:0 in exeinput file) is not recommended, however, it can be done using the restart file at */staging/leuven/stg_00024/l_data/model_param/geos5/input_coldstart_RESTART0/* and combining it with the preferred BCs. This will generate a new a coldstart restart file that requires long spinups. It is recommended to remap a GEOSldas restart file (RESTART:2 in exeinput file) by using a restart file from older BCs (e.g.: the spniup with Icarus-NLv4 BCS at */staging/leuven/stg_00024/OUTPUT/alexg/GEOSldas/*) and remap to the required BCs. This will require regular spinup-times (usually 20-30 years are sufficient when starting from existing restarts). 

Changes to process_rst.csh (and possibly mk_GEOSldasRestarts.F90) file(s) might be necessary to get these restart options to work on the KU Leuven structure and your specific account.

### A note on spinning up GEOSldas

Both deterministic and ensemble spinup runs of the CLSM using the Icarus-NLv4 BCS can be found at */staging/leuven/stg_00024/OUTPUT/alexg/GEOSldas/*. Restart files for the Catchment-CN using the Heracles_NL_bcs_new BCS can also be found there.


### A note on GEOSldas configuration issues on the HPC

The *exeinp* file contains the parameters *JOB_SGMT* and *NUM_SGMT*. *JOB_SGMT* determines how long a time period shall be processed (e.g., ten days, three months, a year, ...) and restart files will be written at the end of this period. *NUM_SGMT* determines how many of these segments will be procesed consecutively by the submitted job. If the specified *END_DATE* is not reached, the lenkf.j resubmits itself automatically and continues processing the next *NUM_SGMT* segments until *END_DATE* is reached.

These two parameters are optional. If omitted, GEOSldas will process the job as a single segment covering the the period END_DATE - START_DATE. This functionality was introduced in GEOSldas to avoid jobs running into wall time issues. However, two problems associated with it have been found on the KU Leuven HPC system:

1) For an unknown reason, the lenkf.j file does resubmit itself correctly, but the resubmitted job does not get processed. Since we do not have strict wall time limitations, however, this does not really concern us and most jobs can be processed in one submission. If not, the lenkf.j file can be resubmitted manually to continue processing (see the section "Continuing a job").

2) Processing larger segments of multiple years (e.g., when omitting the *JOB_SGMT* and *NUM_SGMT* parameters) caused the jobs to crash for an unknown reason (pressumably because too many, i.e., tens of thousands, temporary files are written into the scratch directory which the system cannot handle, although this is not confirmed by the HPC team and has not been a problem on the NASA machines). Therefore, it is recommended to always run processes in yearly segments (smaller segments are possible but create more overhead, so only do that if you need restart files to be written out more frequenlty). Just make sure that *NUM_SGMT* is set to a high enough number to cover your entire job period (it is not an issue if it is too large as GEOSldas will always stop once all data up until *END_DATE* have been processed).

## Continuing a job

Continuing a GEOSldas job is very easy because the end date of a finished job is stored in a "*./run/cap_restart*" file, and (re)submitting the lenkf.j file will always execute GEOSldas from the date specified in this file. You may want to continue a job for two reasons:

1) The processing cannot done within the allowed wall time limit.

A submitted lenkf.j file processes data for (*JOB_SGMT* * *NUM_SGMT*) time units starting from *BEG_DATE*. If *BEG_DATE* + (*JOB_SGMT* * *NUM_SGMT*) does not reach (or exceed) the *END_DATE*, the job will stop after the set number of segments.

In this case, the lenkf.j file can simply be re-submitted without any alterations in the configuration files, and will get GEOSldas to continue processing for another *NUM_SGMT* segments (but only until *END_DATE* is reached).

2) You want to extend the time period of your GEOSldas run because new forcing or satellite data has become available.

When running *ldas_setup*, the file "*./run/CAP.rc*" is created, and the lenkf.j file actually grabs the *END_DATE* from this file. If this entry is manually alterered, the lenkf.j file will simply consider this newly set *END_DATE* instead the one that was specified originally in the *exeinp* file.

That is, if you want to extend your run, simply extend the *END_DATE* in the *./run/CAP.rc* file and resubmit the lenkf.j file. There is no need to re-run ldas_setup!


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

## Working with specific branches

### PEATCLSM (documentation needs to be extended):

https://github.com/GEOS-ESM/GEOSldas/tree/feature/SM_peatCLM

https://github.com/GEOS-ESM/GEOSgcm_GridComp/tree/feature/SM_peatCLM3/GEOSagcm_GridComp/GEOSphysics_GridComp/GEOSsurface_GridComp/GEOSland_GridComp
