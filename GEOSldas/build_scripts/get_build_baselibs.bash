#!/bin/bash

version=6.2.13
# IMPORTANT: staging is not cross-mounted, so the baselibs are installed at a
# different location on Tier-1!

if [[ $CONDA_DEFAULT_ENV == "" ]]; then
    echo "no python conda environment loaded ...."
    echo "loading py3 of Michel ..."
    source activate /data/leuven/317/vsc31786/miniconda/envs/py3
fi

# Load modules and set paths for Tier-1 or Tier-2
node=`uname -n`
module purge
if [[ $node == "tier2"* ]]; then 
    echo "Loading modules for Tier-2..."
    root=/staging/leuven/stg_00024/GEOSldas_libraries
    module unuse /apps/leuven/skylake/2018a/modules/all
    module unuse /apps/leuven/cascadelake/2018a/modules/all
    module unuse /apps/leuven/cascadelake/2019b/modules/all
    module use /apps/leuven/skylake/2019b/modules/all
    module load foss flex Bison CMake Autotools texinfo
elif [[ $node == *"dodrio"* ]]; then
    echo "Deleting old baselib compilation run of this version"
    root=/dodrio/scratch/projects/2022_200/project_input/ldas/GEOSldas_libraries
    rm -rf $root/ESMA-Baselibs-v${version}
    mkdir -p $root/ESMA-Baselibs-v${version}
    echo "Loading modules for Hortense Tier-1..."
    module --force purge
    module load cluster/dodrio/cpu_rome
    module load foss flex/2.6.4-GCCcore-11.3.0 Bison CMake Autotools texinfo libtirpc/1.3.2-GCCcore-11.3.0
else
    echo "Unknown platform ... stopping"
    exit 1
fi

# Download Baselibs from GitHub
cd $root
wget https://github.com/GEOS-ESM/ESMA-Baselibs/releases/download/v${version}/ESMA-Baselibs-v${version}.COMPLETE.tar.xz
tar -xf ESMA-Baselibs-v${version}.COMPLETE.tar.xz
rm -f ESMA-Baselibs-v${version}.COMPLETE.tar.xz
# for version 6.2.13
cd $root/ESMA-Baselibs-v${version}

# temporary fix since 6.2.13 baselibs were not complete: getting full FLAP from 6.2.8
rm -r $root/ESMA-Baselibs-v${version}/FLAP
cd $root
wget https://github.com/GEOS-ESM/ESMA-Baselibs/releases/download/v6.2.8/ESMA-Baselibs-v6.2.8.COMPLETE.tar.xz
tar -xf ESMA-Baselibs-v6.2.8.COMPLETE.tar.xz
rm -f ESMA-Baselibs-v6.2.8.COMPLETE.tar.xz
cp -r ESMA-Baselibs-v6.2.8/src/FLAP ESMA-Baselibs-v${version}/.
rm -rf ESMA-Baselibs-v6.2.8

cd $root/ESMA-Baselibs-v${version}
mkdir Linux
if [[ $node == *"dodrio"* ]]; then
    # tirpc library in strange place for hortense, added to Arch.mk to be found
    find Arch.mk -type f -exec sed -i '/Fedora/i # To find tirpc on Hortense' {} \;
    find Arch.mk -type f -exec sed -i '/Fedora/i INC_EXTRA += -I$(EBROOTLIBTIRPC)\/include\/tirpc' {} \;
    find Arch.mk -type f -exec sed -i '/Fedora/i LIB_EXTRA += -ltirpc' {} \;
fi

# Build Baselibs
export FC=gfortran
make install ESMF_COMM=openmpi prefix=$root/ESMA-Baselibs-v${version}/Linux

# This is just to check if the installation succeeded for all the modules.
export ESMF_COMM=openmpi
make verify
