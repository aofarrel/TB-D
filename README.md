# TB-D
TB-D is a system developed for genetic analysis and/or surveillance of *Mycobacterium tuberculosis*. Due to the system being built in a modular fashion, its codebase exists across several repos. This repo serves as the "parent" for the overall system.

## What makes up TB-D?
At its core, TB-D consists of two WDL subworkflows:
1. myco -- cleans & decontaminates FASTQ files, runs TBProfiler, calls variants, generates MAPLE-formatted diff files
2. Tree Nine -- takes in MAPLE-formatted diff files and places them on a phylogenetic tree using UShER

There are two recommendend ways of running TB-D

### TB-D(a): One workflow, many samples


### TB-D(b): One workflow per sample


## Metadata standardization
While not a WDL workflow, 





# Full list of citations

## clockwork and clockwork-wdl
clockwork is developed by

In addition, myco uses the following components:
* SRANWRP, a standard library
* clockwork-wdl, which is a partial WDLization of clockwork
* Ash's WDLization of tb_profiler, which is a WDLization of TB-Profiler that uses TB-Profiler's own database
* Thieagen Genomics' WDLization of tb_profiler, which is a WDLization of TB-Profiler that uses a custom database
