# FAQs

### How do I install and run TB-D?
If you intend on using TB-D on the Terra website, please see [Get Started on Terra](./get_started_Terra.md).
For all other users, please see [this webpage](.get_started_nonTerra.md) instead.


### Is support for non-Illumina data planned?
Not at the moment, because the decontamination and variant calling steps use clockwork, which strictly requires PE Illumina.


### I want to replicate your published results as closely as possible. Which version of TB-D should I use?
You will want to run ________ using its default settings.

Be aware that although everything else is deterministic (including any of the optional downsampling, as we use a set seed for that), the specific UShER command used to add samples to the tree is non-deterministic. This means that samples may be placed in different places on your tree.


### Does TB-D support multi-lane/multi-run samples?
Yes, as long as each lane/run has precisely one R1 FASTQ file and precisely one R2 FASTQ file. Multi-lane samples will be concatenated during the decontamination step.

For example, SAMN02584599 contains both SRR1166330 and SRR1169013. When pulling via TB-D_sra, you will end up with SRR1166330_1.fastq, SRR1166330_2.fastq, SRR1169013_1.fastq, and SRR1169013_2.fastq in the working directory. These get renamed to SAMN02584599_SRR1166330_1.fastq, SAMN02584599_SRR1166330_2.fastq, SAMN02584599_SRR1169013_1.fastq, and SAMN02584599_SRR1169013_2.fastq in order to keep the name of the sample in the filenames. These files are then passed to the decontamination task, and assuming they pass, your cleaned FASTQs will be called SAMN02584599_1.fastq and SAMN02584599_2.fastq and then carry on to the variant caller. The output of the variant caller will be SAMN02584599.vcf, which will appear on your tree as SAMN02584599.


### How should I name my files to make sure TB-D knows which file is R1 and which one is R2?
If all of your samples have precisely one R1 file and precisely one R2 file, we recommend SAMPLE_1.fastq and SAMPLE_2.fastq format. If any of your inputs are multi-lane samples that have not been concatenated, we recommend SAMPLE_RUN_1.fastq and SAMPLE_RUN_2.fastq.


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