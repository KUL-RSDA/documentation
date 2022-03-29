
## Data

The following provides a summary of data sets stored by Alexander Gruber on the HPC. Contents are explained in more detail in the README files located within the respective directories.

### Tier-2

The following directories on Tier-2 are associated with Alexander Gruber's work:

#### GEOS5 input

- `/staging/leuven/stg_00024/GEOSldas_libraries`

This directory containes the "Baselibs" libraries necessary to run GEOSldas. Different versions are available as required by different GEOSldas versions.

- `/staging/leuven/stg_00024/input/RTM_params/CLSM_versionAlex`

This directory contains radiative transfer model parameters for SMAP Tb data assimilation. These have been obtained from Rolf Reichle and are associated with the SMAP L4 v004 product.

- `/staging/leuven/stg_00024/l_data/model_param/geos5/bcs/CLSM_versionAlex`

This directory contains CLSM boundary conditions for GEOSldas that have been used for SMAP Tb DA.

- `/staging/leuven/stg_00024/l_data/model_param/geos5/bcs/Catchment_CN_versionAlex`

This directory contains Catchment-CN boundary conditions for GEOSldas.

#### GEOS5 output

- `/staging/leuven/stg_00024/OUTPUT/alexg/GEOSldas/config`

This directory contains configuration files for running GEOSldas.

- `/staging/leuven/stg_00024/OUTPUT/alexg/GEOSldas/observation_perturbations`

This directory contains observation perturbation files for GEOSldas.

- `/staging/leuven/stg_00024/OUTPUT/alexg/GEOSldas/scaling_files`

This directory contains observation rescaling files for GEOSldas.

- `/staging/leuven/stg_00024/OUTPUT/alexg/GEOSldas/spinups_and_restarts`

This directory contains various deterministic and ensemble spinup runs and restart files for GEOSldas.

- `/staging/leuven/stg_00024/OUTPUT/alexg/LDASsa/config`

This directory contains configuration files for running LDASsa.

- `/staging/leuven/stg_00024/OUTPUT/alexg/LDASsa/scaling_files`

This directory contains observation rescaling files for LDASsa.

- `/staging/leuven/stg_00024/OUTPUT/alexg/LDASsa/spinups_and_restarts`

This directory contains various deterministic and ensemble spinup runs and restart files for LDASsa.

#### Miscellaneous

- `/staging/leuven/stg_00024/OUTPUT/alexg/data_sets`

This directory contains various other satellite and model data sets that have been used by Alexander Gruber for various analyses.

### Tier-1

The following directories on Tier-1 are associated with Alexander Gruber's work:

#### GEOS5 input

- `/scratch/leuven/projects/lt1_2020_es_pilot/project_input/ldas/GEOSldas_libraries`

This directory containes the "Baselibs" libraries necessary to run GEOSldas. Different versions are available as required by different GEOSldas versions.

- `/scratch/leuven/projects/lt1_2020_es_pilot/project_input/rsda/l_data/model_param/geos5/RTM_params/CLSM_versionAlex`

This directory contains radiative transfer model parameters for SMAP Tb data assimilation. These have been obtained from Rolf Reichle and are associated with the SMAP L4 v004 product.

- `/scratch/leuven/projects/lt1_2020_es_pilot/project_input/rsda/l_data/model_param/geos5/bcs/CLSM_versionAlex`

This directory contains CLSM boundary conditions for GEOSldas that have been used for SMAP Tb DA.

- `/scratch/leuven/projects/lt1_2020_es_pilot/project_input/rsda/l_data/model_param/geos5/bcs/Catchment_CN_versionAlex`

This directory contains Catchment-CN boundary conditions for GEOSldas.

#### GEOS5 output

- `/scratch/leuven/projects/lt1_2020_es_pilot/project_output/rsda/vsc32046/GEOSldas/config`

This directory contains configuration files for running GEOSldas.

- `/scratch/leuven/projects/lt1_2020_es_pilot/project_output/rsda/vsc32046/GEOSldas/spinups_and_restarts`

This directory contains various deterministic and ensemble spinup runs and restart files for GEOSldas.

- `/scratch/leuven/projects/lt1_2020_es_pilot/project_output/rsda/vsc32046/CatchmentCN/`

This directory contains the output from a Catchment-CN run (monthly output) obtained from Jana Kolassa, which has been created using both LDASsa (before January 2020) and GEOSldas (after January 2020).

## Source code

### GEOSldas

[GEOSldas](https://github.com/GEOS-ESM/GEOSldas) source code developments have been made on the GEOSldas fork of the KUL-RSDA GitHub account [here](https://github.com/KUL-RSDA/GEOSldas).

To run GEOSldas on the HPC, a few alterations to the NASA source code are necessary. For each NASA release that has been modified to run on the HPC, a branch has been created named after the NASA release version succeeded by a '_KUL'

For example, an altered version of the GEOS-ESM/GEOSldas release [v17.11.0](https://github.com/GEOS-ESM/GEOSldas/releases/tag/v17.11.0) that is running on the HPC is available via the KUL-RSDA/GEOSldas branch ['v17.11.0_KUL'](https://github.com/KUL-RSDA/GEOSldas/tree/v17.11.0_KUL).

An exhaustive documentation on GEOSldas and how to run it on the HPC is available on the KUL-RSDA GitHub documentation page [here](https://github.com/KUL-RSDA/documentation/blob/master/GEOSldas/GEOSldas_on_HPC.md).

The `pyldas` package used for LDASsa and GEOSldas post-processing has been transferred to the KUL-RSDA GitHub account and can be found [here](https://github.com/KUL-RSDA/pyldas). It is documented thoroughly on the repository page and in-line via docstrings.

### Other

All other source code developments for KU Leuven / FWO made by Alexander Gruber are available on his personal GitHub account [here](https://github.com/alexgruber), specifically within the `myprojects` repository [here](https://github.com/alexgruber/myprojects).

The source code status as of the last day of employment has been tagged as `snapshot_20220328`.

This code snapshot can be obtained as a zip or tarball archive [here](https://github.com/alexgruber/myprojects/releases/tag/snapshot_20220328), or cloned via:

`git clone git@github.com:alexgruber/myprojects.git --single-branch --branch snapshot_20220328`

For further inquiries, please contact reddy.gruber@gmail.com  
