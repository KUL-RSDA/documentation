#!/bin/bash

#version=6.2.8 # working for tier-1 and tier-2

# working only fier tier-1 currently (texinfo needed for 2021 tier-2 toolchain)
version=6.2.13

#version=7.7.0 # working only fier tier-1 currently (texinfo needed for 2021 tier-2 toolchain)

# IMPORTANT: staging is not cross-mounted, so the baselibs are installed at a
# different location on Tier-1!

# Load modules and set paths for Tier-1 or Tier-2
node=`uname -n`
module purge
if [[ $node == "tier2"* ]] || [[ $node == "r"* ]]; then 
    root=/staging/leuven/stg_00024/GEOSldas_libraries
    if [ -d "${root}/ESMA-Baselibs-v${version}" ]; then
        echo "$root/ESMA-Baselibs-v${version} already exists, first delete ... stopping."
        exit 1
    fi
    mkdir -p $root/ESMA-Baselibs-v${version}
    echo "Loading modules for Tier-2..."
    module unuse /apps/leuven/skylake/2018a/modules/all
    module unuse /apps/leuven/cascadelake/2018a/modules/all
    module unuse /apps/leuven/cascadelake/2019b/modules/all
    module use /apps/leuven/skylake/2019b/modules/all
    module load foss flex Bison CMake Autotools texinfo
elif [[ $VSC_INSTITUTE_CLUSTER == "dodrio" ]]; then
    root=/dodrio/scratch/projects/2022_200/project_input/rsda/ldas/GEOSldas_libraries
    if [ -d "${root}/ESMA-Baselibs-v${version}" ]; then
        echo "$root/ESMA-Baselibs-v${version} already exists, first delete ... stopping."
        exit 1
    fi
    mkdir -p $root/ESMA-Baselibs-v${version}
    echo "Loading modules for Hortense Tier-1..."
    #module --force purge
    #module swap cluster/dodrio/cpu_milan_rhel9
    module load foss/2023a
    module load flex/2.6.4-GCCcore-12.3.0
    module load Bison/3.8.2-GCCcore-12.3.0
    module load CMake/3.26.3-GCCcore-12.3.0
    module load Autotools/20220317-GCCcore-12.3.0
    #module load texinfo/6.8-GCCcore-11.2.0
    module load libtirpc/1.3.3-GCCcore-12.3.0
    # instead of: module load texinfo/6.8-GCCcore-11.2.0
    module load makeinfo/7.0.3-GCCcore-12.3.0
    
    #module load foss/2023b
    #module load flex/2.6.4-GCCcore-13.2.0
    #module load Bison/3.8.2-GCCcore-13.2.0
    #module load CMake/3.27.6-GCCcore-13.2.0
    #module load Autotools/20220317-GCCcore-13.2.0
    ##module load texinfo/6.8-GCCcore-11.2.0
    #module load libtirpc/1.3.4-GCCcore-13.2.0
    ## instead of: module load texinfo/6.8-GCCcore-11.2.0
    #module load makeinfo/7.1-GCCcore-13.2.0

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
if [[ $version == *"6.2.13"* ]] || [[ $version == *"7.7.0"* ]]; then
    echo "Getting FLAP from 6.2.8"
    rm -r $root/ESMA-Baselibs-v${version}/FLAP
    mkdir $root/temp
    cd $root/temp
    wget https://github.com/GEOS-ESM/ESMA-Baselibs/releases/download/v6.2.8/ESMA-Baselibs-v6.2.8.COMPLETE.tar.xz
    tar -xf ESMA-Baselibs-v6.2.8.COMPLETE.tar.xz
    rm -f ESMA-Baselibs-v6.2.8.COMPLETE.tar.xz
    cp -r ESMA-Baselibs-v6.2.8/src/FLAP $root/ESMA-Baselibs-v${version}/.
    cd $root
    rm -rf $root/temp
fi

if [[ $version == *"6.2.8"* ]]; then
    cd $root/ESMA-Baselibs-v${version}/src
elif [[ $version == *"6.2.13"* ]] || [[ $version == *"7.7.0"* ]]; then
    cd $root/ESMA-Baselibs-v${version}
fi
mkdir Linux
if [[ $VSC_INSTITUTE_CLUSTER == "dodrio" ]]; then
    # tirpc library in strange place for hortense, added to Arch.mk to be found
    find Arch.mk -type f -exec sed -i '/Fedora/i # To find tirpc on Hortense' {} \;
    TIRPC_ROOT=/readonly/dodrio/apps/RHEL9/zen2-ib/software/libtirpc/1.3.3-GCCcore-12.3.0
    find Arch.mk -type f -exec sed -i "/Fedora/i INC_EXTRA += -I${TIRPC_ROOT//\//\\/}\/include\/tirpc" {} \;
    find Arch.mk -type f -exec sed -i "/Fedora/i LIB_EXTRA += -L${TIRPC_ROOT//\//\\/}\/lib -ltirpc" {} \;
    #find Arch.mk -type f -exec sed -i '/Fedora/i INC_EXTRA += -I$(EBROOTLIBTIRPC)\/include\/tirpc' {} \;
    #find Arch.mk -type f -exec sed -i '/Fedora/i LIB_EXTRA += -ltirpc' {} \;
    find Arch.mk -type f -exec sed -i '/Fedora/i       FFLAGS += -mavx2 -O3' {} \;
    find Arch.mk -type f -exec sed -i '/Fedora/i       FCFLAGS += -mavx2 -O3' {} \;
    find Arch.mk -type f -exec sed -i '/Fedora/i       NAG_FCFLAGS += -mavx2 -O3' {} \;
    find -name "build_rules.mk" -type f -exec sed -i 's/ESMF_OPTLEVELDEFAULT  = 0/ESMF_OPTLEVELDEFAULT  = 3/g' {} \;
    find -name "makefile" -type f -exec sed -i 's/ESMF_OPTLEVEL = 0/ESMF_OPTLEVEL = 3/g' {} \;
    find -name "*" -type f -exec sed -i 's/-fallow-argument-mismatch -O/-fallow-argument-mismatch/g' {} \;
    #find . -name 'esmf_rules.mk' -type f -exec \
    #sed -i '/src\/addon\/ESMPy/ s/^/# DISABLE ESMPy: /' {} \;
fi

# Build Baselibs
export FC=gfortran
echo $version
if [[ $version == *"6.2.8"* ]]; then
    echo "Compiling ..................."
    make install ESMF_COMM=openmpi prefix=$root/ESMA-Baselibs-v${version}/src/Linux
elif [[ $version == *"6.2.13"* ]] || [[ $version == *"7.7.0"* ]]; then
    echo "Compiling ..................."
    #make install ESMF_COMM=openmpi prefix=$root/ESMA-Baselibs-v${version}/Linux
    make install ESMF_COMM=openmpi CMAKE="$CMAKE_BIN" CMAKE_COMMAND="$CMAKE_BIN" \
        MAKEINFO="$MAKEINFO" prefix=$root/ESMA-Baselibs-v${version}/Linux
fi

# This is just to check if the installation succeeded for all the modules.
export ESMF_COMM=openmpi
make verify
