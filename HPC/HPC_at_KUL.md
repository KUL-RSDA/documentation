
  | version    | date        | authors|
  |----------- |------------ |-----------------------------------------------------------------------------|
  | version 1  | 15 June 2017|   Gabriëlle De Lannoy: initial documentation |
  | version 2  | 04 July 2017|   Michel Bechtold: PBS job chains, Jan Quets: Py figure mounting |
  | version 3  | 08 May 2018 |   Anne Felsberg: added pointers to cdo, Gabriëlle De Lannoy: use of shared node |
  | version 4  | 07 Feb 2019 |   Michel Bechtold: using Genius |
  | version 5  | 11 Jul 2019 |   Gabriëlle De Lannoy: updates to reflect the default login to the new Genius system and new VSC |
  | version 6  | 05 Sep 2019 |   Alexander Gruber: updated debugging module from Allinea to Arm |
  | version 7  | 22 Sep 2020 |   Michel Bechtold: added specific information/summary for MSc students webpages |
  | version 8  | 25 Jan 2024 |   Gabriëlle De Lannoy: fixed Github entries and PBS to SLURM |


Get Started on the HPC
======================

KU Leuven Tier-2 cluster:

-   [infrastructure](https://vlaams-supercomputing-centrum-vscdocumentation.readthedocs-hosted.com/en/latest/leuven/tier2_hardware.html)

-   get a VSC-account and manage it (set up keys):
    <https://account.vscentrum.be/>

-   file access for staff + students or other externals group:
    `lees_swm_ls_ext`

-   file access for staff group: `lees_swm_ls`

-   long/multi-core simulations - introductory credits (staff+students):
    `default_project`

-   long/multi-core simulations - project credits (staff only):
    `lp_ees_swm_ls_001`

Directory and File Structure
============================

  Individual             |Group
  ---------------------- |-------------------------
  `/user` (3 GB)         |`/staging` (several TB)
  `/data` (75 GB)        |`/archive` (several TB)
  `/scratch` (100 GB?)   |

(w/ backup): Snapshot backups are stored under /data/leuven/.snapshot/*

/user (w/ backup)
-----------------

3 GB, `$VSC_HOME`

### Your Own Files

`/user` is an individual minimal storage option, e.g.
`/user/leuven/30X/vsc30XXX`:

-   Keep important small scripts or data here.

-   Do NOT store simulation output or large data here.

### System Files

Authorization to work on the cluster is done via a key pair. The private
key resides on the computer from which you want to access the HPC: make
sure to keep this safe. The HPC can be accessed from multiple computers,
which will be listed in a list of authorized keys. The public key is
stored on the HPC:

    $ .ssh/authorized_keys
    $ .ssh/id_rsa.pub

Other friendly machines are stored under `.ssh/known_hosts`.

By default on the Tier-2 cluster, terminals use bash. We could use csh
(or tcsh) by just typing `csh` (or `tcsh`) in the terminal. Set your
environment using the following files

    $ .aliases (e.g. setting your xterm and quick line commands)
    $ .bashrc
    $ .bash_profile

These files can be copied from `/data/leuven/314/vsc31402/documentation/configure_shell/`. 


/data (w/ backup)
-----------------

75 GB, `$VSC_DATA`

### Individual

`/data` is an individual storage option, e.g.
`/data/leuven/30X/vsc30XXX`.

-   Keep important larger script collections, your own source code here.

-   Store research output here.

### Group

`/data` is an individual storage option, but individuals can choose to
share customized material. For example, modeling systems and processing
code, e.g. `/data/leuven/314/vsc31402/src_code`,
`/data/leuven/314/vsc31402/process_code`.

The files on `/data` can be updated at any time, so

/scratch (no backup)
--------------------

100 GB, `$VSC_SCRATCH`

### Individual

This is an individual storage option, e.g.
`/scratch/leuven/30X/vsc30XXX`.

-   Model simulation output gets written here, but is supposedly deleted
    after 21 days.

-   Easily accessible short-term storage, suitable for processing and
    I/O.

### Group

`/scratch` is an individual storage option only, but individuals can
choose to share data.

/staging (no backup)
--------------------

Readily accessible long-term core data storage, suitable for intensive
processing and I/O.

### Group

9 TB, charged to project\
`/staging/leuven/stg_00024`:

`├──`\ **`input`**\
`│`\ `├──`\ `met_forcing`\
`│`\ `├──`\ `obs_scaling`\
`│`\ `└──`\ `RTM_params`\
`├──`\ **`GEOSldas_libraries`**\
`├──`\ **`LDASsa_libraries_20190607`**\
`├──`\ **`l_data`**\
`│`\ `├──`\ `model_param`\
`│`\ `├──`\ `obs_insitu`\
`│`\ `└──`\ `obs_satellite`\
`├──`\ **`tools`**\
`│`\ `├──`\ `AquaCrop2F`\
`└──`\ **`OUTPUT`**\
`├──`\ `core`\ `simulations`\ `used`\ `by`\ `the`\ `group`

The file collections on `/staging` are large and will only be updated
after group consensus, so If you have any data that belong on
`/staging`, let me know.

### Individual

Group storage; or individual needs to have a project.

/archive (mirrored)
-------------------

Long-term storage, suitable for processing and I/O, not accessible from
compute node.

### Group

9 TB, charged to project\
`/staging/leuven/arc_00024` holds a copy of some (not all) of the data
on `/staging`.

### Individual

Group storage; or individual needs to have a project.

Login, Transfer and Compute {#sec:loginandcompute}
===========================

How to Access (Data on) the HPC
-------------------------------

To get a terminal from your local desktop:

-   Windows: puTTY, NoMachine and OnDemand (more convenient), Xming $\rightarrow$
    XLaunch

-   Mac/Linux: 'Terminal' `ssh`

To tranfer data to your local desktop:

-   Windows: WinSCP

-   Mac/Linux: use 'Terminal' `rsync, scp`, etc.

Login and Compute Nodes
-----------------------

Log into the system and do basic work (each node type has a slightly
different configuration):

-   login(2).hpc.kuleuven.be (Thinking basic),
    login1-tier2.hpc.kuleuven.be (Genius basic)

-   nx1, 2 (GUI)

-   inode1, 2, 3, 4 (interactive nodes)

For more intense computations, launch a job onto a compute node
(Ivybridge, Haswell, SkyLake).

TBD: there are also visualization nodes

ThinKing, Genius, wICE,...
----------------

Over the years, we will be working on constantly varying hardware, i.e. nodes are getting bigger and faster. Currently, we use Genius which has standard nodes of 192 GB and bigmem nodes of 768 GB.

-   login to a Genius node (careful, don't run big jobs here):

        $ ssh vsc3xxxx@login1-tier2.hpc.kuleuven.be
        or
        $ ssh vsc3xxxx@login2-tier2.hpc.kuleuven.be

-   get interactive time (SLURM command) on Genius or wICE, e.g. for 12 hours on a single core:

        $ srun --x11 -A lp_ees_swm_ls_001 -M genius  --nodes=1 --ntasks-per-node=1 -t 12:00:00 --pty bash -l
    	$ srun --account=lp_ees_swm_ls_001 --ntasks=1 --time=12:00:00 --partition=interactive --clusters=wice --pty bash -l\

-   submit jobs as usual with a SLURM header and indicate your node specifications in that header, if you like. Examples are given below. The top three lines left speficy that you need the 768 GB on Genius, whereas the top two lines right do not specify any node (but you can specify your wishes in SLURM too).  When you are authorized to use the group node r23i13n23 it is necessary to exclude it when submitting jobs. Jobs use the same accounts for the credits on various nodes.

| PBS (old) | SLURM |
|---- | ----- |
| #PBS -l nodes=1:ppn=36:skylake | #SBATCH --ntasks=1 --cpus-per-task=36|
| #PBS -l pmem=10gb		| #SBATCH --clusters=all|
| #PBS -l partition=bigmem	|  |
| #PBS -W x=excludenodes=r23i13n23 | #SBATCH --exclude=nodename|

    
-   Python and Matlab scripts work similarly on various nodes. On wICE, Matlab needs

        $ module load cluster/genius/centos7
    	$ module load matlab/R2020a

-   Info May 2021: For stability of interactive Matlab usage, launch matlab on NX with

        $ matlab -softwareopengl -desktop 


Submitting and Managing Jobs
----------------------------

Credit system

    NEW (SLURM):
    $ sam-balance	
    $ sam-statement --account=lp_my_project 
    $ sam-list-usagerecords --account=lp_my_project --start=2023-01-01 --end=2023-01-31

    OLD (PBS):	
    $ module load accounting 
    $ mam-balance 	
    $ gquote -q q24h -l nodes=1:ppn=20:ivybridge
    $ gquote -l nodes=1:ppn=20:ivybridge -l walltime=01:00:00
    $ mam-statement (-a lp_ees_swm_ls_001 --summarize)  

Submitting and managing jobs

    NEW (SLURM):
    $ sbatch [script_file]
    $ squeue
    $ squeue --job [job_id]
    $ squeue -u [user_name]
    $ scancel [job_id]
    $ squeue -o "%.9i %.9P %.8j %.8u %.2t %.10M %.6D %S"		
    $ sinfo -N
    
    OLD (PBS):	
    $ qsub -q q1h script_w_PBS_commands.sh
    $ qsub -I -l walltime=2:00:00 -l nodes=1:ppn=20
    $ qstat (-q)
    $ showq
    $ checkjob [jobid]
    $ qdel [jobid]
    $ showstart [jobid]

Shared group node (for PhD and Postdocs) 
-----------------

To be able to run longer jobs without having to queue, we were assigned
a dedicated node r23i13n23 on Genius. This node is ideal for longer processing jobs,
development and testing of computationally more intensive procedures. To
get onto our own node, and depending on whether or not you have
introductory credits left, you could issue a command like

    $ srun --x11 -A lp_ees_swm_ls_001 -M genius -p dedicated_eesswm_batch --ntasks-per-node=x -t 12:00:00 --pty bash -l

with x<36. If you do not add the walltime, you will get 1 hour; you need to add '-A';
without specifying the ntasks, you might be egoistic and allow yourself to
take all cores.

To check how many cores are occupied (does not work anymore?):
showres -n -g | grep r23i13n23
--> 36 minus the sum of the cores after 'running' gives you the currently available cores 

OnDemand HPC access 
-----------------

HPC also offers a web-based client application to access HPC http://ondemand.hpc.kuleuven.be/

-   Open a shell prompt on the login node (no use of credits): "Login Server Shell Access"

-   Open an interactive shell on a compute node: "Interactive Shell". 
If you want to use the RSDA dedicated group node for this interactive session, specify Cluster: 'genius', Account: 'lp_ees_swm_ls_001', and Partition: 'dedicated_eesswm_batch' (should this not be dedicated_eesswm_interactive?). Make sure you limit the number of cores to what you need and not more than 6 to allow others in the research group to access/use the group node. 

  
Credits 
----------------------------
On HPC-wide shared nodes, we only pay for the cores we use.
Let's assume we have a job that is not well parallelized, i.e. runs inefficiently on many cores.
It always requires ~ 10 hours regardless of being run on 2 or 36 cores. Then 
`srun --x11 -A lp_ees_swm_ls_001 -M genius  --nodes=1 --ntasks-per-node=2 -t 12:00:00 --pty bash -l`
is 1/18 of the costs of
`srun --x11 -A lp_ees_swm_ls_001 -M genius  --nodes=1 --ntasks-per-node=36 -t 12:00:00 --pty bash -l`


Though noted that in the following cases:
1) you request pmem above the default (5gb)
2) you request more than half the cores on the node
you get exclusive access to the node in which case you also pay for the full node.

Note also: The amount you pay also depends on how long the job actually ran for, i.e. the walltime is not the actual time you pay. The walltime is just a max time that you define and which is the basis for the waiting queue (1h 24h 72h 168h) that your job is allocated to. The jobs that are expected to run longer typically have also longer waiting times in the queue. For more information, see:
https://vlaams-supercomputing-centrum-vscdocumentation.readthedocs-hosted.com/en/latest/leuven/credits.html

The shared group node (node of the RSDA group) is constantly reserved for us and paid with an annual fee. So whenever possible use the capacity of this shared group node.

Specific information for MSc studens:
-----------------
1) [BASIC] if you foresee running anything longer than ~20 minutes or with more memory, you will have to go onto an interactive node to do your HPC work, i.e. you will not be able to run a big job on the login node.
Ask the interactive node (-I) from your command line:\
$ srun --account=lp_myproject --ntasks=1 --time=01:00:00 --partition=interactive --clusters=wice --pty bash -l\
or\
$ srun --x11 -A default_project --nodes=1 --ntasks-per-node=2 -t 12:00:00 --pty bash -l\
$ --> start Matlab, Python, whatever
3) [ADVANCED] if you think you need to launch a job (could be a Matlab/Python script, or a model run,...) for a longer and on more cpus, and you don't need to interact with the Matlab/Python interface, then you can launch the job into a queue and it will start running when there is space available.
Ask a bash-script with PBS commands (my_script.sh) from your supervisor, and launch it from your command line:\
$ sbatch my_script.sh\
$ --> do something else\
(to see available queues: $ squeue)
4) [NEEDED] you need compute credits for 1-2 above, and all Msc students get free introduction credits.
Ask them via https://admin.kuleuven.be/icts/onderzoek/hpc/request-introduction-credits
mention that you do Msc thesis research in our research group, briefly say why you need compute time.

Debugging {#sec:debugging}
=========

Various debugging tools can be used on the HPC, such as gdb, valgrind,
xenial, etc. For our typical applications, ArmForge seems the most
straightforward (in earlier versions, allinea was used). This is how it works:

-   compile your code with a debugging flag on.\
    **LDASsa**

        $ csh
        $ source g5_modules
        $ gmake install BOPT=g

    **LIS**

        $ source KUL_LDT_modules
        $ ./configure  (all default, except set debug=-1)
        $ vim ./make/configure.lis --> add "LDFLAGS += -lmkl" at the end
        $ ./compile

    or alternatively, avoid the 'configure' step and manually update the
    configure.lis-file by replacing the -O0 flag with the -g flag, and
    add the -g flag to CFLAGS (=-c -g -DIFC -DLINUX); then compile.

-   run your executable in the debugger software. Moving to csh, as
    needed for LDASsa:

        $ csh
        $ source g5_modules
        $ module load ArmForge/18.1.2
        $ [option 1] ddt &
        $ [option 1] > Run and manually fill in entries, possibly launch in queue or not
        $ [option 2] ddt mpirun -np 6 [....]/Linux/bin/LDASsa_mpi.x -work_path ../output -run_path .  -exp_id GLOB_EASEv2_M09_N_2n20p\\
         -exp_domain SMAP_EASEv2_M09_GLOB -start_year 1985 -start_month  1 -start_day  1 -start_hour  0 -start_min  0 -start_sec  0\\
         -end_year   1985 -end_month   10 -end_day    1 -end_hour    0 -end_min    0 -end_sec    0 -N_ens 1 -spin .false.  -force_dtstep 3600\\
         -first_ens_id 0 -resolution SMAP_EASEv2_M09 -restart .false.  -met_tag M2COR_cross\\
         -met_path ../input/met_forcing/MERRA2_land_forcing -driver_inputs_path .  -driver_inputs_file drv_EASEv2_M09_GLOB.nml &

    or staying in bash, for LIS:

        $ source KUL_LDT_modules
        $ module load ArmForge/18.1.2
        $ [option 1] ddt &
        $ [option 1]  > Run and manually fill in entries, possibly launch in queue or not
        $ [option 2] ddt mpirun -np 4 [...]/LIS_public_release_7.2r_KUL_debugging/LIS\\
        /data/leuven/314/vsc31402/src_code/LIS/testrun/GLDAS/lis.config &

    -   on the shared group node, or on an interactive node, you could
        just go ahead and run without running this in the queue.\
        HOWEVER, due to memory issues it does not always just work like
        that from an interactive node. In that case, launch the run
        after c specifying a machinefile (see notes on how to compile
        and run LIS on the HPC).

    -   from a login/shared group node, check the entries under option 1
        to launch code (from ddt) in the queue.

-   **option 1**, using the GUI to fill in arguments (recommended when
    you need a queue, or if you have no clue what you are doing in
    general):\

    1.  always: edit the path to your executable, the arguments, other
        details
        (Figure [\[fig\_intro\]](#fig_intro){reference-type="ref"
        reference="fig_intro"}).

    2.  mostly: specify MPI (not OpenMP), either Intel MPI for LIS, or
        open MPI for LDASsa, see
        Figure [\[fig\_mpi\]](#fig_mpi){reference-type="ref"
        reference="fig_mpi"}.

    3.  optional: when also submitting to the (debugging) queue, see
        Figure [\[fig\_queue\]](#fig_queue){reference-type="ref"
        reference="fig_queue"}:

        -   Configure: 'Submission template file': choose pbs.qtf (we
            run PBS for queueing)

        -   Configure: 'Submit command': 'qsub' by default, but needs
            editing as follows.

                $ qsub -l qos=debugging -l nodes=1:ppn=4 -l walltime=00:15:00 -A project_account

            (We only need to specify a project\_account if introductory
            credits are expired.)

        -   Parameters: change default 'Queue: debug' to 'Queue: q1h'.

    4.  set breakpoints and start debugging, see
        Figure [\[fig\_breakpoint\]](#fig_breakpoint){reference-type="ref"
        reference="fig_breakpoint"}

-   **option 2**, works if you know exactly how to set up the command
    (not recommended when launched in a debugging queue)

![(Left) start up of ArmForge; (right) fill in the executable and its
arguments + pay attention to the MPI specifications and queue details,
if the latter are applicable. [\[fig\_intro\]]{#fig_intro
label="fig_intro"}](C:/Users/u0102378/BoxSync/COMPU_HPC_Etc/2018_oursystem_groupmeeting_slides/DDT-example_LDASsa1 "fig:"){width="0.30\\linewidth"}
![(Left) start up of ArmForge; (right) fill in the executable and its
arguments + pay attention to the MPI specifications and queue details,
if the latter are applicable. [\[fig\_intro\]]{#fig_intro
label="fig_intro"}](C:/Users/u0102378/BoxSync/COMPU_HPC_Etc/2018_oursystem_groupmeeting_slides/DDT-example_LDASsa2 "fig:"){width="0.69\\linewidth"}

![(Left) Open MPI details for LDASsa; (right) Intel MPI details for LIS.
[\[fig\_mpi\]]{#fig_mpi
label="fig_mpi"}](C:/Users/u0102378/BoxSync/COMPU_HPC_Etc/2018_oursystem_groupmeeting_slides/DDT-example_LDASsa3 "fig:"){width="0.496\\linewidth"}
![(Left) Open MPI details for LDASsa; (right) Intel MPI details for LIS.
[\[fig\_mpi\]]{#fig_mpi
label="fig_mpi"}](C:/Users/u0102378/BoxSync/COMPU_HPC_Etc/2018_oursystem_groupmeeting_slides/DDT-example_LIS1 "fig:"){width="0.496\\linewidth"}

![Setting the details about the queue, IF you want to launch the job in
the queue. [\[fig\_queue\]]{#fig_queue
label="fig_queue"}](C:/Users/u0102378/BoxSync/COMPU_HPC_Etc/2018_oursystem_groupmeeting_slides/DDT-example_LDASsa4){width="0.9\\linewidth"}

![Start debugging, set breakpoints, follow error messages, follow
multiple threads, etc. [\[fig\_breakpoint\]]{#fig_breakpoint
label="fig_breakpoint"}](C:/Users/u0102378/BoxSync/COMPU_HPC_Etc/2018_oursystem_groupmeeting_slides/DDT-example_LIS3){width="0.9\\linewidth"}

Figures {#sec:figures}
=======

Figures can be viewed from the command-line using either:

-   simple visualization using Eye of Gnome, scrolling through available
    figures in directory one by one, sometimes crops the figure, limited
    opportunities to format:

        $ eog my_file.jpg

-   same, but to see multiple individual figures at the same time:

        $ for i in my_file*.jpg; do eog -n "$i" & done

-   decent visualization and formatting of \*.eps or \*png files:

        $ evince my_file.eps

-   imagemagick, allowing more formatting to the figures (but careful,
    this may occasionally destroy your NX-session):

        $ module load ImageMagick/6.9.1-8-foss-2014a
        $ display my_file.jpg

TBD: There are probably more opportunities on the visualization nodes.

Mounting Multiple Figures using Latex, PPT
------------------------------------------

-   Latex: simply add multiple lines of `includegraphics`, or use the
    `subfigure` command

-   PPT: create a slide of a large dimension (postersize) and compose a
    new figure based on individual figures, save as \*.jpg

Mounting Multiple Figures using Python
--------------------------------------

### Installing Python Packages

Python is installed on VSC already. However, mounting figures when using
the script below requires the installation of two Python modules which
are not centrally available at VSC. Given the huge amount of existing
Python packages, the policy of VSC is that users should install packages
in their own VSC user or data directories. Only highly-used modules are
installed
[centrally](https://vlaams-supercomputing-centrum-vscdocumentation.readthedocs-hosted.com/en/latest/software/python_package_management.html?highlight=Python).

Installing Python packages, modules and their dependencies (in this case
libraries for image formats, i.e., JPEG and PNG, as well as font
management such as freetype) is simple using conda. Conda further
enables you to create and switch between Python environments, and gives
you the flexibility to use any Python version or package version you
like.

Installing conda is easy. First download the installation script on the
cluster:

    $ wget repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh

Next, execute the installation script:

    $ bash Miniconda2-latest-Linux-x86_64.sh -b -p $VSC_DATA/miniconda2

(Note that we install in the data directory, since all conda
environments you create will reside in the miniconda2 directory, so this
may grow pretty large over time, potentially exceeding the quota on
`$VSC_USER`.)

For convenience, add the following line to your `.bashrc` script:

    export PATH="$VSC_DATA/miniconda2/bin:$PATH"

To ensure that the modification to the PATH variable is done, source
your `.bashrc`, i.e.,

    $ source ~/.bashrc

Now you are ready to create your first environment, and install the
modules needed for the script below (these are PIL and numpy). Create an
environment called py-env (you can of course pick any name you like):

    $ conda create -n py-env python=2.7 pil numpy

To use the environment, activate it using:

    $ source activate py-env

All supporting libraries will be installed automatically, without any
fuss with loading the correct modules on the system. For more detailed
information on conda, and how to use it, consult section 3 (from slide
35 onwards) of the presentation written by Geert Jan Bex, available on:

[github.com/gjbex/training-material/blob/master/Python/python\_intro.pptx](github.com/gjbex/training-material/blob/master/Python/python_intro.pptx)

### Example Script

    import numpy as np
    import math
    import PIL
    from PIL import Image
    from PIL import ImageFont
    from PIL import ImageDraw

    #set max file size (unit: MB) preference:
    maxFS=5

    #crop the to-be-mounted figures (or tile figures) when needed
    #unit: percentage of width (or height) of the original tile figures
    #Note this script assumes all tile figures have the
    #same number of pixels in each (i.e. x & y ) dimension

    cr_topleft_x=0      #left side
    cr_botright_x=0         #right side
    cr_botright_x_legend=0  #right side (in case of figure with legend on right side)
    cr_topleft_y=20         #upper side
    cr_topleft_y_legend=0   #upper side (in case of figure with legend on upper side)
    cr_botright_y=0         #bottom side

    #path to figures to be mounted
    fig_path='/data/leuven/XXX/vscXXXXX/figures/'

    #destiny path/name to assembled figure
    fig_destiny=’/data/leuven/XXX/vscXXX/figures/AssembledFigure.jpg’

    #ARRANGE FIGURES IN ROWS AND COLUMNS:
    #Figures referenced inside each lists below will be arranged
    #horizontally in the assembled figure
    #Figures in different lists will be arranged vertically
    #So, in the example below, 4 (rows) x 3 (columns) = 12 figures will be
    # mounted in the assembled destiny figure
    list1_im = [fig_path+figname1.jpg' , fig_path+figname2.jpg' , fig_path+'figname3.jpg'  ]
    list2_im = [fig_path+figname4.jpg' , fig_path+figname5.jpg' , fig_path+'figname6.jpg'  ]
    list3_im = [fig_path+figname7.jpg' , fig_path+figname8.jpg' , fig_path+'figname9.jpg' ]
    list4_im = [fig_path+figname10.jpg' , fig_path+figname11.jpg' , fig_path+'figname12.jpg' ]

    xpix=PIL.Image.open(list1_im[0]).size[0]
    ypix=PIL.Image.open(list1_im[0]).size[1]

    cropcoord_topleft_x=int(xpix*float(cr_topleft_x)/100)
    cropcoord_botright_x=int(xpix-xpix*float(cr_botright_x)/100)
    cropcoord_botright_legend=int(xpix-xpix*float(cr_botright_x_legend)/100)
    cropcoord_topleft_y=int(ypix*float(cr_topleft_y)/100)
    cropcoord_botright_y=int(ypix-ypix*float(cr_botright_y)/100)
    cropcoord_topleft_y_legend=int(ypix-ypix*float(cr_topleft_y_legend)/100)

    imgs1    = [ PIL.Image.open(i) for i in list1_im ]
    imgs1    = [ i.crop((cropcoord_topleft_x,cropcoord_topleft_y,\
                      cropcoord_botright_x,cropcoord_botright_y)) for i in imgs1 ]
    imgs1_hcomb = np.hstack( (np.asarray(i) for i in imgs1 ) )
    imgs1_hcomb = PIL.Image.fromarray( imgs1_hcomb)

    imgs2    = [ PIL.Image.open(i) for i in list2_im ]
    imgs2    = [ i.crop((cropcoord_topleft_x,cropcoord_topleft_y,\
                     cropcoord_botright_x,cropcoord_botright_y)) for i in imgs2 ]
    imgs2_hcomb = np.hstack( (np.asarray(i) for i in imgs2 ) )
    imgs2_hcomb = PIL.Image.fromarray( imgs2_hcomb)

    imgs3    = [ PIL.Image.open(i) for i in list3_im ]
    imgs3    = [ i.crop((cropcoord_topleft_x,cropcoord_topleft_y,\
                     cropcoord_botright_x,cropcoord_botright_y)) for i in imgs3 ]
    imgs3_hcomb = np.hstack( (np.asarray(i) for i in imgs3 ) )
    imgs3_hcomb = PIL.Image.fromarray( imgs3_hcomb)

    imgs4    = [ PIL.Image.open(i) for i in list4_im ]
    imgs4    = [ i.crop((cropcoord_topleft_x,cropcoord_topleft_y,\
                    cropcoord_botright_x,cropcoord_botright_y)) for i in imgs4 ]
    imgs4_hcomb = np.hstack( (np.asarray(i) for i in imgs4 ) )
    imgs4_hcomb = PIL.Image.fromarray( imgs4_hcomb)

    # vertical stacking of rows of figures
    imgs    = [imgs1_hcomb,imgs2_hcomb,imgs3_hcomb,imgs4_hcomb]
    imgs_asmbld = np.vstack( (np.asarray(i) for i in imgs ) )
    imgs_asmbld = PIL.Image.fromarray( imgs_asmbld)

    #EXTEND THE CANVAS of the assembled figure, when wished
    #(e.g. to create whitespace to add text)
    #units are percentages of width (or height) of the assembled figure
    cv_exp_left=0
    cv_exp_right=0
    cv_exp_bot=0
    cv_exp_up=10

    ExpImage=Image.new('RGB',( int(round(imgs_asmbld.size[0]* \
      (1+float(cv_exp_left+cv_exp_right)/100))) , int(round(imgs_asmbld.size[1]*\
      (1+float(cv_exp_bot+cv_exp_up)/100)))),"white")
    ExpImage.paste(imgs_asmbld,   ( int(round((imgs_asmbld.size[0]*float(cv_exp_left)/100))) ,\
      int(round(imgs_asmbld.size[1]*float(cv_exp_up)/100)),\
      int(round(imgs_asmbld.size[0]*(1+float(cv_exp_left)/100))) ,\
      int(round(imgs_asmbld.size[1]*(1+float(cv_exp_up)/100)))))

    imgs_asmbld=ExpImage
    del ExpImage

    #RESIZE IMAGE when file size is estimated to be larger than maxFS
    #(defined on line 9 of this script)
    pixpmb=27500000 # empirically-derived number of pixels for which
                    # most jpg-figures will have file sizes smaller than 1 MB

    xpix=imgs_asmbld.size[0]
    ypix=imgs_asmbld.size[1]

    if xpix*ypix> maxFS*pixpmb:
    shrinkf=math.sqrt((xpix*ypix)/(maxFS*pixpmb)) #shrinkfactor for original images
    else:
        shrinkf=1

    imgs_asmbld=imgs_asmbld.resize((int(imgs_asmbld.size[0]/shrinkf),\
                          int(imgs_asmbld.size[1]/shrinkf)))
    xmax=imgs_asmbld.size[0]
    ymax=imgs_asmbld.size[1]

    #ADD TEXT, when wished

    draw=ImageDraw.Draw(imgs_asmbld)

    #add main title
    #set font size (relative to assembled image height) for title
    fontsizeT=0.1
    #set font type for title
    fontT=ImageFont.truetype("/user/leuven/XXX/vscXXX/path-to-font-files/GARA.TTF",\
                            int(ymax*fontsizeT))
    title=’Title of assembled figure’
    #horizontally centralize title in assembled figure
    w,h=draw.textsize(titleT,font_title)
    draw.text(((imgs_asmbld.size[0]-w)/2,0),title,(0,0,0),font=fontT)

    #add other column and row titles
    #set font size \& type
    fontsize=0.025
    font=ImageFont.truetype("/user/leuven/XXX/vscXXX/path-to-font-files/GARA.TTF",\
                         int(ymax*fontsize))

    x_ofs_col=0.02  #x offset for column titles (unit= % of assembled fig width)
    y_ofs_col=0.10  #y offset for column titles (unit= % of assembled fig height)
    x_div_col=3     #number of column titles
    x_ofs_row=0.02  #x offset for row titles (unit= % of assembled fig width)
    y_ofs_row=0.10  #y offset for row titles (unit= % of assembled fig height)
    y_div_row=4 #number of row titles

    draw.text((int(xmax*(x_ofs_col+float(0)/x_div_col)),int(ymax*y_ofs_col)),\
      ’title_for_column1',(0,0,0),font=font)
    draw.text((int(xmax*(x_ofs_col+float(1)/x_div_col)),int(ymax*y_ofs_col)),\
      ’title_for_column2',(0,0,0),font=font)
    draw.text((int(xmax*(x_ofs_col+float(2)/x_div_col)),int(ymax*y_ofs_col)),\
      ’title_for_column3',(0,0,0),font=font)
    draw.text((int(xmax*(x_ofs_row)),int(ymax*y_ofs_row+float(0)/y_div_row)),\
      ’title_for_row1',(0,0,0),font=font)
    draw.text((int(xmax*(x_ofs_row)),int(ymax*y_ofs_row+float(1)/y_div_row)),\
      ’title_for_row2',(0,0,0),font=font)
    draw.text((int(xmax*(x_ofs_row)),int(ymax*y_ofs_row+float(2)/y_div_row)),\
      ’title_for_row3',(0,0,0),font=font)
    draw.text((int(xmax*(x_ofs_row)),int(ymax*y_ofs_row+float(3)/y_div_row)),\
      ’title_for_row4',(0,0,0),font=font)

    #save final image
    imgs_asmbld.save( fig_destiny )

### Run Script

Directly from a terminal:

    $ python script.py

As a call from Matlab:

    system('source activate py-env');
    system('python/user/leuven/XXX/vscXXX/path-to-python-script/script.py');
    system('source deactivate py-env');

The text above was provided by Jan Quets; other questions about Python,
ask Alexander Gruber.

Tips and Tricks {#sec:tipsandtricks}
===============

The VSC provides on-line and course information on how to get started
and how to work on the HPC. Here are some useful additional tips and
tricks:

-   to avoid that lines are overwritten when working in a shell with a
    variable size:

        echo "set horizontal-scroll-mode off" >> ~/.inputrc

-   When working on a Linux desktop, system folders can be mounted and
    unmounted as follows:

        $ sshfs vsc3xxxx@login.hpc.kuleuven.be:/data/leuven/3xx/vsc3xxxx/ /mnt/vsc_data
        $ fusermount -u /mnt/vsc_data

-   We could split a long job into several sequential shorter ones that
    each can be submitted to a shorter queue. To achieve this, create a
    script (see below) which launches a series of scripts
    (`script_w_PBS_commands.x.sh`, or lenkf.x.j in this example) which
    each contain PBS-commands:

        #!/bin/bash
        JOB001=$(qsub lenkf.1.j)
        echo $JOB001
        JOB002=$(qsub -W depend=afterany:$JOB001 lenkf.2.j)
        echo $JOB002
        JOB003=$(qsub -W depend=afterany:$JOB002 lenkf.3.j)
        echo $JOB003
        ...

-   print a subselection of columns to a new file:

        $ cat tmp | awk '{print $1, $3}' > tmp_out

-   squeeze multiple page onto one page\

        $ psnup -n -pa4 input_file.ps output_file.ps

    where 'n' is the number of pages that will go into one.

-   work with climate data operators (cdo):

        $ module avail CDO
        $ module load CDO/1.6.6-intel-2014a
        $ cdo infon  infile.nc
        $ cdo selvar,EVPSOIL MERRA2_300.tavg1_2d_lnd_Nx.20020316.nc4 EVPSOIL_20020316.nc4

    More information: [reference card with
    commands](https://code.mpimet.mpg.de/projects/cdo/embedded/cdo_refcard.pdf),
    [user's
    guide](https://code.mpimet.mpg.de/projects/cdo/embedded/cdo.pdf), or
    contact `anne.felsberg@kuleuven.be`.

-   **check quota**: for staging:

        $ mmlsquota -j stg_00024 --block-size auto vol_ddn2

-   **since August 2019, only use** login-genius.hpc.kuleuven.be
    login-thinking.hpc.kuleuven.be

    Once on Genius, login1-2 are normal login nodes, login3-4 are nx.
    You may have to go back to login1 to get things to work.

-   **group nodes**:\
    [On the new Thinking (r12i02n16 instead of r12i2n16! )]{.underline}:

        $ qsub -I -X -lnodes=r12i02n16 -lpartition=EES -A lp_ees_swm_ls_001 -l walltime=00:02:00
        or
        $ qsub -I -X -lnodes=1:ppn=X -lpartition=EES -A lp_ees_swm_ls_001 -l walltime=00:02:00

    (Shannon, to be precise, please use lp\_ees\_swm\_ls\_002; although
    it should not matter)

    [On Genius (r23i13n23)]{.underline}:

        $ qsub -I -X -lnodes=r23i13n23:ppn=1 -W group_list=lees_swm_ls_ext -A lp_ees_swm_ls_001
                                                                    -l walltime=00:02:00

    FYI, it should also work with something like the command below, but
    I have not managed to make that work yet (it would let us move
    seamlessly to another node within our group reservation, if
    r23i13n23 would ever break).

        $ qsub … -l advres=dedicated_nodes_16204.14548 -W group_list= lees_swm_ls_ext …

-  **Jupyter notebooks**. If you use a Linux machine, it is possible to access Jupyter running on the HPC on your personal 	computer via an SSH tunnel. This allows you to code in Python without using a virtual desktop through NoMachine. 
	1. On a compute node, load your Python environment and install Jupyter if needed.
		
			$ # HPC
			$ conda activate <ENVIRONMENT>
			$ conda install -c conda-forge jupyterlab

	2. Start an interactive Jupyter python session (example here for group node):

			$ # HPC
			$ cd /data/leuven/3xx/vsc3xxxx/
			$ jupyter-lab --ip r23i13n23 --port 3xxxx	
		
		Redirect to `$VSC_DATA` first as done here if that is where your notebooks are stored (you will not be able to access them if you launch Jupyter from `$VSC_HOME`).
		
		Good practice is to use your VSC-number rather than the default port, to prevent multiple people using the same port at the same time.

	3. On your personal computer, create the SSH tunnel:
			
			$ # LOCALLY
			$ ssh -L 3xxxx:r23i13n23:3xxxx -N vsc3xxxx@login.hpc.kuleuven.be

		Leave this terminal window open.

	4. Open a web browser on your local computer and launch `http://127.0.0.1:3xxxx/lab/tree/`. You should see a Jupyter environment that uses Python on the HPC.

	Note: very similar on Tier-1. Just change `r23i13n23` to the name of the compute node being used and create the SSH tunnel via `vsc3xxxx@login1-tier1.hpc.kuleuven.be`.

Trouble shooting {#sec:troubleshooting}
===============

Problem of accessing the group node with -X
------------------------------------------
1. There should be an ".Xauthority" file in your $VSC_HOME. Using the "mv" command, rename this file to e.g. ".Xauthority_bkp".
2. Close your connection and reconnect to the cluster (with X-forwarding enabled). This should create a fresh ".Xauthority" file in your $VSC_HOME.
3. Now you may try again to submit an interactive job to that node with the '-X' flag
4. To test if your X system is enabled you can type; xeyes

Problem of accessing NX client with NoMachine
------------------------------------------
1. Your $VSC_HOME is full. Get on the login node via ssh (e.g. with putty), clean up your home (often there are e.g. huge dump files or you by mistake installed a big software on $VSC_HOME instead of on $VSC_DATA). It's also possible that your $VSC_HOME is not full but contains too many files and (sub)directories (>100k). 
# To count directories
find . -type d -print | wc -l 
# To count files
find . -type f -print | wc -l
# To see where you have the many files and clean up
find . -type f -print
2. Try again to establish a NX connection with NoMachine.



