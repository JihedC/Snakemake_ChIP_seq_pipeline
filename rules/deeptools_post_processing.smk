rule bamcoverage:
    input:
        bam     =   RESULT_DIR + "mapped/{sample}.sorted.bam",
        bai     =   RESULT_DIR + "mapped/{sample}.sorted.bam.bai"
    output:
        bigwig  =   RESULT_DIR + "bigwig/{sample}_rpkm.bw"
    message:
        "Create genome coverage tracks"
    benchmark:
        RESULT_DIR + "benchmark/bamcoverage_{sample}.benchmark.txt"
    params:
         binsize                =   config["bamcoverage"]["binsize"],
         normalizeUsing         =   config["bamcoverage"]["normalizeUsing"],
         effectiveGenomeSize    =   config["bamcoverage"]["effectiveGenomeSize"],
         smoothLength           =   config["bamcoverage"]["smoothLength"]       
    log:
        RESULT_DIR + "log/bamcoverage/{sample}.log"    
    shell:
        "bamCoverage -b {input.bam} --binSize {params.binsize} --effectiveGenomeSize {params.effectiveGenomeSize} --normalizeUsing {params.normalizeUsing} --smoothLength {params.smoothLength} -o {output.bigwig} 2>{log}"
