# How to Install and Run TB-D
*If you are using the cloud compute platform Terra, please see [this documentation](./get_started_Terra.md) instead. If you are unsure if you want to use Terra, try TB-D without it first. If you're looking for information about ranchero, please see its repo instead.*

## Basic Requirements
TB-D is provided in a WDL format. To run WDLs, you need a WDL executor and containerization software. This means for most people, the dependencies are this:
* Docker
* Either [miniwdl](https://miniwdl.readthedocs.io/en/latest/getting_started.html#install-miniwdl) or [Cromwell](https://cromwell.readthedocs.io/en/latest/tutorials/FiveMinuteIntro/)

WDL allows each task in a workflow to have different hardware requirements. TB-D is preconfigured with sensible defaults to handle heavy workloads without racking up unnecessary cloud costs. Nevertheless, it's worth keeping in mind that hardware requirements for the heaviest tasks are almost entirely a function of how many samples you are putting into the pipeline, and how big those samples are. Here's some general guidelines:

#### myco
The heaviest task is the variant caller.
* Recommended: 16 CPUs, 32 GB real memory, (FQ size)+100 GB storage, SSD
* Should work if your FQs are downsampled to 400 megabytes or less, and not heavily contaminated: 12 CPUs, 12 GB real memory, (FQ size)+15 GB storage, SSD
* myco is largely **not** affected by the number of samples you are running, because every sample gets its own VM (ie it's not sharing these resources).
  * Caveat: Although each sample isn't sharing a task, if they are sharing a *workflow*, your WDL executor may attempt to run these tasks in parallel. In some cases this may cause your WDL executor to fail to allocate enough resources for some instances of the task and crash -- but you can resolve this by changing your WDL runner's configuration to only run one task at a time.

#### Tree Nine
The heaviest task is usher_sampled_diff, followed by matOptimize.
* Recommended: 40 CPUs, 32 GB real memory, (tree size)+(combined diff size)+50 GB storage, SSD
* Small number of samples: 8 CPUs, 16 GB real memory, (tree size)+(combined diff size)+10 GB storage, SSD
* Tree Nine **is** affected by the number of samples you are running, because every sample has to share the same VM in order to get all the samples on the same phylogenetic tree

### What if my institute's HPC doesn't allow me to run Docker?
If your compute supports Docker alternatives, you *might* be still be able to use TB-D. One person has reported being able to run myco with Singularity, but we cannot promise you will be able to -- it really depends on exactly how your institute HPC is set up. Please contact your sysadmin for more information.

If you are processing only a small number of samples, it may be feasible to run TB-D on a local machine using Docker.

### Should I use miniwdl or Cromwell?
Generally speaking, we recommend miniwdl over Cromwell for a few reasons:
* miniwdl's default configuration is significantly better at handling limited system resources; Cromwell's defaults may cause crashing
* miniwdl has a clear "in progress" indicator; Cromwell doesn't
* miniwdl is significantly less verbose; Cromwell's verbosity is for things that almost never cause issues

The drawback of miniwdl is that you will need to remember to always run TB-D with the `--copy-input-files` flag, due to differences in how miniwdl and Cromwell handle file permissions.

### Other edge cases
Please see https://github.com/aofarrel/TB-D/wiki/Unusual-and-unsupported-backends

