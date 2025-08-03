
Compile and run NASA's Land Information System Framework (LISF) on the HPC at KU Leuven
==

    Authors:
        Gabriëlle De Lannoy with RSDA team
        contact: gabrielle.delannoy@kuleuven.be 

Acknowledgement: This work was supported by the VSC HPC Team of the KU
Leuven.

Background information
======================

This document describes how to install and run NASA's LISF
on the KU Leuven [Tier-1](https://vlaams-supercomputing-centrum-vscdocumentation.readthedocs-hosted.com/en/latest/leuven/tier1_hardware/breniac_hardware.html) and [Tier-2](https://vlaams-supercomputing-centrum-vscdocumentation.readthedocs-hosted.com/en/latest/leuven/tier2_hardware.html) cluster.

This document assumes the user has basic knowledge of the HPC, see 'Getting started on the HPC' documentation.

-   LISF source code is available on the KUL-RSDA github as a fork of the NASA LISF repository
    <https://github.com/KUL-RSDA/LISF>

-   The master branch is kept up-to-date with the NASA version.

-   In the RSDA fork of LISF, there are several feature branches:
-   a) compilation branch that includes all changes needed to get LISF compiled on the VSC HPC (Tier-1 Hortense and Tier-2 Genius and wICE) 
-   b) model developments that are supposed to be sent to NASA after publication with a testcase
-   c) bug fixes that are supposed to be sent to NASA with a testcase
-   d) KUL-RSDA specific options that are not planned to be sent to NASA


The LISF framework has three components:

-   The Land Information System (LIS) is the main system, including
    different land surface models (LSM) and data assimilation (DA) tools. You
    will use LIS to run LSMs and assimilate satellite data into your
    models.

-   The Land Data Toolkit (LDT) is the program you have to run before
    running LIS. LIS requires input data such as elevation, soil maps,
    landcover maps, vegetation data,\... LDT allows you to homogenize
    your input data (which are originally in different data formats)
    into one netcdf-file containing different input layers, all with the
    same spatial extent and spatial resolution. This netcdf-file is loaded in LIS for the simulations.

-   The Land Verification Toolbox (LVT) (not used in RSDA group, instead use of own python-based 'pylis': https://github.com/KUL-RSDA/pylis/) The Land Verification Toolbox (LVT) is a program which can be used
    to analyze your output data. For example, you have soil moisture
    output from three LSMs in LIS and you want to evaluate that output
    with SMOS and SMAP data. LVT facilitate such an analysis and enables
    the calculation of different evaluation metrices. 

To get used to the different programs it is advised to run the different
testcases which are available on the LIS-website
(<https://lis.gsfc.nasa.gov/tests>) and in the public test cases
directories, within the LIS source code, inside the testcases/public
directory path. There are good users' guides available for all three
components: [LIS users'
guide](https://modelingguru.nasa.gov/servlet/JiveServlet/downloadBody/2634-102-4-6543/LIS_usersguide.pdf),
[LDT users'
guide](https://modelingguru.nasa.gov/servlet/JiveServlet/downloadBody/2635-102-3-6535/LDT_usersguide.pdf),
[LVT users'
guide](https://modelingguru.nasa.gov/servlet/JiveServlet/downloadBody/2636-102-1-6534/LVT_usersguide.pdf).

LIS and LDT compilation {#sec:compilation}
=======================

The original LISF code from NASA cannot be directly compiled on the HPC of the VSC. However, the [compilation](https://github.com/KUL-RSDA/LISF/blob/compilation) branch of our LISF repository includes all changes to compile LISF on Tier-1 Hortense and Tier-2 genius and wICE. The compilation is only one command that needs to be executed in the source code directory. See related [README](https://github.com/KUL-RSDA/LISF/blob/compilation/RSDA_README)
For compilation, ask either an interactive node or use the option of submitting the compilation as job. 

Note: During model development, compilation will often crash. To save time, use the same interactive node in which the modules are already loaded and recompile with
E.g. for 8 cores: $ ./compile -j 8

After compilation, the relevant executables are LIS and LDT, which can
be run as discussed in section [3](#sec:run){reference-type="ref"
reference="sec:run"}.


Cleaning before new compilation
-------------------------------

If there are fundamental changes to the code like new dependencies and new files, it is recommended to clean compiled files. This can be done by using the following commands:

    $ cd make && make realclean && make clean && cd ../..

Afterwards, start the compilation from scratch using the easybuild command, see [README](https://github.com/KUL-RSDA/LISF/blob/compilation/RSDA_README). 



# 🛠️ Building Your Own LISF Code

<img src="https://github.com/user-attachments/assets/8c05cc28-045d-438f-a1ff-13814f74cfb3" width="300" align="right" />

This guide walks you through the process of creating your own version of the [LISF repository](https://github.com/KUL-RSDA/LISF).

---

## 1. Fork and Clone the Repository

1. **Fork** the original repo to your GitHub account.
2. **Clone** your fork:

   ```bash
   git clone https://github.com/<your_username>/LISF
   cd LISF
   ```

3. **Add the upstream (original) repository**:

   ```bash
   git remote add upstream https://github.com/KUL-RSDA/LISF.git
   ```

4. *(Optional)* If using SSH:

   ```bash
   git remote set-url upstream git@github.com:KUL-RSDA/LISF.git
   ```

---

## 2. Sync with Upstream

Make sure your local repo is up to date with the latest changes from the original repository.

```bash
git fetch upstream
git checkout master
git merge upstream/master
```

---

## 3. Create a Working Branch

To start working on your version of LISF:

```bash
git checkout -b working/<name_of_lis_version>
```

---

## 4. Merge Required Branches

Pull in selected branches from upstream as needed:

```bash
git merge upstream/compilation
git merge upstream/kul_options
```

### Optional (Depending on Use Case)

```bash
git merge upstream/kul_options_SMAP_vegetation_flag
git merge upstream/kul_options_sm_da_options
git merge upstream/feature_NASA/S1_DA
```

---

## 5. Merge Fixes (Optional)

If necessary, merge specific fix branches:

```bash
git merge upstream/fix/stripe_issues_map_utils
git merge upstream/fix/writeout_bug_multiDAinst
```

---

## ✅ All Set!

Your working LISF version is now ready for customization, development, or compilation.

---

## 💡 Tip

To keep your fork clean and synced, regularly do:

```bash
git fetch upstream
git merge upstream/master
```

---

## 📎 Resources

- [LISF GitHub Repository](https://github.com/KUL-RSDA/LISF)
- [GitHub Docs: Working with Forks](https://docs.github.com/en/get-started/quickstart/fork-a-repo)



Water Cloud Model (WCM) (to be updated and integrated into easybuild)
---------
The Water Cloud Model (WCM) was coupled with the Noah-MP.v.3.6. The following changes are needed for the configuration and compilation of the WCM in LIS:
* Step1. CRTM profile utility needs to be manually installed by navigating to the directory *LISF/lis/lib/lis-crtm-profile-utility* and executing the command:
```
    gmake && make install 
```    
This step allows to define the use of the Radiative Transfer Models (RTMs) in LIS and, consequently, to configure and compile a RTM.
* Step 2. Add the compiled CRTM libraries location in the KUL_LIS_MODULES. Open the KUL_LIS_MODULES and set the environmental variable (an empty definition already exists in the file and needs to be filled with the correct location):
```
    export LIS_CRTM_PROF=$LIS_SRC/lib/lis-crtm-profile-utility
```
where *$(directory)* is your directory with the compiled CRTM profile
* Step3. some plugins need to be toggle off (additionally to CABLE) in the *user.cfg* file in the *lis/make* directory: 
```
    CRTM off
    CMEM off 
    CRTM2 off
    CRTM2EM off
```
As we have activated all the RTMs, during the compilation LIS will fail for missing libraries related to those plugins if we don’t switch off them.
* Step 4. Source the modified KUL_LIS_MODULES and start the configuration:
```
    $ source KUL_LIS_modules
    $ ./configure
```
A new flag was added for the WCM
```
    Use LIS-WCM? (1-yes, 0-no, default=0): 
```
The default value is zero, which means we do not want to use the WCM; otherwise, we will use the flag *“1”*
* Step 5. The compilation does not need specific edits:
```
    $ ./compile
```

/
LIS and LDT runs {#sec:run}
================

General
-------

When preparing a LIS simulation experiment, do not copy executables, modules, input folders, etc. into the experiment directory but work with links to save storage.
e.g.:

-   `$ ln -s path_to_LIS/LIS my_WORKDIR/LIS`

Before submitting a job, the libraries and
environment variables need to be sourced (load_modules and the modules directory are part of the compilation branch):

    $ source load_modules

Secondly, prepare your `lis.config`-file for your application. Third,
also add or link forcing variables list file, the netcdf-file created with LDT,
model-specific input files, model output attribute file, and optionally a
restart-file unless you start the simulation with a coldstart (spin up period). Define the path to each specific file in the
configuration file. 

Run a job on an interactive node (for testing)
----------------------------------------------

Get the interactive nodes and run your case:

    $ source load_modules
    $ ulimit -s unlimited  # to give your job all stack memory it needs
    $ ./LIS lis.config (single core)
    $ mpirun -np N ./LIS lis.config (N cores)

with N the number of processors for parallel computing.

Run a job in the queue
----------------------

Create a slurm script (\$ vim LIS.slurm) and submit it:

Example for a LIS run
    ----------------------------------------------------------
    #!/bin/bash

    #SBATCH -t 23:59:59
    #SBATCH --nodes=1
    #SBATCH --ntasks-per-node=4
    #SBATCH --cluster=wice
    #SBATCH --account lp_ees_swm_ls_002
    #SBATCH --mail-type BEGIN,END,FAIL
    #SBATCH --mail-user firstname.lastname@kuleuven.be
    #SBATCH -o logs/LIS_log.txt
    #SBATCH -e logs/LIS_err.txt

    cd $SLURM_SUBMIT_DIR
    source load_modules
    ulimit -s unlimited
    mpirun -np 4 ./LIS lis.config
    ----------------------------------------------------------


ArmForge ddt debugger
---------------------------
<img src="https://github.com/KUL-RSDA/documentation/assets/93274177/1a3e941d-f763-42ba-ac4c-e3d032a9d7f7" width="350" align="right">

**Tier 2 wICE**

This is based on the new compilation toolchain (developed by Sam)
To open the ddt debugger:

    $ module load ArmForge
    $ source load_modules
    $ ddt
*Note that it is important to first load ArmForge and then the modules to avoid conflicts in the C compiler*

  
Click on Run and follow the example screenshot: 
1. path to executable
2. lis.config file to be run
3. working directory
4. select MPI
5. under mpiexec.hydra arguments add `-genv I_MPI_PIN_RESPECT_CPUSET=0`

alternatively:
5. under mpiexec.hydra arguments add: `-genv I_MPI_PIN_RESPECT_CPUSET=0 -genv I_MPI_HYDRA_BOOTSTRAP=ssh`
6. Do select MPI AND OpenMP.

**Tier 2 Genius**

To open the ddt debugger:

    $ module load ArmForge
    $ source load_modules
    $ ddt
  
Click on Run and follow the example screenshot: 
1. path to executable
2. lis.config file to be run
3. working directory
4. select MPI
5. under mpiexec.hydra arguments add `-genv I_MPI_PIN_RESPECT_CPUSET=0 -genv I_MPI_HYDRA_BOOTSTRAP=ssh -genv LD_PRELOAD=/apps/leuven/rocky8/skylake/2018a/software/impi/2018.1.163-iccifort-2018.1.163-GCC-6.4.0-2.28/lib64/strtok_proxy.so`

**Tier 1 Hortense**

To open the ddt debugger (this only works on cpu_milan_rhel9):

    $ module load ArmForge/22.1.2
    $ source load_modules
    $ module use /readonly/$VSC_SCRATCH_PROJECTS_BASE/2022_200/easybuild/modules/all
    $ ddt
  
Do not select MPI but OpenMP instead

**Debugging of job with multiple nodes Tier 2 GENIUS**

* submit batch job that gets stuck. When it got stuck:
* ssh to one of its compute nodes
* source load_modules
* load a compatible GDB module (same intel toolchain, no worries if python version conflicts and different version is reloaded)

Write out all backtrace output of each process into files:

    $ for pid in $(pgrep -f LIS); do
    $ echo "Getting backtrace for PID $pid..."
    $ gdb -p $pid -batch -ex "set pagination off" -ex "thread apply all bt" > backtrace_$pid.txt
    $ done
  
**May also work with DDT but not for every case**

* srun --x11 ... for a job with two nodes
* create file hosts.txt with two lines and the names of the two nodes
* start GUI of ddt as usual and provide in ddt the file with the known hosts in the mpi details  

**Other available debugging options if ddt fails**
* MUST tool: https://www.i12.rwth-aachen.de/go/id/nrbe (see also https://gjbex.github.io/Defensive_programming_and_debugging/Taxonomy/data_races_deadlocks/)
  
./ldt.config
------------

In the configuration file, you have to define which model you will run,
over which domain and on which resolution, for example, in this case,
the models were run over a region in South America with a resolution of
0.125$^\mathrm{o}$.

    #LIS domain: (see LDT Users' Guide for other projection information)
    Map projection of the LIS domain:   latlon
    Run domain lower left lat:        -33.9375
    Run domain lower left lon:        -67.9375
    Run domain upper right lat:       -16.0625
    Run domain upper right lon:       -57.0625
    Run domain resolution (dx):          0.125
    Run domain resolution (dy):          0.125

However, our original input data will not have the same resolution and
spatial extent. Therefore, we use LDT to rescale the resolution and
extract the area of interest. By defining the original resolution and
spatial extent, LDT has enough information to rescale and extract the
area of interested for every input layer. You have to define the path of
your input layer (in the example below, an albedo-map), its original
spatial extent and resolution. For more information on every parameter,
you can check the userguide of LDT.

    #Albedo maps
    Albedo data source:       NCEP_LIS
    Albedo map:          /scratch/leuven.320/vsc32041/input/input/PAR/UMD/1KM/albedo_NCEP
    Albedo climatology interval:  "monthly"  #monthly | quarterly
    Albedo fill option:         average   #none | neighbor | average
    Albedo fill radius:           20      #number of pixels to search for neighbor
    Albedo fill value:             0.14   #static value to fill where missing 
    Albedo spatial transform:   average   #none | neighbor | bilinear | budget-bilinear
    Albedo map projection:          latlon
    Albedo lower left lat:         -59.995
    Albedo lower left lon:        -179.995
    Albedo upper right lat:         89.995
    Albedo upper right lon:        179.995
    Albedo resolution (dx):          0.01
    Albedo resolution (dy):          0.01

The output path where the netcdf-file will be stored is defined as
follows:

    Processed LSM parameter filename: /scratch/leuven.320/vsc32041/Noah/LDT_files/
                                                             lis.input_clim_1992.nc

Sprinkler Irrigation - preprocessing input data in LDT
------------
This section contains specifications to generate the lis_input.nc file containing irrigation information (for now only checked for Noah-MP.v.3.6):
* An irrigation fraction map is needed to assign a percentage fraction of irrigation to each grid cell. The 500m spatial resolution Global Rainfed and Paddy Croplands [GRIPC] by Salmon et al. (2013) can be found on:
```
    /staging/leuven/stg_00024/l_data/model_param/LIS_parameters/irrigation/global_gripc
```
Specifications to be used in the ldt.config file are:
```
    Irrigation fraction data source:"GRIPC"
    Irrigation fraction map: ./YourDir/Irrigation/global_gripc/irrigtype_salmon2013.flt
    Irrigation fraction spatial transform: average
```
*Irrigation fraction spatial transform* specification can be adjusted based on the user needs as it depends on the spatial resolution that we want to perform (for more information you can refer to the LDT user manual or to Kristi Arsenault - NASA).
* Additionally, crop information is also needed. There are two possible options: 
1) Setting the area to a single crop type, which bypasses the need for a map. This method is based on the CROPMAP classification libraries by Ozdogan et al. (2010). This   option will provide the index values in the same order and classes as what is found in Ozdogan et al. (2010) but will work with a vegetation class rooting depth table, which will include both the landcover dataset and crop classes. In this case a crop inventory for the Ozdogan CROPMAP classification (including 19 crop classes) is needed and it can be found on:
```
    /staging/leuven/stg_00024/l_data/model_param/LIS_parameters/irrigation/crop_params/Crop.Library.Files
```
Specifications in the ldt.config file for option 1 are:
```
    #Crop-Irrigation parameters inputs
    Incorporate crop information:.true.
    Crop type data source: "CONSTANT"
    Crop classification: "CROPMAP"
    Crop library directory: ./YourDir/Irrigation/crop_params/Crop.Library.Files/
    Assign crop value type: "single"
    Assign single crop value: .true.
    Default crop type: "maize" #you can select between different crops provided in the inventory
    Crop map spatial transform: mode
```
*Crop map spatial transform* specification depends on the spatial resolution used. This example is related to a spatial resolution of 0.01° (for more information on that you can refer to the LDT user manual or to Kristi Arsenault-NASA).

2) Providing a crop map for the study area, based on the work by Monfreda 2008. Crop maps are located in:
```
    /staging/leuven/stg_00024/l_data/model_param/LIS_parameters/irrigation/crop_params/Monfreda_175Crops
```
Additionally, crop libraries, which connect the crop information with the maximum root depth of the plant, are available on:
```
     /staging/leuven/stg_00024/l_data/model_param/LIS_parameters/irrigation/crop_params/Crop.Library.Files
```
Specifications needed in the ldt.config file to run this second option are:
```
    #Crop-Irrigation parameters inputs
    Incorporate crop information:.true.
    Crop type data source: "Monfreda08"
    Crop classification: "FAOSTAT05"
    Crop library directory: ./YourDir/irrigation/crop_params/Crop.Library.Files/
    Assign crop value type: "none"
    Assign single crop value:.false.
    Default crop type: "none"
    Crop type file:./YourDir/irrigation/crop_params/Monfreda_175Crops/Crops/
    Crop map spatial transform: neighbor 
```
In this case the *Crop map spatial transform* specification was flagged to neighbor in order to downscale the Monfreda maps to a finer spatial resolution (0.01°). For other   options see the LDT user manual or contact Kristi Arsenault - NASA for additional information.

./lis.config
------------

The file `./lis.config` contains the input arguments needed by LIS for
the run. You could find inspiration in the testcases on how to complete
this file for your application and details are also provided in the LIS
Users' guide. Pay attention to the following:

    Spatial interpolation method (met forcing):   bilinear

If you run your models on a resolution much finer than the
MERRA2-forcing data, use the 'bilinear' spatial interpolation method for
the meteorological forcings.

    Forcing variables list file:            ./forcing_variables.txt

Textfile in which you define which variables should used from the MERRA2
data. Take the file from the merra2-testcase. You don't have to change
anything.

    Number of processors along x:           4
    Number of processors along y:           4

The number of processors on which you will run your model. 4 along x and
y results in a total of 16 processors. Pay attention to specify exactly
the same number of cores here and as argument to your mpirun -np N
(Section [3](#sec:run){reference-type="ref" reference="sec:run"}).\
If you do not do any data-assimilation, you can skip the
data-assimilation, bias estimation and perturbation options.

    LIS domain and parameter data file:     ./LDT_files/lis_input_1992.nc
    Elevation data source:                  LDT
    Slope data source:                      none

Define the netcdf-file you created with LDT. In the following lines you
have to define if the specific data is part of your netcdf file. For
example, in this case, there is an elevation map in our netcdf-file, but
no slope map.

    #--------------------------------FORCINGS----------------------------------
    MERRA2 forcing directory:               ./merra/MERRA2/MERRA2_land_forcing/
    MERRA2 use lowest model level forcing: 1
    MERRA2 use corrected total precipitation: 1

For the forcings, you have to define a path to the MERRA2-directory.
Note that the total length of a string in LIS is limited. If your
directory-path is too long, you will have an error. In that case, simply
link the MERRA2-path to your local directory (`$ ln -s`). Make sure you
use the lowest model level forcing and corrected total precipitation by
using '1' instead of '0'.

    Noah.3.6 restart output interval: 1mo
    Noah.3.6 restart file:            ./dyn_exp/dynamic/SURFACEMODEL/199112/
                                               LIS_RST_NOAH36_199112312345.d01.nc

If you write restart-files, you have to define to output interval (e.g.
1 month) and the name + output location.

    Noah.3.6 general parameter table: /scratch/leuven/320/vsc32041/input/input/PAR/
                                                                UMD/1KM/GENPARM.TBL

Each model has specific input-parameters. These specific input files can
be found in the testcase-directory or on the lis data portal:
<https://portal.nccs.nasa.gov/lisdata_pub/data/>

    Model output attributes file:   './MODEL_OUTPUT_LIST.TBL'

Textfile where you define which variables should be written out as
output. Check the LIS manual for more information. Sometimes it ends up
being a trial and error procedure to see which variables can be written
out. Not all variables in the list are variables for the chosen model,
and consequently, you will reveive an error, when you define a variable
as output which is not in the model.

You can change the name of your `./lis.config` file, but then you have
to add '--f' (e.g:
`$ mpirun -np 16 /scratch/leuven/320/vsc32041/NOAH.3.6 -f config_europe`)

All entries need to be on one line (i.e. this documentation shows
breaks, which should not be present in your configuration files).

WCM running in LIS Noah-MP.v.3.6
------------
* Specifications are needed to run the WCM coupled with Noah-MP.v.3.6 within the lis.config file:
```
    #------------------------RADIATIVE TRANSFER MODELS-------------------------
    Radiative transfer model: "WCM"
    RTM invocation frequency: 6hr
    RTM history output frequency: 6hr

    WCMRTM AA_VV parameter table: ./YourDir/NoahMp36_parms/AAvv_PARM.TBL
    WCMRTM BB_VV parameter table: ./YourDir/NoahMp36_parms/BBvv_PARM.TBL
    WCMRTM CC_VV parameter table: ./YourDir/NoahMp36_parms/CCvv_PARM.TBL
    WCMRTM DD_VV parameter table: ./YourDir/NoahMp36_parms/DDvv_PARM.TBL

    WCMRTM AA_VH parameter table: ./YourDir/NoahMp36_parms/AAvh_PARM.TBL
    WCMRTM BB_VH parameter table: ./YourDir/NoahMp36_parms/BBvh_PARM.TBL
    WCMRTM CC_VH parameter table: ./YourDir/NoahMp36_parms/CCvh_PARM.TBL
    WCMRTM DD_VH parameter table: ./YourDir/NoahMp36_parms/DDvh_PARM.TBL

```
The output frequency can be changed based on the user needs. Parameters.TBL tables, for each VV and VH backscatter polarization, are needed as input. The parameters should be calibrated values associated to each of the LIS grid cells (i.e., lon/lat with some specific spatial resolution in LIS).
* In order to create backscatter outputs (VV and VH polarization) the MODEL_OUTPUT_LIST.TBL table have to be updated with the following lines:
```
    RTM Sig0VV:               1  dB      -    0 0 0 1 256 10      # RTM Sigma0 VV
    RTM Sig0VH:               1  dB      -    0 0 0 1 256 10      # RTM Sigma0 VH
```
The first 0 will provide instantaneous outputs which will be created in an additional RTM directory within the OUTPUT directory defined in your lis.config file.

**IMPORTANT note** when running the WCM in LIS: I suggest to use the modified KUL_LIS_MODULES used for the configuration and compilation of LIS with WCM

Sprinkler irrigation running in LIS Noah-MP.v.3.6
------------
This section contains specifications to run Sprinkler irrigation in Noah-MP.v.3.6 after the lis_input.nc file generation process in LDT:
* In the lis.config file, input data to be specified are: 
1. The root zone soil moisture value below which irrigation is activated. In the Sprinkler irrigation script within Noah and Noah-MP this irrigation threshold is a user-defined percentage of the field capacity (FC). In the work by Ozdogan et al. (2010) this threshold was set as the 50% of the FC;
2. Irrigation Greenness Vegetation Fraction (GVF) parameters 1 and 2 are the threshold percentages for the begin and ends of the growing season. They can be set as 0.4 and 0.0 respectively as in Ozdogan et al. (2010) or modified based on site-specific knowledge; 
3. a maximum root depth file. This is related to the crop classification used. As an example, if we have associated the UMD-AVHRR land cover map (13 classes + water bodies) to the Ozdogan et al. (2010) CROPMAP classification we can create a maximum root depth file as following: a) Open a text file, which you can name umd_cropmap32.txt (since you will be accounting for 32 classes: 13 classes for AVHRR and 19 classes for the CROPMAP classification); b) Enter the below line into that txt file: 0.0 0.0 0.0 0.0 0.0 1.0 1.0 1.0 1.0 1.0 0.0 0.0 0.0 1.0 0.9 1.0 0.7 1.0 1.0 1.5 1.0 0.4 0.7 1.0 0.7 0.7 1.0 1.0 0.8 1.2 1.0 1.1; c) Save the file and then specify it in your lis.config file
4. a flag equal to 1 or 0 if we want to simulate irrigation from water abstraction or not. It is not clear if in the public version of LIS (that we are using) it is possible to select the flag 1. 
5. a parameter to define the "growing season", equal to 1 if we want to use climatological greenness vegetation fraction (GVF) to inform the model about the growing season or 0 if we want to rely or dynamic LAI (i.e, when LAI> 1 it starts the growing season - last implementation). In the second case the parameters at point 2. are ignored by the model (they are only used if the growing season is set to 1). 
* An example of how to add those specifications in the lis.config file is given below:
```
    #-------------------------IRRIGATION------------------------------------
    Irrigation scheme: "Sprinkler"
    Irrigation output interval: "1da"
    Irrigation threshold: 0.50
    Sprinkler irrigation max root depth file:       ./YourDir/Irrigation/umd_cropmap32.txt
    Flood irrigation max root depth file:
    Drip irrigation max root depth file:
    Growing season: 0 #dynamic LAI =0; clim GVF=1
    Irrigation GVF parameter 1: 0.40
    Irrigation GVF parameter 2: 0.00
    Groundwater abstraction for irrigation: 0
```
A bit further below
```
    #The following options list the choice of parameter maps to be used
    LIS domain and parameter data file:   ./lis_input.noahMP.irr_CROPMAP.nc
    Irrigation fraction data source: "LDT"
    Greenness data source:           "LDT"
```
* In order to create irrigation outputs the MODEL_OUTPUT_LIST.TBL table should contain specifications for the irrigation outputs as defined below:
```
    Irrigated water: 	 1 	kg/m2s	 -	 0 0 0 1 256 10 # Irrigated water amount
```
The first *“0”* in this list is set to instantaneous, *“1”* for average and *“3”* for accumulated output. I would recommend to use *“1”* or *“3”*.

Error messages encountered {#sec:errmess}
--------------------------

### Could not create file

      Could not create netcdf file

Diagnostic: LDT is trying to write a file to an output path that does
not exist. 'LDT output directory' must be 'OUTPUT', or 'processed lsm
parameter filename' is not correct.\
Solution: First create the directory where you will write your output
to.

LDT code development
====================================================

If you want to read in a new type of data in LDT, the following steps
have to be taken:

1.  Write script to read the data and save in
    `params/variable/read_variable.F90`

2.  Add script routine name in the plug-in folder:
    `plugins/ LDT_param_pluginMod.F90`

3.  Add lines in the core-folder: `core/LDT_[parameter]Mod.F90` (you
    have to add multiple lines, go through the file to see where you
    have to add lines. It is quite straightforward)

4.  Add variable in the table.c file: `core/LDT_variable_Ftable.c`

5.  Add variable name in datamod file: `core/LDT_paramDataMod.F90`

6.  Add variable name in: `core/LDT_PRIV_rcMod.F90`

7.  Add variable name in `LDT_readConfig`


Visualization of LIS structure with Doxygen
==========================

[Doxygen](https://www.doxygen.nl/) is an automatic code documentation tool with graphs of dependencies of modules and routines.

    $ git clone https://github.com/KUL-RSDA/LISF
    $ cd LISF
    $ cp -r /data/leuven/317/vsc31786/00_tools/Doxygen_lis .

Edit the paths in the Doxygen file to your personal directory of LISF.
On a compute node run (tier-2 only):

    $ module load Doxygen/1.9.1-GCCcore-10.3.0
    $ module load Graphviz/2.47.2-GCCcore-10.3.0
    $ doxygen Doxygen_lis/Doxyfile



RSDA code changes that still need to be transferred from archive/master-kul to separate branches:

Note that the ongoing S1 PR includes some bug fixes that are now in separate fix/branches (stripe fix, writout fix, see more: of the RSDA: https://github.com/NASA-LIS/LISF/pull/1415)
Once merged, those fix branches are not needed anymore.

Snow:
ENH: ML snow module --> Devon? https://github.com/KUL-RSDA/LISF/pull/54
ENH: noahmp4 snow da: https://github.com/KUL-RSDA/LISF/pull/40
ENH: S1 SD reader: wet snow mask added: https://github.com/KUL-RSDA/LISF/pull/28
ENH: Remove interpolation in snow depth reader: https://github.com/KUL-RSDA/LISF/pull/33

Vegetation DA:
ENH: CGLS FCOVER DA --> Niccolo, Louise (old https://github.com/KUL-RSDA/LISF/pull/30 and https://github.com/KUL-RSDA/LISF/pull/29)
ENH: CGLS LAI reader: https://github.com/KUL-RSDA/LISF/pull/7

Bug fixes:
BUG: Fix multiplicative error: https://github.com/KUL-RSDA/LISF/pull/49 and https://github.com/KUL-RSDA/LISF/pull/53

Irrigation:
BUG: Replacing uninitialized variable in Noah-MP401 irrigation module: https://github.com/KUL-RSDA/LISF/pull/48
ENH: Irrigation with multiple land cover maps: https://github.com/KUL-RSDA/LISF/pull/47
ENH: Irrigation modeling changes (irrigation triggering in case of bias correction and paddy): https://github.com/KUL-RSDA/LISF/pull/42
ENH: Growing season irrig double option noah m pv36: https://github.com/KUL-RSDA/LISF/pull/9

SMOS SM DA:
ENH: Update SMOS L2 SM DA routine: https://github.com/KUL-RSDA/LISF/pull/46

CCI SM DA:
ENH: Enabled Noah-MP.4.0.1 + ESA CCI SM plugin: https://github.com/KUL-RSDA/LISF/pull/4
ENH: ESA CCI SM assimilation over barren ground: https://github.com/KUL-RSDA/LISF/pull/27

S1 DA in noahmp401 (The ongoing PR to NASA was still noahmp36):
ENH: S1 DA for noahmp401: https://github.com/KUL-RSDA/LISF/pull/41

S1 DA (after PR for noahmp36 is merged):
ENH: S1 data masking over slopy terrain and forest (to be merged after merged PR at NASA): https://github.com/KUL-RSDA/LISF/pull/34
BUG: adapted setting of the S1 obs domain: https://github.com/KUL-RSDA/LISF/pull/31/files

NU-WRF related:
ENH: Enable bottom temperature as output variable for NoahMP 4.0.1 (still needed for newest nu-wrf?): https://github.com/KUL-RSDA/LISF/pull/37

VOD?
