#!/bin/bash
#SBATCH --partition=all
#SBATCH --job-name Seqtk
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=15G
#SBATCH --time=01:00:00 
##SBATCH --error=Seqtk.%J.err ##if not defined, redirected to standard output.
#SBATCH --output=Seqtk.%J.out
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=j.chouaref@lumc.nl

#script used to create subsample RNA-seq single-end in order test the TE_transcript pipeline

OUTPUT="/exports/humgen/jihed/ChIP_subsample"
#seqtk sample <in.fa> <number>

cd /exports/humgen/jihed/Kernfeld_scRNA_thymus/nextflow/results/fastq

for file in *.fastq.gz;
    do
        name=`basename -s '.fastq.gz' $file`;
        seqtk sample $file 500 > $OUTPUT/$name'.fq'
    done
