#!/bin/bash
#PBS -l nodes=r23i13n23:ppn=3
#PBS -W group_list=lees_swm_ls_ext
#PBS -l pmem=5gb
#PBS -A lp_ees_swm_ls_001
#PBS -l walltime=23:59:59
#PBS -m abe
#PBS -M alexander.gruber@kuleuven.be
#PBS -o ./log.txt
#PBS -e ./out.txt

version=6.1.0
# IMPORTANT: staging is not cross-mounted, so the baselibs are installed at a
# different location on Tier-1!

# Load modules and set paths for Tier-1 or Tier-2
node=`uname -n`
module purge
if [[ $node == "r"[0-1]* ]] || [[ $node == "login"* ]]; then
    echo "Loading modules for Tier-1..."
    root=/scratch/leuven/projects/lt1_2020_es_pilot/project_input/rsda/GEOSldas_libraries
    module unuse /apps/leuven/broadwell/2016a/modules/all
    module unuse /apps/leuven/broadwell/2018a/modules/all
else
    echo "Loading modules for Tier-2..."
    root=/staging/leuven/stg_00024/GEOSldas_libraries
    module unuse /apps/leuven/skylake/2018a/modules/all
    module unuse /apps/leuven/cascadelake/2018a/modules/all
    module unuse /apps/leuven/cascadelake/2019b/modules/all
    module use /apps/leuven/skylake/2019b/modules/all
fi
module load foss flex Bison CMake Autotools texinfo

# Download Baselibs from GitHub
cd $root
wget https://github.com/GEOS-ESM/ESMA-Baselibs/releases/download/v${version}/ESMA-Baselibs-${version}.COMPLETE.tar.xz
tar -xf ESMA-Baselibs-${version}.COMPLETE.tar.xz
rm -f ESMA-Baselibs-${version}.COMPLETE.tar.xz
cd ESMA-Baselibs-${version}/src
mkdir Linux

# Build Baselibs
export FC=gfortran
make install ESMF_COMM=openmpi prefix=$root/ESMA-Baselibs-${version}/src/Linux

# This is just to check if the installation succeeded for all the modules.
export ESMF_COMM=openmpi
make verify
