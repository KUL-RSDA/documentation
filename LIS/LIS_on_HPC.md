
Compile and run NASA's LIS, LDT, and LVT on the HPC at KU Leuven
==

    Authors:
        Gabriëlle De Lannoy, Michiel Maertens, Alexander Gruber
        contact: gabrielle.delannoy@kuleuven.be 

  ----------- ----------------------------------------------------------------------------------------------------
  version 1   Gabriëlle De Lannoy, initial documentation \
  version 2   Gabriëlle De Lannoy, updated libraries LIS7.2, downloaded LIS via github \
  version 3   Gabriëlle De Lannoy, Michiel Maertens, move to Genius, instructions on how to run LIS, LDT and LVT \
  version 4   Alexander Gruber, updated libraries for Tier-1 compilation
  ----------- ----------------------------------------------------------------------------------------------------

\
\
Acknowledgement: This work was supported by the HPC Team of the KU
Leuven.

Background information
======================

This document describes how to install and run NASA's LIS, LDT and LVT
on the KU Leuven [Tier-1](https://vlaams-supercomputing-centrum-vscdocumentation.readthedocs-hosted.com/en/latest/leuven/tier1_hardware/breniac_hardware.html) and [Tier-2](https://vlaams-supercomputing-centrum-vscdocumentation.readthedocs-hosted.com/en/latest/leuven/tier2_hardware.html) cluster.

-   get a VSC-account and manage it: <https://account.vscentrum.be/>

-   obtain LIS7.2 and LDT7.2 from NASA at
    <https://github.com/NASA-LIS/LISF>

-   source code is also available on the HPC to anyone in the group lees_swm_ls:
    /data/leuven/314/vsc31402/src code/LIS/

-   source code is also available on the KUL-RSDA github:
    <https://github.com/KUL-RSDA/LISF>
    (master branch is kept up-to-date with NASA version, a master-KUL branch 
    is also kept up-to-date with the NASA version but additionally contains 
    all recent developments of the group)

-   original source code, Makefiles, \... were developed for the NASA's
    NCCS Discover cluster

-   scripts adapted for the HPC at KU Leuven are under code indicated
    with `_KUL`, or `_KUL_Genius`

-   LIS7.2 requires you to prepare input using LDT; LIS-testcases need
    input that is prepared using LDT

There are three components:

-   The Land Information System (LIS) is the main system, including
    different land surface models (LSM) and data assimilation tools. You
    will use LIS to run LSMs and assimilate satellite data into your
    models.

-   The Land Data Toolkit (LDT) is the program you have to run before
    running LIS. LIS requires input data such as elevation, soilmaps,
    landcovermaps, vegetation data,\... LDT allows you to homogenize
    your input data (which are originally in different data formats)
    into one netcdf-file containing different input-layers, all with the
    same spatial extent and spatial resolution. This netcdf-file can
    easily be imported in LIS.

-   The Land Verification Toolbox (LVT) is a program which can be used
    to analyze your output data. For example, you have soil moisture
    output from three LSMs in LIS and you want to evaluate that output
    with SMOS and SMAP data. LVT facilitate such an analysis and enables
    the calculation of different evaluation metrices. The regridding in
    the LVT-program is a particularly useful tool. It brings all your
    models and satellite-retrievals to the same grid and resolution.

To get use to the different programs it is advised to run the different
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

To compile LIS or LDT source code, open a terminal. By default on the
Tier-1 and Tier-2 cluster, terminals use bash, and we will thus use bash-commands
to load modules and set environment variables. While they could be set
in your .profile, we do not need these settings every day and therefore
we prefer to save the steps in a separate script that should be sourced
prior to (i) configuring the compilation and (ii) compiling the code:

    $ cd /data/leuven/314/vsc31402/src_code/LIS/github_20181214_KUL(_Genius)/lis
    $ source KUL_LIS_modules
    $ ./configure
    $ vim ./make/configure.lis   
      --> (a) add "LDFLAGS += -lmkl" at the end
      --> (b) add "LDFLAGS += -lmkl -lsz" at the end
      --> (b) edit "INC_HDF4 = /apps/leuven/skylake/2018a/software/HDF/
                    4.2.8-intel-2018a-w-fortran-no-netCDF/include/hdf/"
    $ ./compile

or

    $ cd /data/leuven/314/vsc31402/src_code/LIS/github_20181214_KUL(_Genius)/ldt
    $ source KUL_LDT_modules
    $ ./configure
    $ vim ./make/configure.ldt 
      --> (a) add "LDFLAGS += -lmkl" at the end
      --> (b) add "LDFLAGS += -lmkl -lsz" at the end
      --> (b) edit "INC_HDF4 = /apps/leuven/skylake/2018a/software/HDF/
                    4.2.8-intel-2018a-w-fortran-no-netCDF/include/hdf/"
    $ ./compile

KUL\_LIS/LDT\_modules refers to different modules on Breniac (Tier-1) as well as on Thinking and
Genius (Tier-2).

./configure is only tested with default settings at the time of writing.
Edit according to (a), when running on Thinking, edit according to (b)
when running on Genius or Breniac. You may want/need to add some optional software
here (e.g. CMEM, CRTM). (For now, LDT needs to be compiled **without**
the GeoTIFF option - work in progress; all other default settings work
fine.)

In ./user.cfg you could toggle on/off some plugins. By default, most are
turned on. If you change ./user.cfg, then you have to re-run ./configure
and then ./compile. (On Thinking, I turned off CABLE, because of a LIS
compilation error.)

After compilation, the relevant executables are LIS and LDT, which can
be run as discussed in section [3](#sec:run){reference-type="ref"
reference="sec:run"}.

Cleaning before new compilation
-------------------------------

Before you (re)compile the code, it is a good policy to clean all the
folders by deleting the executables, object and library files generated
by the compilation. This can be done by using the following commands
(first two are enough):

    $ cd make && make realclean && cd MAKDEP && make realclean && cd ../..

In case you are still figuring out libraries or other basics to get the
compilation going, make sure to manually remove the ./make/configure.lis
file too.

Libraries
---------

The libraries used on the HPC are summarized below and set in
KUL\_LIS/LDT\_modules. The libraries were selected using the details in
the LIS and LDT User Guides and info available on-line
(<https://github.com/NASA-LIS/LISF/docs> modeling guru
<https://modelingguru.nasa.gov/community/atmospheric/lis/blog/2015/03/09/compiling-lis-7-on-sles11-sp3>).

Similarly, the environment variables are set using the info given in the
on-line sources above. The compilation relies on the exact variable
names (LIS\_XXX, LDT\_XXX) listed below.

Libraries and environment variables will be managed centrally for all of
lees\_swm\_ls(\_ext). So far, this was done by Gabrielle, Ehsan and
Alexander at HPC.

On the HPC, you seach for modules via \$ module avail \[part of module
name\]. To get more information about a specific module (e.g. the root
path to the software), use this command: \$ module display
\[modulename\].

To verify your environment variables: \$ printenv.

Don't forget to look in the right toolchain for your libraries: on
Thinking, that is 2015a. Also, the compilation did NOT work with
Python/3.\*.

The following modules need to be put into both KUL_LDT_modules and KUL_LIS_modules:

**List of modules on Thinking:**

    source switch_to_2015a
    module purge
    module load grib_api/1.21.0-intel-2015a
    module load JasPer/1.900.1-intel-2015a
    module load ESMF/7.0.0-intel-2015a
    module load libxml2/2.9.2-intel-2015a
    module load Szip/2.1-intel-2015a
    module load zlib/1.2.8-intel-2015a
    module load HDF/4.2.8-intel-2015a-w-fortran-no-netCDF
    module load HDF-EOS2/19.1.00-intel-2015a-HDF4-w-fortran
    module load Python/2.7.10-intel-2015a
    module load GDAL/2.0.0-intel-2015a
    #module load FortranGIS/2.4-intel-2015a ##does not work##

**List of modules on Genius:**

    module purge
    module load grib_api/1.24.0-intel-2018a
    module load JasPer/2.0.14-GCCcore-6.4.0
    module load ESMF/7.1.0r-intel-2018a
    module load libxml2/2.9.7-GCCcore-6.4.0
    module load Szip/2.1.1-GCCcore-6.4.0
    module load zlib/1.2.11-GCCcore-6.4.0
    module load HDF/4.2.8-intel-2018a-w-fortran-no-netCDF
    module load HDF-EOS2/20.1.00-intel-2018a-HDF4-w-fortran
    module load Python/2.7.14-GCCcore-6.4.0-bare
    module load GDAL/2.2.3-intel-2018a-Python-2.7.14
    
**List of modules on Breniac (Tier-1):**

    module purge
    module load grib_api/1.24.0-intel-2019b
    module load ESMF/7.1.0r-intel-2019b
    module load libxml2/2.9.9-GCCcore-8.3.0
    module load Szip/2.1.1-GCCcore-8.3.0
    module load zlib/1.2.11-GCCcore-8.3.0
    module load HDF/4.2.8-intel-2019b-w-fortran-no-netCDF
    module load HDF-EOS2/20.1.00-intel-2019b-HDF4-w-fortran
    module load Python/2.7.16-GCCcore-8.3.0
    module load GDAL/2.2.3-intel-2018a-Python-2.7.14

**List of environment variables expected for compilation on Thinking:**

    export LIS_SRC=/vsc-hard-mounts/leuven-data/314/vsc31402/src_code/LIS/
                   github_20181214_KUL/lis
    export LIS_ARCH=linux_ifc
    export LIS_SPMD=parallel
    export LIS_FC=ifort
    export LIS_CC=icc
    export LIS_JASPER=$EBROOTJASPER
    export LIS_GRIBAPI=$EBROOTGRIB_API
    export LIS_NETCDF=$EBROOTNETCDF
    export LIS_HDF4=$EBROOTHDF
    export LIS_HDFEOS=$EBROOTHDFMINEOS2
    export LIS_HDF5=$EBROOTHDF5
    export LIS_MODESMF=$EBROOTESMF/mod
    export LIS_LIBESMF=$EBROOTESMF/lib
    export LIS_MINPACK=
    export LIS_CRTM=
    export LIS_CRTM_PROF=
    export LIS_CMEM=
    export LDT_GDAL=$EBROOTGDAL
    #export LDT_FORTRANGIS=$EBROOTFORTRANGIS  ##does not work##

    export LD_LIBRARY_PATH=${LIS_MINPACK}/lib/intel64:${LIS_HDFEOS}/lib:
    ${LIS_HDF4}/lib:${LIS_HDF5}/lib:${LIS_LIBESMF}:${LIS_NETCDF}/lib:
    ${LIS_GRIBAPI}/lib:{LIS_JASPER}/lib:$LD_LIBRARY_PATH

**List of environment variables expected for compilation on Genius and Breniac:**

    export LIS_SRC=/vsc-hard-mounts/leuven-data/314/vsc31402/src_code/LIS/
                   github_20181214_KUL_Genius/lis
    [... identical to the above]
    export LIS_FC=mpiifort
    export LIS_CC=mpiicc
    [... identical to the above]

We somewhat suboptimally compiled LIS with ifort and icc on Thinking
nodes, but fixed this when moving to Genius with mpiifort and mpiicc
(not mpicc).

LIS and LDT runs {#sec:run}
================

General
-------

To run a job, we need [HPC
credits](https://vlaams-supercomputing-centrum-vscdocumentation.readthedocs-hosted.com/en/latest/jobs/credit_system_basics.html#credit-system-basics):
click on link for more info. Before submitting a job, the libraries and
environment variables need to be sourced:

    $ source KUL_LDT_modules
    $ source KUL_LIS_modules

Secondly, prepare your `lis.config`-file for your application. Third,
also add forcing variables list file, the netcdf-file created with LDT,
model-specific input files, model output attribute file and a
restart-file. Or else, define the path to each specific file in the
configuration file.

Run a job on an interactive node (for testing)
----------------------------------------------

Get the interactive nodes and run your case:

    $ qsub -I -l nodes=1:ppn=N,walltime=1:00:00 -A default_project
    $ ulimit -s unlimited
    $ ./LIS lis.config (single core)
    $ mpirun -np N ./LIS lis.config

with N the number of processors for parallel computing. The `ulimit`
command ensures enough memory for the simulation.

Run a job in the queue
----------------------

Create script (\$ sh script.sh) with PBS-commands (example below) and
launch it:

    ----------------------------------------------------------
    #!/bin/bash

    #PBS -N My_M_queued
    #PBS -l walltime=00:02:00
    #PBS -l nodes=1:ppn=4:ivybridge
    #PBS -A default_project
    #PBS -m abe
    #PBS -M firstname.lastname@kuleuven.be
    #PBS -o script_log.txt
    #PBS -e script_out.txt

    cd $PBS_O_WORKDIR

    ulimit -s unlimited
    source /vsc-hard-mounts/leuven-data/314/vsc31402/src_code/LIS/
         github_20181214_KUL/lis/KUL_LIS_modules
    mpirun -np 4 /vsc-hard-mounts/leuven-data/314/vsc31402/src_code/LIS/
         github_20181214_KUL/lis/LIS lis.config
    ----------------------------------------------------------

Run a job in debugging mode
---------------------------

First, Then, either manually enter the information in ddt or as follows
on the prompt (stay in bash, not csh!):

-   `qsub -I -lnodes=2:ppn=20 -lwalltime=00:20:00`

-   when you have the interactive node:\
    `>> echo $PBS_NODEFILE`\
    `>> /var/spool/torque/aux//20499919.tier2-p-moab-1.icts.hpc.kuleuven.be`

-   `cp $PBS_NODEFILE /scratch/...[experiment]/run/.`

-   when you have the interactive node: `>> ssh -X i0r5n4`: open new
    xterm to circumvent the memory limit (for now)

-   -   `source KUL_LIS_modules`

-   ` mpirun -np 20 -machinefile ./20500283.tier2-p-moab-1.icts.hpc.kuleuven.be /path_to_LIS/LIS lis.config`

./ldt.config
------------

In the configuration file, you have to define which model you will run,
over which domain and on which resolution, for example, in this case,
the models were run over a region in South-America with a resolution of
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

Error messages encountered {#sec:errmess}
--------------------------

### Could not create file

      Could not create netcdf file

Diagnostic: LDT is trying to write a file to an output path that does
not exist. 'LDT output directory' must be 'OUTPUT', or 'processed lsm
parameter filename' is not correct.\
Solution: First create the directory where you will write your output
to.

LIS and LDT: log of source code changes at KU Leuven
====================================================

Check with Michiel Maertens or Hans Lievens for:

-   reading new soil texture maps

-   assigning new soil hydraulic parameters

-   reading and assigning new vegetation parameters

-   assimilating Sentinel-1 snow depth retrievals

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

LIS and LDT: in a nutshell
==========================

[LIS users'
guide](https://modelingguru.nasa.gov/servlet/JiveServlet/downloadBody/2634-102-4-6543/LIS_usersguide.pdf),
[LDT users'
guide](https://modelingguru.nasa.gov/servlet/JiveServlet/downloadBody/2635-102-3-6535/LDT_usersguide.pdf),
[LVT users'
guide](https://modelingguru.nasa.gov/servlet/JiveServlet/downloadBody/2636-102-1-6534/LVT_usersguide.pdf).\
To compile on the KU Leuven HPC:

Download the source code (github) or copy available source code to your
local directory, and find an KUL(\_Genius)-updated LIS version to get
information on settings:

-   `$ cp KUL_LDT_modules` from a KUL(\_Genius)-updated version into
    your own folder

-   [`$ source KUL_LDT_modules`]{style="background-color: yellow"} (set
    libraries and environment variables)

-   [`$ ./configure`]{style="background-color: yellow"}

-   `$ vim ./make/configure.lis`, and edit as in
    Section [2](#sec:compilation){reference-type="ref"
    reference="sec:compilation"}

-   [`$ ./compile`]{style="background-color: yellow"}

-   the executable should show up in the current directory: LIS

-   repeat for LDT

To move from Thinking to Genius or Breniac,

1.  copy new KUL\_LDT\_modules, KUL\_LIS\_modules

2.  edit `./make/configure.lis` differently, as detailed in
    Section [2](#sec:compilation){reference-type="ref"
    reference="sec:compilation"}

To run:

Link the executable to your working directory my\_WORKDIR, then run.
E.g. the path\_to\_LIS is
`/data/leuven/314/vsc31402/src_code/LIS/github_20181214_KUL(_Genius)/lis/`.

-   create a directory `my_WORKDIR` from which you will run simulations,
    most likely on `$VSC_SCRATCH` (note that is not the source-code
    directory folder).\
    For example: \$ mkdir /scratch/leuven/320/vsc32041/NOAH.3.6

-   `$ cd my_WORKDIR`

-   `$ vim ldt.config`, and edit for your application (start from a
    testcase)

-   `$ ln -s path_to_LDT/LDT my_WORKDIR/LDT`

-   `$ ln -s path_to_LDT/KUL_LDT_modules my_WORKDIR/KUL_LDT_modules`

-   [`$ source KUL_LDT_modules`]{style="background-color: yellow"}

-   [`$ ulimit -s unlimited `]{style="background-color: yellow"}

-   [`$ ./LDT ldt.config`]{style="background-color: yellow"}

-   `$ cd my_WORKDIR`

-   `$ vim lis.config`, and edit for your application (start from a
    testcase)

-   possibly add or link forcing variables list file, the netcdf-file
    created with LDT, model-specific input files, model output attribute
    file and a restart file.

-   `$ ln -s path_to_LIS/LIS my_WORKDIR/LIS`

-   `$ ln -s path_to_LIS/KUL_LIS_modules my_WORKDIRL/KUL_LIS_modules`

-   [`$ source KUL_LIS_modules`]{style="background-color: yellow"}

-   [`$ ulimit -s unlimited `]{style="background-color: yellow"}

-   [`$ mpirun -np N ./LIS lis.config`]{style="background-color: yellow"}

-   or better launch script with PBS-commands in the queue (e.g.
    `$ sh script.sh`)

Logging into Thinking or Genius:

    $ ssh vscxxxxx@login.hpc.kuleuven.be (Thinking)
    $ ssh vscxxxxx@login1-tier2.hpc.kuleuven.be (Genius)
    $ ssh vscxxxxx@login1-tier1.hpc.kuleuven.be (Breniac)

Credit system

    $ module load accounting
    $ mam-balance
    $ gquote -q q24h -l nodes=1:ppn=20:ivybridge
    $ mam-statement (-a lp_ees_swm_ls_001 --summarize)

Submitting and managing jobs

    $ qsub -q q1h script_w_PBS_commands.sh
    $ qsub -I -l walltime=2:00:00 -l nodes=1:ppn=20 -A default_project
    $ qstat (-q)
    $ showq
    $ checkjob [jobid]
    $ qdel [jobid]
    $ showstart [jobid]

