# FAQs

### How do I install and run TB-D?
If you intend on using TB-D on the Terra website, please see [Get Started on Terra](./get_started_Terra.md).
For all other users, please see [this webpage](.get_started_nonTerra.md) instead.


### Is support for non-Illumina data planned?
Not at the moment, because the decontamination and variant calling steps use clockwork, which strictly requires PE Illumina.


### I want to replicate your published results as closely as possible. Which version of TB-D should I use?
Several new features, user-friendly options, and critical bugfixes have been added to the pipeline since it was used to generate data, so older versions of the pipeline aren't supported. However, you the overall logic of the pipeline has remained almost identical. You can set `just_like_2024` to True to change the few "important" differences back to how they were before:
* Older version (0.11.3) of the decontamination reference
* Older version (0.11.3) of Clockwork
* TBProfiler is run on BAM files instead of FQs

This also applies to running myco_raw or myco_sra. Tree Nine has only had critical bugfixes and new features between pipeline versions, so just use the latest. Be aware that although everything else is deterministic (including any of the optional downsampling, as we use a set seed for that), the specific UShER command used to add samples to the tree is non-deterministic. This means that samples may be placed in different places on your tree.


### Does TB-D support multi-lane/multi-run samples?
Yes, as long as each lane/run has precisely one R1 FASTQ file and precisely one R2 FASTQ file. Multi-lane samples will be concatenated during the decontamination step.

For example, SAMN02584599 contains both SRR1166330 and SRR1169013. When pulling via TB-D_sra, you will end up with SRR1166330_1.fastq, SRR1166330_2.fastq, SRR1169013_1.fastq, and SRR1169013_2.fastq in the working directory. These get renamed to SAMN02584599_SRR1166330_1.fastq, SAMN02584599_SRR1166330_2.fastq, SAMN02584599_SRR1169013_1.fastq, and SAMN02584599_SRR1169013_2.fastq in order to keep the name of the sample in the filenames. These files are then passed to the decontamination task, and assuming they pass, your cleaned FASTQs will be called SAMN02584599_1.fastq and SAMN02584599_2.fastq and then carry on to the variant caller. The output of the variant caller will be SAMN02584599.vcf, which will appear on your tree as SAMN02584599.


### How should I name my files to make sure TB-D knows which file is R1 and which one is R2?
If all of your samples have precisely one R1 file and precisely one R2 file, we recommend SAMPLE_1.fastq and SAMPLE_2.fastq format. If any of your inputs are multi-lane samples that have not been concatenated, we recommend SAMPLE_RUN_1.fastq and SAMPLE_RUN_2.fastq. These are not strict requirements -- other iterations (`_R1/_R2`, `.fq`, etc) may work, but do a small-scale test first (or just rename your samples).


### My tasks are getting cancelled due to lack of resources (sigkill, return code 137, out-of-memory, etc)
If you're seeing this on Cromwell, this is probably a task concurrency issue that can be fixed with a config change (see below). If you're seeing this on miniwdl, your system resources may not be high enough to run the pipeline as intended. Usually the "limiting reagent" seems to be RAM -- we recommend a minimum of 32 GB, although 16 GB will generally work, especially if you enable downsampling.

If you're pretty sure your hardware should be able to handle this, these documents may help you:
* [Cromwell/Dockstore CLI only] [Troubleshooting the most common resource issues](https://docs.dockstore.org/en/stable/advanced-topics/dockstore-cli/dockstore-cli-faq.html#cromwell-docker-lockup) -- this document is in the context of the Dockstore CLI, which runs Cromwell under the hood, but it also applies to Cromwell itself
* [Resource constraints on Docker Engine](https://docs.docker.com/engine/containers/resource_constraints/)
* [Resource constraints on Docker Desktop](https://docs.docker.com/desktop/settings-and-maintenance/settings/#advanced)


### What kind of samples with TB-D filter out?
TB-D will filter out samples that fail its QC standards. Additionally, when downloading from NCBI SRA, TB-D_sra will filter out:
* [Index/Barcode sequences](https://www.biostars.org/p/390726/#390738) that are sequenced seperately from R1/R2
	* If a sample downloads as three FASTQ files, then that index/barcode file will be thrown out and the remaining R1/R2 pair will be kept
	* If a sample downloads as one, five, seven, nine, etc FASTQ files, the whole sample will be thrown out
* Non-Illumina samples (PacBio, etc)
* SE Illumina samples
* Corrupt files, such as when the FASTQ quality score isn't the same length as the nucleotide string

Please be aware that TB-D cannot automatically detect:
* *in silico* synthetic data such as SAMN18146425
* samples within "sample pools" such as SAMEA968074
* samples that contain data from multiple biological samples that were incorrectly submitted as single-sample

...but you might be able to spot such oddities on a phylogenetic tree.


### When a sample is filtered out, does the entire pipeline/workflow/Terra run crash?
On default settings, TB-D will attempt to throw out bad samples silently, without causing the workflow to exit with an error. This is great for people who want to run as many samples as possible at once, because one bad sample will not cause everything else to halt. It's also useful for those who use Terra data tables, as intermediate outputs and a status code can be saved to the Terra data table, making it possible to keep some intermediate outputs and see at a glance which samples are problematic.

You can set `variantcalling_crash_on_error` to true (default: false) to make the pipeline crash if any error is encountered in the variant caller. "Any error" includes the variant caller running out of memory, timing out, getting an unknown error, or (most relevant to data QC) failing to actually call enough variants due to the sample being too small/corrupt/contaminated, so this isn't recommended.



