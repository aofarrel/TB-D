version 1.0

import "https://raw.githubusercontent.com/aofarrel/myco/main/myco_raw.wdl" as myco_WF
import "https://raw.githubusercontent.com/aofarrel/tree_nine/0.1.0/tree_nine.wdl" as TreeNine_WF

workflow TBD_raw {
	input {
		Array[Array[File]] paired_fastq_sets
		String date_pipeline_ran
		String? date_pipeline_previously_ran
		
		Boolean just_like_2024                 = false # older decontam ref, tbprofiler on bams instead of FQs
		Int     clean_average_q_score          = 29
		String? output_sample_name
		Boolean covstatsQC_skip_entirely       = true
		File?   mask_bedfile
		Boolean decontam_use_CDC_varpipe_ref   = false
		
		# QC stuff 
		Int     QC_max_pct_low_coverage_sites  =    20
		Int     QC_max_pct_unmapped            =     2
		Int     QC_min_mean_coverage           =    10
		Int     QC_min_q30                     =    90
		Boolean QC_soft_pct_mapped             = false
		Int     QC_this_is_low_coverage        =    10
		Int     quick_tasks_disk_size          =    10 
		Boolean guardrail_mode                 = true
		
		# shrink large samples
		Int     subsample_cutoff        =  -1 # note inconsistency with TBD_sra!!

		# phylogenetics
		Boolean tree_decoration         = false
		File?   tree_to_decorate
		Boolean cluster_entire_tree     = false
		Boolean identify_clusters       = false
	}

	parameter_meta {
		biosample_accessions: "File of BioSample accessions to pull, one accession per line"

		clean_average_q_score: "Trim reads with an average quality score below this value. Independent of QC_min_q30. Overridden by clean_before_decontam and clean_after_decontam BOTH being false."
		covstatsQC_skip_entirely: "Should we skip covstats entirely?"
		mask_bedfile: "Bed file of regions to mask when making diff files (default: R00000039_repregions.bed)"
		quick_tasks_disk_size: "Disk size in GB to use for quick file-processing tasks; increasing this might slightly speed up file localization"

		QC_max_pct_low_coverage_sites: "Samples who have more than this percent (as int, 50 = 50%) of positions with coverage below QC_this_is_low_coverage will be discarded"
		QC_min_mean_coverage: "If covstats thinks MEAN coverage is below this, throw out this sample - not to be confused with TBProfiler MEDIAN coverage"
		QC_max_pct_unmapped: "If covstats thinks more than this percent of your sample (after decontam and cleaning) fails to map to H37Rv, throw out this sample."
		QC_min_q30: "Decontaminated samples with less than this percent (as int, 50 = 50%) of reads above qual score of 30 will be discarded."
		QC_soft_pct_mapped: "If true, a sample failing a percent mapped check (guardrail mode's TBProfiler check and/or covstats' check as per QC_max_pct_unmapped) will throw a non-fatal warning."
		QC_this_is_low_coverage: "Positions with coverage below this value will be masked in diff files"
		
		subsample_cutoff: "If a fastq file is larger than than size in MB, subsample it with seqtk (set to -1 to disable)"
		
		tree_decoration: "Should usher, taxonium, and NextStrain trees be generated?"
		tree_to_decorate: "Base tree to use if tree_decoration = true, if not provided, defaults to an example TB tree created using an older version of Tree Nine (and therefore shouldn't be used in published results; it's there for an easy test example)"		
	}

	call myco_WF.myco as this_myco_WF {
		input:
			paired_fastq_sets = paired_fastq_sets,
			clean_average_q_score = clean_average_q_score, 
			covstatsQC_skip_entirely = covstatsQC_skip_entirely,
			date_pipeline_ran = date_pipeline_ran,
			date_pipeline_previously_ran = date_pipeline_previously_ran,
			decontam_use_CDC_varpipe_ref = decontam_use_CDC_varpipe_ref,
			guardrail_mode = guardrail_mode,
			just_like_2024 = just_like_2024,
			mask_bedfile = mask_bedfile,
			quick_tasks_disk_size = quick_tasks_disk_size,
			QC_max_pct_low_coverage_sites = QC_max_pct_low_coverage_sites,
			QC_max_pct_unmapped = QC_max_pct_unmapped,
			QC_min_mean_coverage = QC_min_mean_coverage,
			QC_min_q30 = QC_min_q30,
			QC_soft_pct_mapped = QC_soft_pct_mapped,
			QC_this_is_low_coverage = QC_this_is_low_coverage,
			subsample_cutoff = subsample_cutoff,
	}

	if(tree_decoration) {
		if(length(this_myco_WF.tbd_diffs)>0) {
			Array[File] coerced_diffs = select_all(this_myco_WF.tbd_diffs)
			call TreeNine_WF.Tree_Nine as this_TreeNine_WF {
				input:
					diffs = coerced_diffs,
					input_tree = tree_to_decorate,
					identify_clusters = identify_clusters,
					cluster_entire_tree = cluster_entire_tree
			}
		}
	}
	
	output {		
		# raw files
		Array[File]  bais  = this_myco_WF.tbd_bais
		Array[File]  bams  = this_myco_WF.tbd_bams
		Array[File] diffs  = this_myco_WF.tbd_diffs
		Array[File] masks  = this_myco_WF.tbd_masks   # bedgraph
		Array[File]  vcfs  = this_myco_WF.tbd_vcfs
		
		# metadata
		Array[File?] decontam_reports          = this_myco_WF.tbd_decontam_reports
		Array[File?] covstats_reports          = this_myco_WF.tbd_covstats_reports
		Array[File?] diff_reports              = this_myco_WF.tbd_diff_reports
		Array[File?] tbprof_bam_jsons          = this_myco_WF.tbd_tbprof_bam_jsons
		Array[File?] tbprof_bam_summaries      = this_myco_WF.tbd_tbprof_bam_summaries
		Array[File?] tbprof_fq_jsons           = this_myco_WF.tbd_tbprof_fq_jsons
		Array[File?] tbprof_fq_looker          = this_myco_WF.tbd_tbprof_fq_looker
		Array[File?] tbprof_fq_laboratorian    = this_myco_WF.tbd_tbprof_fq_laboratorian
		Array[File?] tbprof_fq_lims            = this_myco_WF.tbd_tbprof_fq_lims
		
		# tree nine
		File?        tree_nwk           = this_TreeNine_WF.BIG_tree_nwk
		File?        tree_usher         = this_TreeNine_WF.BIG_tree_usher
		File?        tree_taxonium      = this_TreeNine_WF.BIG_tree_taxonium
		File?        tree_nextstrain    = select_first([this_TreeNine_WF.BIG_tree_json_noanno, this_TreeNine_WF.BIG_tree_json_clusteranno])
		Array[File]? cluster_subtrees_nwk   = this_TreeNine_WF.CLUSTER_trees_nwk
		File? distance_matrix           = this_TreeNine_WF.BIG_dmatrix
	}
	
}
