#!/bin/bash
#PBS -l nodes=r23i13n23:ppn=1
#PBS -W group_list=lees_swm_ls_ext
#PBS -l pmem=5gb
#PBS -A lp_ees_swm_ls_001
#PBS -l walltime=23:59:59
#PBS -m abe
#PBS -M alexander.gruber@kuleuven.be
#PBS -o ./log.txt
#PBS -e ./out.txt

ldas_root=/data/leuven/320/vsc32046/src_code/Tier1_test
ldas_dirname=GEOSldas_17.9.3
ldas_version=17.9.3

baselibs_version=6.1.0
# IMPORTANT: staging is not cross-mounted, so the baselibs are installed at a
# different location on Tier-1!

# Load modules and set paths for Tier-1 or Tier-2
node=`uname -n`
module purge
if [[ $node == "r"[0-1]* ]] || [[ $node == "login"* ]]; then
    baselibs_root=/scratch/leuven/projects/lt1_2020_es_pilot/project_input/rsda/GEOSldas_libraries
    module unuse /apps/leuven/broadwell/2016a/modules/all
    module unuse /apps/leuven/broadwell/2018a/modules/all
else
    baselibs_root=/staging/leuven/stg_00024/GEOSldas_libraries
    module unuse /apps/leuven/skylake/2018a/modules/all
    module unuse /apps/leuven/cascadelake/2018a/modules/all
    module unuse /apps/leuven/cascadelake/2019b/modules/all
    module use /apps/leuven/skylake/2019b/modules/all
fi
module load foss flex Bison CMake Autotools texinfo gomkl Python/2.7.16-GCCcore-8.3.0

# Check if to build in debug mode
if [[ "$#" -gt 0 ]] && [[ "$1" == "debug" ]]; then
    echo "Building GEOSldas in debug mode...."
    ext='_debug'
    buildtype='Debug'
else
    echo "Building GEOSldas in release mode...."
    ext=''
    buildtype='Release'
fi

# Check if LDAS directory already exists, otherwise pull from GitHub
cd $ldas_root
if [ ! -d "$ldas_dirname" ]; then
    module load git
    git clone -b v$ldas_version --single-branch git@github.com:GEOS-ESM/GEOSldas.git $ldas_dirname
    cd $ldas_dirname
    mepo init
    mepo clone
else
    echo "$ldas_dirname already exists. Skipping to build/install..."
    cd $ldas_dirname
fi

# Delete old builds/installation
if [ -d "install${ext}" ]; then
    echo "Deleting old installation..."
    rm -rf install${ext}
fi
if [ -d "build${ext}" ]; then
    echo "Deleting old build..."
    cd build${ext}
    rm -f *
else
    echo "Creating new build directory..."
    mkdir build${ext}
    cd build${ext}
fi

# Set required environmental variables for GEOSldas build
export BASEDIR=$baselibs_root/ESMA-Baselibs-${baselibs_version}/src/Linux
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$BASEDIR/lib

# Build and install
cmake .. -DBASEDIR=$BASEDIR -DCMAKE_Fortran_COMPILER=gfortran -DCMAKE_INSTALL_PREFIX=../install${ext} -DCMAKE_BUILD_TYPE=${buildtype}
make -j6 install
