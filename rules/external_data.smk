################## Rules used to download genome and GTF annotations ##################


rule download_genome:
	params: 
		fasta   =   config["GENOME_ZIP_FASTA_URL"]
	output:
		WORKING_DIR + "reference.fa"
	log:
		"results/log/download_genomefile.log"
	benchmark:
		RESULT_DIR + "benchmark/download_genome.txt"			    
	shell:
		"curl {params.fasta} | gunzip -c > {output} 2>{log}"


rule download_gtf_gene:
	output:
		WORKING_DIR + "annotation.gtf"
	params:
		gtfFile=config["GENOME_ZIP_GTF_URL"]
	log:
		"results/log/download_gene_annotation.log"
	benchmark:
		RESULT_DIR + "benchmark/download_gtf_gene.txt"	
	shell:
		"curl {params.gtfFile} | gunzip -c > {output} 2>{log}"

rule download_TE_gene:
	output:
		WORKING_DIR + "TE_repeat_masker.gtf"
	params:
		gtfFile=config["REPEAT_GTF_URL"]
	log:
		"results/log/download_TE_repeat_masker.log"
	benchmark:
		RESULT_DIR + "benchmark/download_TE_gene.txt"		
	shell:
		"curl {params.gtfFile} | gunzip -c > {output} 2>{log}"


rule prebuilt_TE_GTF:
	output:
		WORKING_DIR + "TE_prebuilt_index.locInd"
	params:
		gtfFile=config["REPEAT_LOCIND"]
	log:
		"results/log/download_TE_prebuilt_index.log"
	benchmark:
		RESULT_DIR + "benchmark/download_TE_prebuilt_index.txt"		
	shell:
		"curl {params.gtfFile} | gunzip -c > {output} 2>{log}"
