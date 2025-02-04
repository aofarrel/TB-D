# How to Install and Run TB-D
*If you are using the cloud compute platform Terra, please see [this documentation](./get_started_Terra.md) instead. If you are unsure if you want to use Terra, try TB-D without it first.*

## Basic Requirements
TB-D is provided in a WDL format. To run WDLs, you need a WDL executor and containerization software. This means for most people, the dependencies are this:
* Either miniwdl or Cromwell
* Docker

You *might* be able to swap Docker for Singularity, Podman, "rootless Docker," or other Docker alternatives. It is **highly** recommended to stick with Docker if possible, but we recognize some institute computes do not allow the usage of Docker due to its security implications. We cannot promise non-Docker alternatives will work.

## Should I use miniwdl or Cromwell?
Generally speaking, we recommend miniwdl over Cromwell for a few reasons:
* miniwdl's default configuration is significantly better at handling limited system resources; Cromwell's defaults may cause crashing
* miniwdl has a clear "in progress" indicator; Cromwell doesn't
* miniwdl is significantly less verbose; Cromwell's verbosity is for things that almost never cause issues

The drawback of miniwdl is that you will need to remember to always run TB-D with the `--copy-input-files` flag, due to differences in how miniwdl and Cromwell handle file permissions.

### TB-D_sra

### TB-D_raw

