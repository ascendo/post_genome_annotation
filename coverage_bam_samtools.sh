#!/bin/bash
#$ -cwd
#$ -pe SharedMem 1
#$ -m bes
#$ -M wyim@unr.edu
#$ -N ltr_finder
set -o pipacbiofail

cd pacbio
mkdir pacbio_bam
for i in `ls bwa.*`

do
        samtools view -Sb ${i} >>  pacbio_bam/$i.bam
done

cd pacbio_bam

samtools mergei -@ 16 pacbio.merged.bam *.bam

samtools sort  -@ 16 pacbio.merged.bam pacbio.merged.sort

samtools mpileup pacbio.merged.sort.bam >> pacbio.coverage

done
