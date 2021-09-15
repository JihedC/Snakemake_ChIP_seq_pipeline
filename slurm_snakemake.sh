#! /bin/bash

#SBATCH  --job-name=CHIP_SE_snakemake
#SBATCH --mail-type=ALL
#SBATCH --mail-user j.chouaref@lumc.nl
#SBATCH -t 24:00:00
#SBATCH --mem=15000

module purge
module load genomics/ngs/samtools/1.11/gcc-8.3.1
module load genomics/ngs/aligners/bowtie2/2.4.2/gcc-8.3.1
echo Start time : `date`
snakemake -p \
        --snakefile Snakefile \
        --latency-wait 60 \
        --wait-for-files \
        --rerun-incomplete \
        --use-conda \
        --cluster "sbatch --parsable --partition=all --mem=36g --ntasks=1 --cpus-per-task=8 --time=24:00:00 --hint=multithread" \
 	--cluster-status "./slurm-cluster-status.py" \
	--jobs 30


echo End time : `date`


