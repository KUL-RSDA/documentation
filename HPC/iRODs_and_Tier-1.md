---
author:
- |
    Michel Bechtold
    (`michel.bechtold@kuleuven.be`)
---

  ----------- -------------- ---------------------------------------------------------------------------------------------------------
  version 1   - 13 August 2021   Michel Bechtold: Initial documentation
  ----------- -------------- ---------------------------------------------------------------------------------------------------------



Get Started: Tier-1 and iRODS
======================

KU Leuven Tier-1 cluster (Breniac):

-   Documentation: [Breniac infrastructure](https://vlaams-supercomputing-centrum-vscdocumentation.readthedocs-hosted.com/en/latest/leuven/tier1_hardware/breniac_hardware.html)

-   Documentation: [Quickstart guide Breniac](https://vlaams-supercomputing-centrum-vscdocumentation.readthedocs-hosted.com/en/latest/leuven/breniac_quickstart.html)

* iRODS groups: You have to be part of (check for your account https://account.vscentrum.be/django//):
  * lt1_breniacusers: for basic tier-1 (breniac system) access
  * lt1_col_2021_1: Tier-1 collaborate project (see below)
  * lt1_es2020: Tier-1 collaborate project

iRODS: A VSC Data component in pilot phase:

-   iRODS documentation: <https://github.com/hpcleuven/iRODS-User-Training/>

* iRODS groups: You need to be part of the iRODs groups lt1_es2020 and research-rsda which are not listed on https://account.vscentrum.be/django// (it seems there is no webpage where you could check this). Try to access the iRODs folder in research-rsda as described in this documentation. If you don't have access ask data@vscentrum.be to add you to these iRODs groups.

Tier-1 support / iRODS support: data@vscentrum.be (Ingrid Barcena Roig, Mustafa Dikmen, Jef Scheepersget


Tier-1 collaborative project lt1_col_2021_1
======================

lt1_col_2021_1 is a Tier-1 collaborate project. We share resources (storage, credits) with collaborating partners. The partnering research groups are:

Prof. Dr. Wim Thiery, wim.thiery@vub.be, Prof. Dr. Nicole van Lipzig, nicole.vanlipzig@kuleuven.be, Prof. Dr. Gabrielle De Lannoy, gabrielle.delannoy@kuleuven.be, Prof. Dr. Diego G. Miralles, diego.miralles@ugent.be, Prof. Dr. Piet Termonia, piet.termonia@ugent.be

Credit Manager: Jonas Van de Walle <jonas.vandewalle@kuleuven.be> (group Nicole van Lipzig)

iRODS
======================

The VSC data component iRODS serves us

* to transfer datasets from Tier-2 staging and scratch to Tier-1 scratch, and
* to store large datasets that are not permanently used on either Tier-1 and Tier-2. Datasets that are permanently used on either Tier-2 or Tier-1 should be on staging (Tier-1) or scratch (Tier-2). See below for the information on the Tier-2 scratch and how it differs from Tier-1. 
  
Connecting to iRODS
-----------------
One way to work on iRODs are the 'i' commands that mostly have an equivalent bash command (see documentation)

To start an iRODS session:

    $ irods-setup | bash

Go to research-rsda directory:

    $ icd /kuleuven_tier1_pilot/home/research-rsda/

Show content of research-rsda directory:

    $ ils /kuleuven_tier1_pilot/home/research-rsda/
    
To transfer data to and from iRODS, see documentation.
   
Directory and File Structure {#sec:structure}
-----------------
On the iRODS research-rsda, there is currently only the OUTPUT directory with user directories.
The rsda iRODS quota is currently 110 TB.

Tier-1 connection, credits, storage
======================
  
nx connection to Tier-1
-----------------

-   Use can use the same pair of ssh keys that you use for the tier-2 connection.

-   Establish a new connection with tier-1 nx like you did for tier-2 nx
<https://vlaams-supercomputing-centrum-vscdocumentation.readthedocs-hosted.com/en/latest/access/nx_start_guide.html>
The tier-1 host is
nx-tier1.hpc.kuleuven.be

ssh connection to Tier-1 (e.g. with putty)
-----------------

    $ ssh -X <yourvscnumber>@login1-tier1.hpc.kuleuven.be
  
Credits 
-----------------

*  There is no 'group node' on Tier-1.

*  Transfer of data from iRODS can be done on the login node. 

*  Collaborative credits: -A lt1_col_2021_1

*  Maximum walltime on Tier-1 is 3 days. 

*  E.g.:
  
    $ qsub -I -X -A lt1_col_2021_1 -l walltime=24:00:00

Storage: Tier-1 SCRATCH (300 TB for all collaborators)
-----------------

  Each user: `$VSC_SCRATCH` (1 TB)         
  lt1_col_2021_1 Group: `/scratch/leuven/projects/lt1_2020_es_pilot` (300 TB for all collaborators)

## To check available storage of lt1_2020_es_pilot
    $ mmlsquota -j lt1_2020_es_pilot --block-size T nec_vol1

Note: No deletion of files after one month like on Tier-2. There is no staging on Tier-1. So scratch needs regular clean-up by the users.

## Directory structure of the group SCRATCH lt1_2020_es_pilot
    $ cd /scratch/leuven/projects/lt1_2020_es_pilot
    $ ls
    
## The relevant folders for rsda
  * External: similar to the tier-2 l_data and input on /staging/leuven/stg_00024/
  * project_input: project-specific inputs that is not of interest to other research groups like e.g. code and libraries for simulations, every project input that is potentially of interest for other groups should be in External.
  * project_output: Simulation/Processing outputs
(ignore KUL, there are two groups at KUL, in other directories groups are separated for group-specific data which is better)

Useful notes
======================

## iRODs: Recovery of deleted files
for 15 days files are in a trash directory:
/kuleuven_tier1_pilot/trash/home/vsc31786/research-rsda/
and can be recovered ... unless you deleted it with the -f option.

## Mounted directories on Tier-1
    $ /data/leuven 
    $ /user/leuven 

## Code
*  Some of the Tier-2 compiled code on /data/leuven might work on Tier-1, e.g. a miniconda python environment. 
*  Comment of Ingrid: "Unless you do CPU intensive calculations with the software of the environment it should be ok. If you do intensive CPU usage it is then best to ensure that the you are using MKL and the it should be ok. Only if you are using MPI it will be worth to reimport the environment on Tier-1."

