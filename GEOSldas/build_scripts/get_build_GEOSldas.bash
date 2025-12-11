#!/bin/bash

ldas_version=17.11.1 # requires baselibs 8.2.13 only working on tier-1 currently, 17.11.0 working also for tier-2
ldas_root=/dodrio/scratch/projects/2022_200/project_output/rsda/vsc31786/src_code
# ldas_root=/staging/leuven/stg_00024/OUTPUT/michelb/src_code
# ldas_dirname=GEOSldas_${ldas_version}_CON_KUL # GEOSldas_${ldas_version}_TN
ldas_dirname=GEOSldas_${ldas_version}_KUL # GEOSldas_${ldas_version}_TN
GEOSldas_repo=mbechtold/GEOSldas.git  # mbechtold/GEOSldas.git
#GEOSldas_repo=mbechtold/GEOSldas.git  #kul-rsda/GEOSldas.git #sebastian-a-swm/GEOSldas.git  # mbechtold/GEOSldas.git
#GEOSldas_branch=v${ldas_version}_CON_KUL  # v${ldas_version}_TN_KUL
GEOSldas_branch=v${ldas_version}_KUL_seb  # v${ldas_version}_TN_KUL

if [[ $CONDA_DEFAULT_ENV == "" ]]; then
    echo "no python conda environment loaded ...."
    echo "loading py3 of Michel ..."
    source activate /data/leuven/317/vsc31786/miniconda/envs/py3
fi

# IMPORTANT: GEOSldas is pulled from the RSDA-KUL github repository,
# where a branch named ${ldas_version}_KUL is assumed to exist!

if [[ $ldas_version == "17.11.0" ]]; then
    baselibs_version=v6.2.8
elif [[ $ldas_version == "17.11.1" ]]; then
    baselibs_version=v6.2.13
elif [[ $ldas_version == "17.12.0" ]]; then
    baselibs_version=v7.7.0
fi
# IMPORTANT: staging is not cross-mounted, so the baselibs are installed at a
# different location on Tier-1!

# Set paths for Tier-1 or Tier-2
node=`uname -n`
if [[ $node == *"tier2"* ]] || [[ $node == "r"* ]]; then
    baselibs_root=/staging/leuven/stg_00024/GEOSldas_libraries
elif [[ $node == *"dodrio"* ]]; then
    baselibs_root=/dodrio/scratch/projects/2022_200/project_input/rsda/ldas/GEOSldas_libraries
    module load git
fi

# Check if LDAS directory already exists, otherwise pull from GitHub
cd $ldas_root
if [ ! -d "$ldas_dirname" ]; then
    git clone -b $GEOSldas_branch --single-branch git@github.com:$GEOSldas_repo $ldas_dirname
    cd $ldas_dirname
    mepo init
    mepo clone
    if [[ $ldas_version == "17.11.1" ]]; then
        cp $baselibs_root/g5_modules ./@env/
    elif [[ $ldas_version == "17.12.0" ]]; then
        cp $baselibs_root/g5_modules_v7.7.0 ./@env/
    fi
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
if [[ $node == *"tier2"* ]] || [[ $node == "r"* ]] ; then
    # Load modules for Tier-2
    module unuse /apps/leuven/skylake/2018a/modules/all
    module unuse /apps/leuven/cascadelake/2018a/modules/all
    module unuse /apps/leuven/cascadelake/2019b/modules/all
    module use /apps/leuven/skylake/2019b/modules/all
    module load foss flex Bison CMake Autotools texinfo gomkl Python/2.7.16-GCCcore-8.3.0
elif [[ $node == *"dodrio"* ]]; then
    # Load modules for Tier-1 UGENT on Hortense
    #module --force purge
    #module load cluster/dodrio/cpu_milan_rhel9
    module load foss/2023a
    module load flex/2.6.4-GCCcore-12.3.0
    module load Bison/3.8.2-GCCcore-12.3.0
    module load CMake/3.26.3-GCCcore-12.3.0
    module load Autotools/20220317-GCCcore-12.3.0
    #module load texinfo/6.8-GCCcore-11.2.0
    module load libtirpc/1.3.3-GCCcore-12.3.0
    # instead of: module load texinfo/6.8-GCCcore-11.2.0
    module load makeinfo/7.0.3-GCCcore-12.3.0
    MAKEINFO_BIN=/readonly/dodrio/apps/RHEL9/zen3-ib/software/makeinfo/7.0.3-GCCcore-12.3.0/bin/makeinfo
    module load Python/2.7.18-GCCcore-12.3.0
    module load imkl/2023.1.0
    
    #module load foss/2023b
    #module load flex/2.6.4-GCCcore-13.2.0
    #module load Bison/3.8.2-GCCcore-13.2.0
    #module load CMake/3.27.6-GCCcore-13.2.0
    #module load Autotools/20220317-GCCcore-13.2.0
    ##module load texinfo/6.8-GCCcore-11.2.0
    #module load libtirpc/1.3.4-GCCcore-13.2.0
    ## instead of: module load texinfo/6.8-GCCcore-11.2.0
    #module load makeinfo/7.1-GCCcore-13.2.0
    #MAKEINFO_BIN=$(command -v makeinfo || which makeinfo 2>/dev/null)
    #MAKEINFO_BIN=/readonly/dodrio/apps/RHEL9/zen3-ib/software/makeinfo/7.1-GCCcore-13.2.0/bin/makeinfo
    #module load Python/3.11.5-GCCcore-13.2.0
    #module load imkl/2023.1.0
    FFLAGS=-mavx2
    FCFLAGS=-mavx2
    # --- sanity check: is cmake actually available? ---
    echo "Loaded modules on dodrio:"
    module list

    CMAKE_BIN=$(command -v cmake || which cmake 2>/dev/null)
    if [ -z "$CMAKE_BIN" ]; then
        echo "ERROR: cmake not found in PATH after loading CMake module"
        echo "Try 'module avail CMake' interactively and adjust the module name in the script."
        exit 1
    fi
    export CMAKE="$CMAKE_BIN"
    echo "Using CMAKE=$CMAKE"
    export CMAKE_COMMAND=$CMAKE_BIN
    export PATH=$(dirname $CMAKE_BIN):$PATH

    #MAKEINFO_BIN=$(command -v makeinfo || which makeinfo 2>/dev/null)
    MAKEINFO_BIN=/readonly/dodrio/apps/RHEL9/zen3-ib/software/makeinfo/7.0.3-GCCcore-12.3.0/bin/makeinfo
    if [ -z "$MAKEINFO_BIN" ]; then
        echo "ERROR: makeinfo not found even after loading module"
        exit 1
    fi
    export MAKEINFO="$MAKEINFO_BIN"
    echo "Using MAKEINFO=$MAKEINFO"

else
    echo "Platform not known ... stopping"
    exit 1
fi

# Set required environmental variables for GEOSldas build
if [[ $baselibs_version == "v6.2.8" ]]; then
    export BASEDIR=$baselibs_root/ESMA-Baselibs-${baselibs_version}/src/Linux
else
    export BASEDIR=$baselibs_root/ESMA-Baselibs-${baselibs_version}/Linux
fi
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$BASEDIR/lib

if [[ $node == *"dodrio"* ]]; then
    cd ..
    find @cmake/@ecbuild/cmake/compiler_flags/* -name "GNU_Fortran.cmake" -type f -exec sed -i 's/\"-O/\"-mavx2 -O/g' {} \;
    find @cmake/compiler/flags/* -name "GNU_Fortran.cmake" -type f -exec sed -i 's/set (common_Fortran_fpe_flags \"-ffpe-trap\=zero,overflow/set (common_Fortran_fpe_flags \"-mavx2 -ffpe-trap\=zero,overflow/g' {} \;
    cd build${ext} 
fi
# Build and install
cmake .. -DBASEDIR=$BASEDIR -DCMAKE_Fortran_COMPILER=gfortran -DCMAKE_INSTALL_PREFIX=../install${ext} -DCMAKE_BUILD_TYPE=${buildtype}
#make -j6 install CMAKE="$CMAKE_BIN" CMAKE_COMMAND="$CMAKE_BIN" MAKEINFO="$MAKEINFO"
make -j6 install 
