
Compile and run NASA's NU-WRF on the HPC at KU Leuven
==

    Authors:
        Jonas Mortelmans, Michel Bechtold
        contact: jonas.mortelmans@kuleuven.be 

  ----------- ----------------------------------------------------------------------------------------------------
  version 1   Jonas Mortelmans, initial documentation 
  ----------- ----------------------------------------------------------------------------------------------------




# Background information

This document describes how to install and run NASA's NU-WRF
on the KU Leuven [Tier-1](https://vlaams-supercomputing-centrum-vscdocumentation.readthedocs-hosted.com/en/latest/leuven/tier1_hardware/breniac_hardware.html) and [Tier-2](https://vlaams-supercomputing-centrum-vscdocumentation.readthedocs-hosted.com/en/latest/leuven/tier2_hardware.html) cluster.

-	The NU-WRF software is subject to NASA legal review, and users are required to sign a Software User Agreement.
	Toshi Matsui (toshihisa.matsui-1@nasa.gov) and Carlos Cruz (carlos.a.cruz@nasa.gov) are the points of contact for discussing and processing requests for the NU-WRF software.

-	original source code, Makefiles, ... were developed for the NASA's NCCS Discover cluster

-	This documentation is based on the [NU-WRF v10 user guide](https://nuwrf.gsfc.nasa.gov/sites/default/files/docs/nuwrf_userguide_v10.pdf), the [ARW v3 user guide](https://www2.mmm.ucar.edu/wrf/users/docs/user_guide_V3/user_guide_V3.9/ARWUsersGuideV3.9.pdf), and [the Charney NU-WRF tutorial](https://nuwrf.gsfc.nasa.gov/sites/default/files/docs/nuwrf_tutorial_charney_p1.pdf).

- 	All text following '$' are commands to be executed in the terminal.

-	All text in between <> indicates paths that need to be adapted to your own path.

## The different components and utilities of NU-WRF

The NU-WRF modeling system is a superset of the standard NCAR Advanced Research WRF (WRF-ARW) and incorporates the GSFC Land Information System (LIS), the WRF-Chem enabled version of the Goddard Chemistry Aerosols Radiation Transport model (GOCART), the GSFC radiation and microphysics schemes, and the Goddard Satellite Data Simulator Unit (G-SDSU).
The NU-WRF package contains several components and utilities. The most important will be discussed here. A full list can be found in [section 2 of the NU-WRF User Guide](https://nuwrf.gsfc.nasa.gov/sites/default/files/docs/nuwrf_userguide_v10.pdf).

### The WRF/ component

This component contains the core WRF modeling system, the WRF-Fire wildfire library, the WRF-Chem atmospheric chemistry library and several preprocessors (e.g. REAL).

### The WPS/ component

The WPS/ component (or WRF Preprocessing System) includes GEOGRID, UNGRIB and METGRID programs. These programs are used to prepare the WRF runs by specifying the domain(s), interpolate both static and climatological data, extract fields from GRIB(2) files and to horizontally interpolate these fields to the specified WRF grid/domain.
It also includes the (optional) AVG_TSFC preprocessor, used to calculate time-average surface temperatures that can be used to initialize small in-land lake temperatures.

### The LISF/ component

This component contains the NASA Land Data Toolkit (LDT), NASA Land Verification Toolkit (LVT), and the NASA Land Information System (LIS). 
For a full description of these components, see the [LIS_on_HPC documentation](https://github.com/KUL-RSDA/documentation/blob/master/LIS/LIS_on_HPC.md)

### The utils/lisWrfDomain/ utility

This utility only contains the NASA LISWRFDOMAIN software that is used to customize LDT and LIS input files to make sure their domains match those specified by the WPS GEOGRID program.

### The utils/sst2wrf utility

This utility contains the NASA SST2WRF preprocessor that is used to download Sea Surface Temperature (SST) data by [Remote Sensing Systems](http://www.remss.com).
It then converts the data into the WPS intermediate format, readable by the METGRID program.

### The utils/bin/merra2wrf utility

This utility can be used to preprocess atmospheric fields from both MERRA and MERRA-2 and convert the data into the WPS intermediate format, readable by the METGRID program.

# compiling


# Running NU-WRF

The NU-WRF modeling system can be run in several ways. It can be run without any chemistry or advanced land surface initialization (basic workflow), coupled with LIS (WRF-LIS coupled run), as a Single Column Model with LIS coupling (SCM), or with Chemistry (Chem).
For the Chemistry runs, no LIS coupling is possible, but instead makes use of the GOCART2WRF preprocessor.
In this documentation, only the WRF-LIS coupled run will be discusssed in detail, although most of the things mentioned here are also important/needed for the other run types.

## The WRF-LIS Coupled run

This workflow does not use land surface fields interpolated from a coarser model or reanalysis, but instead uses a custom-made land surface state created by LIS. 
WRF calls LIS on each advective time step, and provides atmospheric forcing data and receives land surface data in return.

![Workflow](https://user-images.githubusercontent.com/70951991/139251736-7047a82d-7a0a-481f-9a1e-27e03c2e2028.png)

This schematic shows the main workflow to follow for WRF-LIS coupled runs. It makes us of MERRA-2 atmospheric initial and lateral boundary conditions, Remote Sensing Systems SST product (SSTRSS), and LIS land surface model initial conditions.

### Necessary files

In order to run a WRF-LIS coupled run, you need to copy the following files from the source code (NUWRFDIR) to your run directory (RUNDIR):

	- NUWRFDIR/testcases/tutorial/default_workflow
		- All files
	- NUWRFDIR/utils/bin/merra2wrf.py
	- NUWRFDIR/utils/bin/sst2wrf.py

e.g.: $ cp $NUWRFDIR/testcases/tutorial/default_workflow/* $RUNDIR

### Required script changes

These files are developed to work on NASA's Discover or Pleiadis servers and will not work directly on the HPC. To do so, there are some changes needed to the files.
Some of these changes are dependent on your study area, time,... These changes will not be discussed in detail. Strict changes, i.e. changes needed to make the model run on the HPC will be indicated in **bold**.

It is best to first make all the necessary adaptations to all the scripts before running any of them, as they are linked to each other and this may cause unforeseen errors.

**NOTE**: If a change is followed by If a change is followed by (max_dom), you need to write the change in as many columns as the number of domains you have. E.g. if you have 2 domains, you will need to write:
	MERRA2 forcing directory:./LS_PARAMETERS/MERRA2_land_forcing ./LS_PARAMETERS/MERRA2_land_forcing

In the configuration and namelist files, each column specifies a domain. To add an additional domain, simply add a column.
If you have 3 columns, but max_dom is specified to 2, only the first 2 columns will be used (thus only 2 domains).

#### common.reg

For ease, it's best if this is the very first file you adapt. This file makes a link between all the different files and directories, so changing the paths in this file first will make it easier later on.

1. Comment the following lines:
	1. **. /usr/share/modules/init/bash**
	2. **All of the module load files**
	3. **LIBDIR_TAG=...**
	4. **All export lines**
2. **Remove the LISDIR line**
3. **Add: source <PATH_TO_NU-WRF_modules>**
4. **Add: module load ncview**
5. **Change NUWRFDIR=<CHANGE THIS> to export NUWRFDIR= <PATH_TO_SRC>**
6. **Change RUNDIR=<CHANGE THIS> to export RUNDIR= <YOUR RUNDIR>**
7. **Add: export EXEDIR= <PATH_TO_SRC>**
8. **Add: export MPIRUN=mpirun**
9. **Add: export LISDIR= <PATH_TO_LISDIR>**

#### namelist.wps

This is the configuration file for GEOGRID, UNGRIB and METGRID. It consists of different parts, each indicated at the start by '&' and at the end with '/'. 
Depending on whether you need UNGRIB (not needed unless you deviate from the default workflow here described), there are 3 or 4 parts.

1. &share

In this part, you'll need to change the run period (start and end date), and the number of domains.

2. &geogrid

This part is specifically for geogrid.reg and defines the location and extent of the different domains, their resolution, projection,...
The **geog_data_path** needs to be changed to:
	**geog_data_path = <PATH_TO_GEOG_PARAMETERS>**

3. &ungrib

This part is only needed when using the ungrib modules. This is in general not needed for this workflow, unless you deviate from the standard data.
What you'll need to change:
	**out_format = 'WPS',**
	prefix = 'SSTRSS',

The prefix can technically be anything you want, but make it consistent with the other files. 'SSTRSS' requires the least changes (for SST).

4. &metgrid

This final part is only used by metgrid.reg
'fg_name' defines the prefix of the MERRA2 and SST data so metgrid knows what files to look for. It can be changed if you made changes to the merra2wrf.py or sst2wrf.py scripts, but otherwise leave it as it is.

#### namelist.input.real and namelist.input.wrf

These files are used as configuration files for real.reg and wrf.reg, respectively. You will need to adopt these files to your own specific study (change runtimes, number of nests, specific options,...).
For an (almost) complete list of the available options (e.g. physics), see [namelist.input options](https://esrl.noaa.gov/gsd/wrfportal/namelist_input_options.html) and *$NUWRFDIR/WRF/run/README.namelist*.
The settings for these files are really dependent on what you exactly want to model/study as different options are optimal for different processes. To get an idea of what options you'll need, it's best to check literature.

#### lis.config.coldstart and lis.config.wrf

These files are used by lis.reg (for a spin-up of the land) and wrf.reg (to model the land), respectively. In here you can specify the spin-up period, all the different options used in the LSM, timesteps,...
Changes:

1. **MERRA2 forcing directory: ./LS_PARAMETERS/MERRA2_land_forcing** (max_dom)
2. **Noah MP.3.6 landuse parameter table : ./LS_ noahmp_params/VEGPARM.TBL** (max_dom)
3. **Noah MP.3.6 soil parameter table : ./LS_ noahmp_params/SOILPARM.TBL** (max_dom)
4. **Noah MP.3.6 general parameter table : ./LS_ noahmp_params/GENPARM.TBL** (max_dom)
5. **Noah MP.3.6 MP parameter table : ./LS_ noahmp_params/MPTABLE.TBL** (max_dom)

#### ldt.config.prelis and ldt.config.postlis

These are the configuration files for ldt_prelis.reg and ldt_postlis.reg, respectively.
Changes:

1. Number of nests: whatever amount of nests you have
2. **Elevation map: Elevation map: ./LS_PARAMETERS/topo_parms2/SRTM** (max_dom)
3. **Slope map: ./LS_PARAMETERS/topo_parms2/SRTM** (max_dom)
4. **Aspect map: ./LS_PARAMETERS/topo_parms2/SRTM** (max_dom)
5. **Bottom temperature map: ./LS_PARAMETERS/UMD/1KM/tbot_NCEP.1gd4r** (max_dom)
6. **Noah MP PBL Height Value: 900.** (max_dom)

#### merra2wrf.py

This script is used instead of the merra2wrf.reg, just because it skips some error-prone preprocessing steps.
Changes:

1. **merra_server = <PATH_TO_MERRA2_DATA>**
2. **Add : merra_server_2 = <PATH_TO_MERRA2_constant_file (MERRA2_400)>**
3. ** file_name1 = 'MERRA2_400.const_2d_asm_Nx.00000000.nc4'**
4. **get_file (merra_server_2,'diag',file_name1, outdir)**
5. **file_name2 = stage_prefix+'.inst6_3d_ana_Nv.'+year+month+day+'.nc4'**
6. **get_file(merra_server,stage_prefix+'/diag/Y'+year+'/M'+month,file_name2, outdir)**
7. **file_name3 = stage_prefix+'.inst6_3d_ana_Np.'+year+month+day+'.nc4'**
8. **get_file(merra_server,stage_prefix+'/diag/Y'+year+'/M'+month,file_name3, outdir)**
9. **file_name4 = stage_prefix+'.tavg1_2d_slv_Nx.'+year+month+day+'.nc4'**
10. **get_file(merra_server,stage_prefix+'/diag/Y'+year+'/M'+month,file_name4, outdir)**
11. **file_name5 = stage_prefix+'.tavg1_2d_ocn_Nx.'+year+month+day+'.nc4'**
12. **get_file(merra_server,stage_prefix+'/diag/Y'+year+'/M'+month,file_name5, outdir)**
13. **file_name6 = stage_prefix+'.tavg1_2d_lnd_Nx.'+year+month+day+'.nc4'**
14. **get_file(merra_server,stage_prefix+'/diag/Y'+year+'/M'+month,file_name6, outdir)**
15. **In clean up: put all os.remove () statements in the for loop.**

On Tier-1:
<PATH_TO_MERRA2_DATA> = '/scratch/leuven/projects/lt1_2020_es_pilot/External/Reanalysis/MERRA2_land_forcing'
<PATH_TO_MERRA2_constant_file> = '/scratch/leuven/projects/lt1_2020_es_pilot/External/Reanalysis/MERRA2_land_forcing/MERRA2_400'

On Tier-2:
<PATH_TO_MERRA2_DATA> = '/staging/leuven/stg_00024/input/met_forcing/MERRA2_land_forcing/'
<PATH_TO_MERRA2_constant_fil0> e= '/staging/leuven/stg_00024/input/met_forcing/MERRA2_land_forcing/MERRA2_400'

#### sst2wrf.py
	
This script is used instead of the sst2wrf.reg, just because it skips some error-prone preprocessing steps. It is used to download SST data from [Remote Sensing Products](https://data.remss.com/sst/daily/mw_ir/v05.0/bmaps/) and processes it into WPS intermediate format.
Changes:
	
1. Comment the following lines:
	1. if int(syear) > 2017 and inst_type == 'mw_ir':
	2. print('SST2WRF cannot process mw_ir data for years >= ', syear)
	3. sys.exit()
2. delete:
	1. if "4" in data_version:
	  ftpname = data_server+'/daily_v04.0/'+inst_type+'/'+year+'/
	  else:
	  ftpname = data_server+'/daily/'+inst_type+'/v05.0/bmaps/'+year+'/'
	2. if "4" in data_version:
	3. else:
	   ver = 'v04.0'
	
#### lis.reg

This file is used to actually run the LIS. It has some specifications in it first and lastly calls the LIS executable.
Changes:

1. **ln -sf $LISDIR/LS_PARAMETERS/MERRA2_land_forcing/MERRA2_*/diag/* $RUNDIR/MET_FORCING || exit 1**
2. **if [ ! -e $RUNDIR/MET_FORCING ] ; then**

Both changes are in the line where it directs to the MERRA2 data (MET_FORCING data).

### The actual workflow

The following section will discuss how to actually run the different scripts and the order to run them in. For each file, there is also a short description, for a full description check [NU-WRF v10 user guide](https://nuwrf.gsfc.nasa.gov/sites/default/files/docs/nuwrf_userguide_v10.pdf).

#### common.reg

This file makes a link between all the different files and makes sure every script can find the data/scripts it needs (either in the RUNDIR, NUWRFDIR, or LISDIR).
If you don’t source the common.reg file first, you will get errors. Whenever you get an error that a certain file isn’t found, check common.reg and after every change, resource it.

In your working directory, run the following line. The second line is purely to check that the $RUNDIR is indeed set correctly. If you are certain, you can skip that.

	$ source common.reg
	$ cd $RUNDIR

#### geogrid.reg

Geogrid interpolates static and climatological terrestrial data to each WRF grid specified in namelist.wps.

Input: namelist.wps
Output: geo_em* files (one for each domain specified in namelist.wps)

	$ ./geogrid.reg

After finishing check the geogrid.log.0000 file for *** Succesful completion of program geogrid.exe ***

#### merra2wrf.py

This script is used to preprocess 6-hourly atmospheric fields from the Modern-Era Retrospective Analysis for Research and Applications (MERRA) as well as MERRA-2 reanalysis data. The script processes the netcdf files into data readable by METGRID (format = WPS intermediate format).

	$ ./merra2wrf.py STARTDATE ENDDATE

E.g. ./merra2wrf.py 20150515 20150901

After running, the data should be linked from ./data/merra2wrf to $RUNDIR

	$ ln -s $RUNDIR/data/merra2wrf/MERRA* $RUNDIR

#### sst2wrf.py

The script processes SST data produced by [Remote Sensing Systems](http://www.remss.com). 

	$ ./sst2wrf.py STARTDATE ENDDATE

E.g.: ./sst2wrf.py 20150515 20150901

After running, the data should be linked from ./data/sst2wrf/mw_ir to $RUNDIR:
	
	$ ln -s $RUNDIR/data/sst2wrf/mw_ir/SSTRSS* $RUNDIR

#### avg_tsfc.reg

This file calculates daily-averaged air temperature (TAVGSFC), which can then be processed, together with other data, by METGRID for horizontal interpolation. It can also be used by REAL for the surface temperatures over (small) lakes.

	$ ./avg_tsfc.reg

#### metgrid.reg

This file horizontally interpolates the output from WPS (avg_tsfc.reg, merra2wrf.py and sst2wrf.py/ungrib.reg) to the WRF domains, specified in namelist.wps.

Input: namelist.wps, MERRA*, SSTRSS*, AVGTSFC, geo_em* files
Output: met_em* files, one for each timestep and domain.

	$ ./metgrid.reg

When done, check for *** Successful completion of program metgrid.exe *** in metgrid.log.0000

#### liswrf_domain.reg

Liswrf_domain is used to costumize LDT and LIS config files to make sure their domains match that of WRF. It uses the output of GEOGRID to determine the reference latitude and longitude.  

Input: lis.config.*, ldt.config.* and geo_em* files
Output: lis.config.new, ldt.config.new

	$ ./liswrf_domain.reg

After running, the new lis.config files need to be copied to the original ones to make sure the correct ones are used:
	$ cp ldt.config.prelis.new ldt.config.prelis
	$ cp ldt.config.postlis.new ldt.config.postlis
	$ cp lis.config.coldstart.new lis.config.coldstart
	$ cp lis.config.wrf.new lis.config.wrf

#### ldt_prelis.reg

LDT processes data inputs for different surface models.  

Input: ldt.config.prelis
Output: lis_input* files, one for each NU-WRF domain.

	$ ./ldt_prelis.reg

After finishing, check ldtlog_prelis.0000 for 'Finished LDT run'

#### lis.reg

LIS can be run in various modes. Here it is run in ‘retrospective’ mode to produce restart and history files. The history files are used by ldt_postlis.reg, the restart files are used by wrf.reg

Input: lis_input* files, lis.config.coldstart, forcing_variables_merra2.txt, NOAHMP36_OUTPUT_LIST_SPINUP.TBL
Output: LIS_HIST* and LIS_RST* files

	$ ./lis.reg

When done, check lislog.0000 for 'LIS Run completed'.

Link the LIS restart (RST) and history (HIST) files from OUTPUT to $RUNDIR:

	$ ln -s OUTPUT/SURFACEMODEL/YYYYMM/* $RUNDIR

### ldt_postlis.reg

After LIS, it is necessary to rerun LDT. Fields from both LDT and LIS will be combined and written to a new netCDF output file used by REAL.

Input: ldt.config.postlis, LIS_HIST*
Output: lis4real_input* files, one for each NU-WRF domain

	$ ./ldt_postlis.reg

When done, check ldtlog_postlis.0000 for 'Finished LDT run'

#### real.reg

REAL vertically interpolates the METGRID output to the WRF grid and creates initial and lateral boundary condition files.

Input: namelist.input.real, met_em*, geo_em*, lis4real_input* files
Output: wrfinput* files, one for each NU-WRF domain, wrfbdy_d01, (wrflowinp* for each NU-WRF domain, depending on your settings)

	$ ./real.reg

When done, check real.rsl.error.0000 for 'real_em: SUCEESS COMPLETE REAL_EM INIT'

#### wrf.reg

REAL vertically interpolates the METGRID output to the WRF grid, and creates initial and lateral boundary condition files.

Input: namelist.input.wrf, lis.config.wrf, NOAHMP36_OUTPUT_LIST.TBL, wrfinput*, wrfbdy_d01, (wrflowinp*, depending on your settings)
Output: wrfout* files (one for each time step and domain)

	$ ./wrf.reg

When done, check wrf.rsl.error.0000 for completion.

# Postprocessing

The output produced at different steps of the NU-WRF process. This section will give some general examples that can be used to visualize the intermediate files and to check and process the wrf output.

A first visualization can already be made after defining the domain sizes in the namelist.wps file. This can be done by running the following line:

	$ ncl $NUWRFDIR/WPS/util/plotgrids_new.ncl

This will show the domains on a map and can be very useful to iteratively set the desired domain sizes and positions.


The output files of geogrid (geo_em*), metgrid (met_em*), LIS (LIS_HIST* & LIS_RST*), and LDT (lis4real_input*) are all netCDF files and can therefore be visualized with both panoply and ncview:

	E.g. panoply: $ panoply.sh geo_em.d01.nc
	E.g. ncview: $ source common.reg
    		$ ncview geo_em.d01.nc

This can be a useful tool to make sure all the data is as expected before continuing to the wrf-lis coupled run.

The MERRA2:* and SSTRSS:* files are in the WPS intermediate format. These files are not readable by any of the more standard programs. To visualize the fields that are written in these files, a NCAR Command Language (ncl) script is available on the github ([open_wps.ncl](https://github.com/MortelmansJonas/NU-WRF_Peatlands/blob/master/Code/Postproc/open_wps.ncl)).
Before running this script, specify in the very first line of the file the file you want to check (wps_filename).
To run: 
	$ module load NCL/6.5.0-intel-2018a
	$ ncl open_wps.ncl
This prints the different fields of the file and some basic information. This can help you to check if the data is correct. 
**Note**: this is only necessary when you deviate from the standard merra2wrf.py and sst2wrf.py script or when in doubt. When following the standard protocols, these files don’t need to be checked separately.

Lastly, the WRF output files are also netCDF format, but they lack the .nc extension. To visualize them with panoply or ncview, you could just copy the file you want to see to another file and add the .nc extension:

	$ cp wrfout_d01_2015-05-15_00:00:00 wrfout_d01_2015-05-15_00:00:00.nc

To check all the output variables and global attributes of a file, ncdump can be used. E.g. to see what all the variables are, without checking the values:

	$ ncdump –v Times wrfout_d01_2015-05-15_00:00:00

This can be used to see if all the wanted variables are in there.

So far, all files are still separate for each time step and no further analysis based on all the available data for a certain domain is possible. To do so, a python file needs to be written, looping over all the files of a certain domain and extracting the wanted variables. You can store all the data in a new netCDF file with an additional time dimension (e.g. see [d01_nc.py](https://github.com/MortelmansJonas/NU-WRF_Peatlands/blob/master/Code/Postproc/d01_nc.py))

# Troubleshoot

When working at high latitudes or far inland, the SST from Remote Sensing Systems does not provide good data. To work arount this issue, follow these steps:

1. Get the following files from the $NUWRFDIR/WPS:
	1. link_grib.csh
	2. ungrib/g2print.exe
	3. ungrib.Variable_Tables/Vtable.SST (copy to a file called 'Vtable')
	4. ungrib/ungrib.exe
2. Download the data (as . nc files) you need from [PODAAC](https://podaac-tools.jpl.nasa.gov/drive/login?dest=L2RyaXZlL2ZpbGVzL09jZWFuVGVtcGVyYXR1cmUvZ2hyc3N0L2RhdGEvTDQ).
	You will need an account for this and follow their download instructions when using wget.
3. Run [the nc_to_grb.py script](https://github.com/MortelmansJonas/NU-WRF_Peatlands/blob/master/Code/Postproc/nc_to_grb.py). Make sure the paths are adapted to the location of your downloaded files.
4. From the command line, run (first load the module eccodes):
	$ grib_set -s typeOfGeneratingProcess=0,generatingProcessIdentifier=128,typeOfFirstFixedSurface=1,cfVarName=t SSTRSS:*.grb2 "out_[dataDate].grb2"
5. Run link_grib.csh from your $RUNDIR. The output should be GRIBFILE.AAA, GRIBFILE.BBB,… for as many files as you originally had. ‘out_*.grb2’ is the output of the previous step
	$ cd $RUNDIR
	$ ./link_grib.csh $PATH_TO_GRIBFILES/out_*.grb2 
6. Run g2print.exe to get the necessary information to put in the Vtable.
	$ ./g2print.exe $PATH_TO_GRIBFILES/out_*.grb2
7. Adapt the Vtable based on the printed information of the previous step. Make sure to put the correct level type, names,… because otherwise, METGRID won’t recognize the correct data.
8. Run ungrib.exe
	$ ./ungrib.exe

The output should be files like SSTRSS:*, one every 6 hours from the defined start time to the defined end time. These files are also in WPS intermediate format, readable by METGRID. The prefix ‘SSTRSS’ is defined in the namelist.wps file.
