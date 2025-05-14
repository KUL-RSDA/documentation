---
author:
- |
    Michel Bechtold
    (`michel.bechtold@kuleuven.be`)
---

  ----------- -------------- ---------------------------------------------------------------------------------------------------------
  version 1   - 13 August 2021   Michel Bechtold: Initial documentation
  version 2   - 17 Januari 2023  Jonas Mortelmans: Adaptations to Hortense
  ----------- -------------- ---------------------------------------------------------------------------------------------------------



Get Started: Tier-1 and iRODS
======================

KU Leuven Tier-1 cluster (Hortense):

-   Documentation: [Hortense infrastructure](https://docs.vscentrum.be/en/latest/gent/tier1_hortense.html)

* VSC groups: You have to be part of (check for your account https://account.vscentrum.be/django//):
  * gpr_compute_2022_200: Tier-1 collaborate project (These computational credits should be used, see below)

iRODS: A VSC Data component in pilot phase:

-   iRODS documentation: <https://github.com/hpcleuven/iRODS-User-Training/>

* iRODS groups: You need to be part of the iRODs groups lt1_es2020 and research-rsda which are not listed on https://account.vscentrum.be/django// (it seems there is no webpage where you could check this). Try to access the iRODs folder in research-rsda as described in this documentation. If you don't have access ask data@vscentrum.be to add you to these iRODs groups.

Tier-1 support / iRODS support: data@vscentrum.be (Ingrid Barcena Roig, Mustafa Dikmen, Jef Scheepersget)
Tier-1 Hortense support: compute@vscentrum.be


Tier-1 collaborative project gpr_compute_2022_200
======================

gpr_compute_2022_200 is a Tier-1 collaborate project (https://www.vscentrum.be/compute). We share resources (storage, credits) with collaborating partners. The partnering research groups are:

Prof. Dr. Wim Thiery, wim.thiery@vub.be, Prof. Dr. Nicole van Lipzig, nicole.vanlipzig@kuleuven.be, Prof. Dr. Gabrielle De Lannoy, gabrielle.delannoy@kuleuven.be, Prof. Dr. Diego G. Miralles, diego.miralles@ugent.be, Prof. Dr. Piet Termonia, piet.termonia@ugent.be

Credit Manager: Jonas Van de Walle <jonas.vandewalle@kuleuven.be> (group Nicole van Lipzig)

iRODS
======================

The VSC data component iRODS serves us

* to transfer datasets from Tier-2 staging and scratch to Tier-1 scratch, and
* to store large datasets that are not permanently used on either Tier-1 and Tier-2. Datasets that are permanently used on either Tier-2 or Tier-1 should be on staging (Tier-2) or scratch (Tier-1). See below for the information on the Tier-1 scratch and how it differs from Tier-2. 

Connecting to iRODS via globus
-----------------
One way to connect to iRODS is via the globus web interface.

https://app.globus.org/

You have to login with your KU Leuven credentials.
Then choose collection

"VSC iRODS vsc-climate.irods.hpc.kuleuven.be"

And put the path

/vsc_climate/home/rsda/

On the other side you can connect to tier1 and tier2 scratch collections (via /project/stg_00024/ you can access staging!) for data transfer. Rest should be self-explaining. 
  
Connecting to iRODS via icommands (needs documentation update)
-----------------
One way to work on iRODs are the 'i' commands that mostly have an equivalent bash command, see [iRODS documentation](https://github.com/hpcleuven/iRODS-User-Training/)

To start an iRODS session:

    $ irods-setup | bash

Go to research-rsda directory:

    $ icd /kuleuven_tier1_pilot/home/research-rsda/

Show content of research-rsda directory:

    $ ils /kuleuven_tier1_pilot/home/research-rsda/
    
To transfer data to and from iRODS, see [iRODS documentation](https://github.com/hpcleuven/iRODS-User-Training/).
Like rsync, there is an irsync that allows the use of asterisk
irsync TIERFOLDER/*PATTERN* i:iRODsFOLDER
   
Directory and File Structure {#sec:structure}
-----------------
On the iRODS research-rsda, there is currently only the OUTPUT directory with user directories.
The rsda iRODS quota is currently 110 TB.

Tier-1 connection, credits, storage
======================
  
OnDemand to Tier-1
-----------------

-   Instead of nx like you have for Tier-2, Tier-1 Hortense uses the web interface [OnDemand](https://tier1.hpc.ugent.be/pun/sys/dashboard).

-   Before you log in to OnDemand, open the [firewall](https://firewall.vscentrum.be/) to allow your computer to connect to the VSC cluster.

-   Log in with your KULeuven account that is linked to your vsc account. 

ssh connection to Tier-1 (e.g. with putty)
-----------------

    $ ssh -X <yourvscnumber>@tier1.hpc.ugent.be
  
Credits 
-----------------

*  There is no 'group node' on Tier-1.

*  Transfer of data from iRODS can be done on the login node. 

*  Collaborative credits: -A 2022_200

*  Maximum walltime on Tier-1 is 3 days. 

*  Example to get onto an interactive node for 24 hours:
  
    $ qsub -I -X -A 2022_200 -l walltime=24:00:00

Storage: Tier-1 SCRATCH (600 TB for all collaborators)
-----------------

  Each user: `$VSC_SCRATCH` (3 GB)
  
  gpr_compute_2022_200: `/scratch/leuven/projects/lt1_2020_es_pilot` (600 TB for all collaborators)

## To check available storage of gpr_compute_2022_200
    $ my_dodrio_quota

Note: No deletion of files after one month like on Tier-2. There is no staging on Tier-1. So scratch needs regular clean-up by the users.

## Directory structure of the group SCRATCH gpr_compute_2022_200
    $ cd /dodrio/scratch/projects/2022_200
    $ ls
    
### Relevant folders for rsda:
    $ External
    similar to the tier-2 l_data and input on /staging/leuven/stg_00024/
    
    $ project_input/rsda
    project-specific inputs that is not of interest to other research groups 
    like e.g. code, libraries, model-specific input data. Every project input that 
    is potentially of interest for other groups should be in External.
    
    $ project_output
    Simulation/Processing outputs
    

Other notes
======================

## iRODs: Recovery of deleted files
for 15 days files are in a trash directory:
/kuleuven_tier1_pilot/trash/home/vsc31786/research-rsda/
and can be recovered ... unless you deleted it with the -f option.

## iRODs: Check storage usage
to check storage use of a directory including subdirectories:
$ iquest "select sum(DATA_SIZE) where COLL_NAME like '/kuleuven_tier1_pilot/home/research-rsda%'"

## Mounted directories on Tier-1
    $ /data/leuven 
    $ /user/leuven 

## Hortense: Log files of Python jobs
By default, print statements in submitted jobs will not appear in the log file. To force this two things need to be implemented:
    in the PBS script: $ export PYTHONBUFFERED=1
    in your python script, after the last print statement (or the ones in a loop): sys.stdout.flush()

## Code
*  Some of the Tier-2 compiled code on /data/leuven might work on Tier-1, e.g. a miniconda python environment. 
*  For intensive CPU usage it is best to ensure that the you are using Intel Math Kernel Library (MKL, https://vlaams-supercomputing-centrum-vscdocumentation.readthedocs-hosted.com/en/latest/software/intel_toolchain.html) 
*  For usage of MPI, it's best to rebuild the environment on Tier-1."
