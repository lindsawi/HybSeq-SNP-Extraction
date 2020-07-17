#!/bin/bash

#Command line argument: prefix for all files
prefix=$1

#Locations of things
phyloscripts=/home/joh97948/phyloscripts
genelist=/scratch/joh97948/physco/raxml_genelist


#Replace the FASTA headers as GATK does weird things to them
#Not needed for subgenomes since we're going to delete outside the largest phase block anyway
#sed -ri "s/>[0-9]+ ([A-Z0-9]+-[A-Z0-9]+):[0-9]+-[0-9]+/\>\1/" $prefix.supercontigs.iupac.fasta
#Re-index the IUPAC reference file
#samtools faidx $prefix.supercontigs.iupac.fasta

#Run WhatsHap to generate phased VCF
whatshap phase -o $prefix.phased.vcf --reference=$prefix.supercontigs.fasta $prefix.supercontigs.fasta.snps.vcf $prefix.supercontigs.fasta.marked.bam
whatshap stats $prefix..phased.vcf --gtf $prefix.whatshap.gtf --tsv 2338.whatshap.stats.txt 


#BGZIP and index the Whatshap output
bgzip -c  $prefix.phased.vcf > $prefix.phased.vcf.gz
tabix $prefix.phased.vcf.gz

#Extract two fasta sequences for each gene, corresponding to the phase
mkdir -p phased_bcftools
rm phased_bcftools/*
parallel "samtools faidx $prefix.supercontigs.fasta $prefix-{1} | bcftools consensus -H 1 $prefix.phased.vcf.gz > phased_bcftools/$prefix-{1}.phased.1.fasta" :::: /scratch/joh97948/physco/raxml_genelist.txt
parallel "samtools faidx $prefix.supercontigs.fasta $prefix-{1} | bcftools consensus -H 2 $prefix.phased.vcf.gz > phased_bcftools/$prefix-{1}.phased.2.fasta" :::: /scratch/joh97948/physco/raxml_genelist.txt

#For polyploidy analysis, need to delete sequences outside the largest phase block using Haplonerate 
mkdir -p phased_seqs
parallel "python /home/joh97948/phyloscripts/haplonerate/haplonerate.py $prefix.whatshap.gtf phased_bcftools/$prefix-{}.phased.1.fasta phased_bcftools/$prefix-{}.phased.2.fasta --edit delete --ref $prefix.supercontigs.fasta > phased_seqs/{}.fasta" :::: /scratch/joh97948/physco/raxml_genelist.txt


