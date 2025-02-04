# TB-D

> [!IMPORTANT]  
> This is an outdated version of TB-D that exists solely for reproducing published results. It is HIGHLY recommended you use a more recent version, because that has improved code and documentation.

TB-D is a system developed for genetic analysis and/or surveillance of *Mycobacterium tuberculosis*. Due to the system being built in a modular fashion, its codebase exists across several repos. This repo serves as the "parent" for the overall system.

## What makes up TB-D?
At its core, TB-D consists of two WDL subworkflows:
1. myco -- cleans & decontaminates FASTQ files, runs TBProfiler, calls variants, generates MAPLE-formatted diff files
	a) myco_sra: Takes in a file of BioSample accessions to download from SRA
	b) myco_raw: Takes in raw (ie, not cleaned) FASTQ files directly
2. Tree Nine -- takes in MAPLE-formatted diff files and places them on a phylogenetic tree using UShER

Although not part of either WDL workflow, we also use Ranchero to wrangle metadata for decorating your phylogenetic trees using Ranchero. Ranchero can be run 100% seperately from TB-D and is completely optional.

## Installing/Running TB-D
TB-D is designed to be as painless as possible to install.
* If you are using the cloud-compute platform Terra to store your samples, please see [HERE](./getting_started_Terra.md).
* All other users, see [HERE](./getting_started_nonTerra.md).

## Limitations
* TB-D can **only** analyze paired-end (PE) Illumina data, and will attempt to automatically filter out any SE Illumina samples, as well as any non-Illumina samples.
* Docker is a soft requirement. Some people have reported successfully getting TB-D working with Singularity, but it's not officially supported.

## Contributing
We welcome contributions, PRs, and issue reports. Whenever possible, please make try to make issue reports in the repo most relevent to your issue -- for example, if you are having issues with the Tree Nine subworkflow, please leave the issue in the Tree Nine repo instead of in this repo.


# Full list of citations

## clockwork and clockwork-wdl
clockwork is developed by

In addition, myco uses the following components:
* SRANWRP, a standard library
* clockwork-wdl, which is a partial WDLization of clockwork
* Ash's WDLization of tb_profiler, which is a WDLization of TB-Profiler that uses TB-Profiler's own database
* Thieagen Genomics' WDLization of tb_profiler, which is a WDLization of TB-Profiler that uses a custom database
