# How to Install and Run TB-D
*If you are using the cloud compute platform Terra, please see [this documentation](./get_started_Terra.md) instead. If you are unsure if you want to use Terra, try TB-D without it first.*

> [!IMPORTANT]  
> You are reading documentation for an outdated version of TB-D that exists solely for reproducing published results. It is HIGHLY recommended you use [a more recent version](https://github.com/aofarrel/TB-D) with improved code and documentation.

## Basic Requirements
TB-D is provided in a WDL format. To run WDLs, you need a WDL executor and containerization software. This means for most people, the dependencies are this:
* Either miniwdl, Cromwell, or the Dockstore CLI
* Internet access (for runtime dependencies)
* Docker

You *might* be able to swap Docker for Singularity, "rootless Docker," or other Docker alternatives. It is **highly** recommended to stick with Docker if possible, but we recognize some institute computes do not allow the usage of Docker due to its security implications. We cannot promise non-Docker alternatives will work.

## Should I use miniwdl or Cromwell?
Generally speaking, we recommend miniwdl over Cromwell for a few reasons:
* miniwdl's default configuration is significantly better at handling limited system resources; Cromwell's defaults may cause crashing
* miniwdl has a clear "in progress" indicator; Cromwell doesn't
* miniwdl is significantly less verbose; Cromwell's verbosity is for things that almost never cause issues

The drawback of miniwdl is that you will need to remember to always run TB-D with the `--copy-input-files` flag, due to differences in how miniwdl and Cromwell handle file permissions.

## Getting up and running
If you are not familiar with WDL at all, you may benefit from reading [UCSC's guide on running WDLs](https://github.com/ucsc-cgp/training-resources/blob/main/WDL/running_a_wdl.md) first.

TB-D downloads several dependencies at runtime, including several Docker images.

### TB-D_sra
TB-D_sra is designed for pulling samples directly from NCBI SRA. Input a text file of BioSample (SAMN/SAME/SAMD) accessions, one per line.

### TB-D_raw
TB-D_raw is designed for non-NCBI data. Input a nested array of FASTQs, where each inner array represents one sample. Your forward reads should end in `_1.fastq` and your reverse reads should end in `_2.fastq`. 
