#!/bin/bash

ldas_root=/data/leuven/320/vsc32046/src_code
ldas_version=17.11.0
# IMPORTANT: GEOSldas is pulled from the RSDA-KUL github repository,
# where a branch named ${ldas_version}_KUL is assumed to exist!

baselibs_version=v6.2.8
# IMPORTANT: staging is not cross-mounted, so the baselibs are installed at a
# different location on Tier-1!

# Set paths for Tier-1 or Tier-2
node=`uname -n`
if [[ $node == "r"[0-1]* ]] || [[ $node == "login"* ]]; then
    baselibs_root=/scratch/leuven/projects/lt1_2020_es_pilot/project_input/ldas/GEOSldas_libraries
    ldas_dirname=GEOSldas_${ldas_version}_Tier1_skylake
    module load git
else
    baselibs_root=/staging/leuven/stg_00024/GEOSldas_libraries
    ldas_dirname=GEOSldas_${ldas_version}_Tier2
fi

# Check if LDAS directory already exists, otherwise pull from GitHub
cd $ldas_root
if [ ! -d "$ldas_dirname" ]; then
    git clone -b v${ldas_version}_KUL --single-branch git@github.com:KUL-RSDA/GEOSldas.git $ldas_dirname
    cd $ldas_dirname
    git remote rename origin upstream
    git remote add origin git@github.com:GEOS-ESM/GEOSldas.git
    mepo init
    mepo clone
    cp $baselibs_root/g5_modules ./@env/
else
    echo "$ldas_dirname already exists. Skipping to build/install..."
    cd $ldas_dirname
fi

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

# Delete old builds/installation
if [ -d "install${ext}" ]; then
    echo "Deleting old installation..."
    rm -rf install${ext}
fi
if [ -d "build${ext}" ]; then
    echo "Deleting old build..."
    cd build${ext}
    rm -rf *
else
    echo "Creating new build directory..."
    mkdir build${ext}
    cd build${ext}
fi

# Load modules for Tier-1 or Tier-2
module purge
if [[ $node == "r0"* ]] || [[ $node == "login"* ]]; then
    module unuse /apps/leuven/broadwell/2016a/modules/all
    module unuse /apps/leuven/broadwell/2018a/modules/all
elif [[ $node == "r1"* ]]; then
    module unuse /apps/leuven/skylake/2016a/modules/all
    module unuse /apps/leuven/skylake/2018a/modules/all
else
    module unuse /apps/leuven/skylake/2018a/modules/all
    module unuse /apps/leuven/cascadelake/2018a/modules/all
    module unuse /apps/leuven/cascadelake/2019b/modules/all
    module use /apps/leuven/skylake/2019b/modules/all
fi
module load foss flex Bison CMake Autotools texinfo gomkl Python/2.7.16-GCCcore-8.3.0

# Set required environmental variables for GEOSldas build
export BASEDIR=$baselibs_root/ESMA-Baselibs-${baselibs_version}/src/Linux
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$BASEDIR/lib

# Build and install
cmake .. -DBASEDIR=$BASEDIR -DCMAKE_Fortran_COMPILER=gfortran -DCMAKE_INSTALL_PREFIX=../install${ext} -DCMAKE_BUILD_TYPE=${buildtype}
make -j6 install
