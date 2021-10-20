rule call_narrow_peaks:
    input:
        treatment       =   RESULT_DIR + "mapped/{treatment}.sorted.bam",
        control         =   RESULT_DIR + "mapped/{control}.sorted.bam",
    output:
        RESULT_DIR + "macs2/{treatment}_vs_{control}_peaks.narrowPeak"
    message:
        "Calling narrowPeak for {wildcards.sample}"
    params:
        name        = "{treatment}_vs_{control}",        #this option will give the output name, has to be similar to the output
        genomesize  = str(config['macs2']['genomesize']),
        qvalue      = str(config['macs2']['qvalue'])
    log:
        RESULT_DIR + "logs/macs2/{treatment}_vs_{control}_peaks.narrowPeak.log"
    shell:
        "macs2 callpeak -t {input.treatment} -c {input.control} {params.genomesize} --name {params.name} -q {params.qvalue} --nomodel --outdir results/bed/ &>{log}"
