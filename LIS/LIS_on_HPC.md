
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
  version 5   Sara Modanesi, updated documentation for the WCM and Noah-MP.v.3.6 irrigation
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
      --> (b) add "LDFLAGS += -lmkl -lsz -ltirpc" at the end
      --> (b) edit "INC_HDF4 = /apps/leuven/skylake/2018a/software/HDF/
                    4.2.8-intel-2018a-w-fortran-no-netCDF/include/hdf/"
      --> (c) add "LDFLAGS += -lmkl -lsz -ltirpc -qopenmp" at the end
    $ ./compile

or

    $ cd /data/leuven/314/vsc31402/src_code/LIS/github_20181214_KUL(_Genius)/ldt
    $ source KUL_LDT_modules
    $ ./configure
    $ vim ./make/configure.ldt 
      --> (a) add "LDFLAGS += -lmkl" at the end
      --> (b) add "LDFLAGS += -lmkl -lsz -ltirpc" at the end
      --> (b) edit "INC_HDF4 = /apps/leuven/skylake/2018a/software/HDF/
                    4.2.8-intel-2018a-w-fortran-no-netCDF/include/hdf/"
    $ ./compile

KUL\_LIS/LDT\_modules refers to different modules on Breniac (Tier-1) as well as on Thinking and
Genius (Tier-2).

Edit according to (a), when running on Thinking, edit according to (b)
when running on Genius or Breniac, and edit according to (c) when running 
on Hortense (no update for LDT yet). You may want/need to add some 
optional software here (e.g. CMEM, CRTM). 

**IMPORTANT notes** when running ./configure:
* LDT needs to be compiled **without the GeoTIFF** option. 
* For both LIS and LDT, the **GRIBAPI has to be selected** instead of the default ECCODES (this has become necessary only in the latest NASA-LIS/LISF github versions) 
* For all other options, the defaults can be used.

In ./user.cfg you could toggle on/off some plugins. By default, most are
turned on. If you change ./user.cfg, then you have to re-run ./configure
and then ./compile. (On Thinking, I turned off CABLE, because of a LIS
compilation error.)

After compilation, the relevant executables are LIS and LDT, which can
be run as discussed in section [3](#sec:run){reference-type="ref"
reference="sec:run"}.

Note: To speed up the compilation, it is possible to parallelize the process.
E.g. for 9 cores: $ ./compile -j 9

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
    module load GRIB_API/1.28.0-intel-2018a
    module load ESMF/7.1.0r-intel-2018a
    module load libxml2/2.9.7-GCCcore-6.4.0
    module load Szip/2.1.1-GCCcore-6.4.0
    module load zlib/1.2.11-GCCcore-6.4.0
    module load HDF/4.2.14-intel-2018a-w-fortran-no-netcdf
    module load HDF-EOS2/20.1.00-intel-2018a-HDF4-w-fortran
    module load Python/3.6.4-intel-2018a
    module load GDAL/2.4.1-intel-2018a-Python-3.6.4

**List of modules on Hortense (Tier-1):**

    module purge
    export LIBDIR=/dodrio/scratch/projects/2022_200/project_input/rsda/src_code/nu-wrf_ekman_v11.0/baselibs/intel-intelmpi
    module use $LIBDIR
    module load intel/2021a
    module load GCC/10.3.0
    module load libjpeg-turbo/2.0.6-GCCcore-10.3.0
    module load zlib/1.2.11-GCCcore-10.3.0
    module load libtirpc/1.3.2-GCCcore-10.3.0
    module load JasPer/1.900.1-GCCcore-10.3.0
    module load Szip/2.1.1-GCCcore-10.3.0
    module load cURL/7.76.0-GCCcore-10.3.0

Note that not all modules are available on dodrio yet. Therefore, we temporarily 
make use of the modules in the baselibs of the NU-WRF compilation.

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

**List of environment variables expected for compilation on Hortense:**
Make sure to replace the first line with the correct directory:

    export LIS_SRC=/your_src_directory/lis
    export LIS_ARCH=linux_ifc
    export LIS_SPMD=parallel
    export LIS_FC=mpiifort
    export LIS_CC=mpiicc
    export LIS_JASPER=$EBROOTJASPER
    export LIS_GRIBAPI=$LIBDIR/grib_api/
    export LIS_NETCDF=$LIBDIR/netcdf4/
    export LIS_HDF4=$LIBDIR/hdf4/
    export LIS_HDFEOS=$LIBDIR/hdfeos/
    export LIS_HDF5=$LIBDIR/hdf5/
    export LIS_MODESMF=$LIBDIR/esmf/mod/modO/Linux.intel.64.intelmpi.default/
    export LIS_LIBESMF=$LIBDIR/esmf/lib/libO/Linux.intel.64.intelmpi.default/
    export LIS_MINPACK=
    export LIS_CRTM=
    export LIS_CRTM_PROF=
    export LIS_CMEM=
    
    export LD_LIBRARY_PATH=$LIBDIR/jasper/lib:$LD_LIBRARY_PATH
    export LD_LIBRARY_PATH=$LIBDIR/netcdf4/lib:$LD_LIBRARY_PATH
    export LD_LIBRARY_PATH=$LIBDIR/hdf5/lib:$LD_LIBRARY_PATH
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib64
    export PATH=$LIBDIR/netcdf4/bin:$PATH

Water Cloud Model (WCM) - configure and compile in LIS
---------
The Water Cloud Model (WCM) was coupled with the Noah-MP.v.3.6. The following changes are needed for the configuration and compilation of the WCM in LIS:
* Step1. CRTM profile utility needs to be manually installed navigating to the directory *LISF/lis/lib/lis-crtm-profile-utility* and executing the command:
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

Compiling LIS with the foss toolchain
---------

**List of modules on Genius (foss toolchain):**

    module purge
    module load foss/2018a
    module load HDF/4.2.14-GCCcore-6.4.0-w-fortran-no-netcdf
    module load HDF-EOS2/20.1.00-foss-2018a-HDF4-w-fortran
    module load ESMF/7.1.0r-foss-2018a
    module load GDAL/2.4.1-foss-2018a-Python-3.6.4
    module load netCDF-Fortran/4.4.4-foss-2018a
    module load ecCodes/2.13.1-foss-2018a-with-Jasper-1.900.1

**List of environment variables expected for compilation on Genius (foss toolchain):**

    export LIS_SRC=/data/leuven/317/vsc31786/src_code/LIS/ac70_20220311_foss/lis
    export LIS_ARCH=linux_gfortran
    export LIS_SPMD=parallel
    export LIS_FC=mpif90
    export LIS_CC=mpicc
    export LIS_JASPER=$EBROOTJASPER
    export LIS_ECCODES=$EBROOTECCODES
    export LIS_NETCDF=/apps/leuven/skylake/2018a/software/netCDF-Fortran/4.4.4-foss-2018a
    export LIS_HDF4=$EBROOTHDF
    export LIS_HDFEOS=$EBROOTHDFMINEOS2
    export LIS_HDF5=$EBROOTHDF5
    export LIS_MODESMF=$EBROOTESMF/mod
    export LIS_LIBESMF=$EBROOTESMF/lib
    export LIS_GDAL=$EBROOTGDAL
    export LIS_CRTM_PROF=$LIS_SRC/lib/lis-crtm-profile-utility
    export LD_LIBRARY_PATH=${LIS_CRTM_PROF}/lib:${LIS_HDFEOS}/lib:${LIS_HDF4}/lib:${LIS_HDF5}/lib:${LIS_LIBESMF}:${LIS_NETCDF}/lib:${LIS_ECCODES}/lib:{LIS_JASPER}/lib:$LD_LIBRARY_PATH

**Adaptations and compilation:**

    --> create KUL_LIS_modules_foss with the list above
    then run (use all default options, the foss compilation works with ecCodes)
    --> ./configure
    in configure.lis change:
    INC_JPEG2000      = /apps/leuven/skylake/2018a/software/JasPer/1.900.1-GCCcore-6.4.0/include/jasper/
    INC_HDF4        = /apps/leuven/skylake/2018a/software/HDF/4.2.14-GCCcore-6.4.0-w-fortran-no-netcdf/include/hdf
    add -lsz to the LDFLAGS 
    then you can compile with
    --> ./compile


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

ArmForge ddt debugger
---------------------------
<img src="https://github.com/KUL-RSDA/documentation/assets/93274177/1a3e941d-f763-42ba-ac4c-e3d032a9d7f7" width="350" align="right">

**Tier 2 wICE**

This is based on the new compilation toolchain (developed by Sam)
To open the ddt debugger:

    $ module load ArmForge
    $ source load_modules
    $ ddt
*Note that it is important to first load ArmForge and then the moduels to avoid conflicts in the C compiler*

  
Click on Run and follow the example screenshot: 
1. path to executable
2. lis.config file to be run
3. working directroy
4. select MPI
5. under mpiexec.hydra arguments add `-genv I_MPI_PIN_RESPECT_CPUSET=0`

**Tier 2 Genius**

To open the ddt debugger:

    $ source KUL_LIS_modules
    $ module load ArmForge
    $ ddt
  
Click on Run and follow the example screenshot: 
1. path to executable
2. lis.config file to be run
3. working directory
4. select MPI
5. under mpiexec.hydra arguments add `-genv I_MPI_PIN_RESPECT_CPUSET=0 -genv I_MPI_HYDRA_BOOTSTRAP=ssh -genv LD_PRELOAD=/apps/leuven/rocky8/skylake/2018a/software/impi/2018.1.163-iccifort-2018.1.163-GCC-6.4.0-2.28/lib64/strtok_proxy.so`

**Tier 1 Hortense**

To open the ddt debugger:

    $ source KUL_LIS_modules
    $ module use /readonly/$VSC_SCRATCH_PROJECTS_BASE/2022_200/easybuild/modules/all
    $ module load ArmForge/22.1.2
    $ ./ddt
  
Do not select MPI but OpenMP instead

**Tier 2 WICE**

To open the ddt debugger (first load ArmForge and DO NOT include module purge in KUL_LIS_modules):

    $ module load ArmForge/22.1.2
    $ source KUL_LIS_modules
    $ ./ddt

under mpiexec.hydra arguments add: `-genv I_MPI_PIN_RESPECT_CPUSET=0 -genv I_MPI_HYDRA_BOOTSTRAP=ssh`
Do select MPI AND OpenMP.


**Debugging of job with multiple nodes Tier 2 GENIUS**

* submit batch job that gets stuck. When it got stuck:
* ssh to one of its compute nodes (not working on nx, unless you do first ssh -A yourvscaccount@firewall.vscentrum.be)
* source KUL_LIS_modules
* load compatible GDB module (same intel toolchain, no worries if python version conflicts and different version is reloaded)

Write out all backtrace output of each process into files:

    $ for pid in $(pgrep -f LIS); do
    $ echo "Getting backtrace for PID $pid..."
    $ gdb -p $pid -batch -ex "set pagination off" -ex "thread apply all bt" > backtrace_$pid.txt
    $ done
  
**May also work with DDT but not for every case**

* srun --x11 ... for a job with two nodes
* create file hosts.txt with two lines and the names of the two nodes
* start GUI of ddt as usual and provide in ddt the file with the known hosts in the mpi details  

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

Understanding LIS structure with Doxygen
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
