################## Rules used for QC ##################
rule fastp:
    input:
        get_fastq
    output:
        fq1  = WORKING_DIR + "trimmed/" + "{sample}_R1_trimmed.fq.gz",
        fq2  = WORKING_DIR + "trimmed/" + "{sample}_R2_trimmed.fq.gz",
        html = WORKING_DIR + "fastp/{sample}_fastp.html",
        json = WORKING_DIR + "fastp/{sample}_fastp.json"
    message:"trimming {wildcards.sample} reads"
    threads: 10
    log:
        RESULT_DIR + "fastp/{sample}.log.txt"
    params:
        sampleName = "{sample}",
        in_and_out_files =  get_trim_names,
        qualified_quality_phred = config["fastp"]["qualified_quality_phred"]
    resources: cpus=10
    shell:
        "touch {output.fq2};\
        fastp --thread {threads}  --html {output.html} --json {output.json} \
        --qualified_quality_phred {params.qualified_quality_phred} \
        {params.in_and_out_files} \
        2>{log}"

rule fastqc:
    input:
        expand(WORKING_DIR + "trimmed/" + "{sample}_{read}_trimmed.fq.gz", sample=SAMPLES, read={"R1", "R2"})
    output:
        html = RESULT_DIR + "fastqc/{sample}.fastqc.html",
        zip  = RESULT_DIR + "fastqc/{sample}.fastqc.zip"
    log:
        RESULT_DIR + "logs/fastqc/{sample}.fastqc.log"
    params:
        ""
    message:
        "Quality check of trimmed {wildcards.sample} sample with FASTQC"
    wrapper:
        "0.27.1/bio/fastqc"

rule index:
    input:
        WORKING_DIR + "reference.fa"
    output:
        [WORKING_DIR + "genome." + str(i) + ".bt2" for i in range(1,5)],
        WORKING_DIR + "genome.rev.1.bt2",
        WORKING_DIR + "genome.rev.2.bt2"
    message:"Indexing Reference genome"
    params:
        WORKING_DIR + "genome"
    threads: 10
    shell:
        "bowtie2-build --threads {threads} {input} {params}"

rule align:
    input:
        forward_read    =   WORKING_DIR + "trimmed/" + "{sample}_R1_trimmed.fq.gz",
        reverse_read    =   WORKING_DIR + "trimmed/" + "{sample}_R2_trimmed.fq.gz",
        index           =   [WORKING_DIR + "genome." + str(i) + ".bt2" for i in range(1,5)]
    output:
        bams            =   WORKING_DIR + "mapped/{sample}.bam"
    message: "Mapping files {wildcards.sample} to Reference genome"
    params:
        index           = WORKING_DIR + "genome",
        sampleName      = "{sample}"
    threads: 10
    log:
        RESULT_DIR + "logs/bowtie/{sample}.log"
    run:
        if sample_is_single_end(params.sampleName):
            shell("bowtie2 --very-sensitive --threads {threads} -x {params.index} \
            -U {input.forward_read} | samtools view -Sb - > {output.bams} 2>{log}")
        else:
            shell("bowtie2 --very-sensitive --threads {threads} -x {params.index} \
            -1 {input.forward_read} -2 {input.reverse_read} | samtools view -Sb - > {output.bams} 2>{log}")    
  
 
rule sort:
    input:
        WORKING_DIR + "mapped/{sample}.bam"
    output:
        bam         =   RESULT_DIR + "mapped/{sample}.sorted.bam"
    message:"Sorting {wildcards.sample} bam file"
    threads: 10
    log:
        RESULT_DIR + "logs/samtools/{sample}.sort.log"
    shell:
        """
        samtools sort -@ {threads} -o {output.bam} {input} &>{log}
        samtools index {output.bam}
        """

rule index_bam:
    input:
        RESULT_DIR + "mapped/{sample}.sorted.bam"
    output: 
        RESULT_DIR + "mapped/{sample}.sorted.bam.bai"
    log:
        RESULT_DIR + "log/sort/{sample}.log"
    shell:
        "samtools index {input} 2>{log}"
