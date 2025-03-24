# TB-D

TB-D is a system developed for genetic analysis and/or surveillance of *Mycobacterium tuberculosis*. Due to the system being built in a modular fashion, its codebase exists across several repos. This repo serves as the "parent" for the overall system.

## What makes up TB-D?
At its core, TB-D consists of two WDL subworkflows:
1. myco -- cleans & decontaminates FASTQ files, runs TBProfiler, calls variants, generates MAPLE-formatted diff files
	a) myco_sra: Takes in a file of BioSample accessions to download from SRA
	b) myco_raw: Takes in raw (ie, not cleaned) FASTQ files directly
2. Tree Nine -- takes in MAPLE-formatted diff files and places them on a phylogenetic tree using UShER

Although not part of either WDL workflow, we also use Ranchero to wrangle metadata for decorating your phylogenetic trees using [Ranchero](https://github.com/aofarrel/Ranchero). Ranchero can be run 100% separately from TB-D and is completely optional.

## Installing/Running TB-D
TB-D is designed to be as painless as possible to install.
* If you are using the cloud-compute platform Terra to store your samples, please see [HERE](./getting_started_Terra.md).
* All other users, see [HERE](./getting_started_nonTerra.md).

## Limitations
* TB-D can **only** analyze paired-end (PE) Illumina data, and will attempt to automatically filter out any SE Illumina samples, as well as any non-Illumina samples.
* Docker is a soft requirement. Some people have reported successfully getting TB-D working with Singularity, but it's not officially supported.

## Contributing
We welcome contributions, PRs, and issue reports. Whenever possible, please make try to make issue reports in the repo most relevant to your issue -- for example, if you are having issues with the Tree Nine subworkflow, please leave the issue in the Tree Nine repo instead of in this repo.


## Citations

#### clockwork / minos
In this reproducible branch of TB-D, we use v0.11.3 of clockwork.

> Hunt, Martin, Brice Letcher, Kerri M. Malone, Giang Nguyen, Michael B. Hall, Rachel M. Colquhoun, Leandro Lima, et al. “Minos: Variant Adjudication and Joint Genotyping of Cohorts of Bacterial Genomes.” Genome Biology 23, no. 1 (December 2022): 147. https://doi.org/10.1186/s13059-022-02714-x.

#### Cortex
> Iqbal, Zamin, Mario Caccamo, Isaac Turner, Paul Flicek, and Gil McVean. “De Novo Assembly and Genotyping of Variants Using Colored de Bruijn Graphs.” Nature Genetics 44, no. 2 (February 2012): 226–32. https://doi.org/10.1038/ng.1028.

#### fastp
> Chen, Shifu. “Ultrafast One‐pass FASTQ Data Preprocessing, Quality Control, and Deduplication Using Fastp.” iMeta 2, no. 2 (May 2023): e107. https://doi.org/10.1002/imt2.107.

#### goleft
> https://github.com/brentp/goleft

#### minimap2
> Li, Heng. “Minimap2: Pairwise Alignment for Nucleotide Sequences.” Edited by Inanc Birol. Bioinformatics 34, no. 18 (September 15, 2018): 3094–3100. https://doi.org/10.1093/bioinformatics/bty191.

#### samtools
> Danecek, Petr, James K Bonfield, Jennifer Liddle, John Marshall, Valeriu Ohan, Martin O Pollard, Andrew Whitwham, et al. “Twelve Years of SAMtools and BCFtools.” GigaScience 10, no. 2 (January 29, 2021): giab008. https://doi.org/10.1093/gigascience/giab008.

#### seqtk
> https://github.com/lh3/seqtk

#### TBProfiler
In this reproducible branch of TB-D, we use two versions of TBProfiler:
* "base" TBProfiler: version 4.4.2, database 2023-Mar-27
* Theiagen's fork: v1.2.1, which itself is built upon TBProfiler version 4.4.2, database 2023-Jan-19

> Phelan, Jody E., Denise M. O’Sullivan, Diana Machado, Jorge Ramos, Yaa E. A. Oppong, Susana Campino, Justin O’Grady, et al. “Integrating Informatics Tools and Portable Sequencing Technology for Rapid Detection of Resistance to Anti-Tuberculous Drugs.” Genome Medicine 11, no. 1 (December 2019): 41. https://doi.org/10.1186/s13073-019-0650-x.

> Libuit, Kevin G., Emma L. Doughty, James R. Otieno, Frank Ambrosio, Curtis J. Kapsak, Emily A. Smith, Sage M. Wright, et al. 2023. “Accelerating Bioinformatics Implementation in Public Health.” Microbial Genomics 9 (7). https://doi.org/10.1099/mgen.0.001051.

#### Trimmomatic
> Bolger, Anthony M., Marc Lohse, and Bjoern Usadel. “Trimmomatic: A Flexible Trimmer for Illumina Sequence Data.” Bioinformatics 30, no. 15 (August 1, 2014): 2114–20. https://doi.org/10.1093/bioinformatics/btu170.
