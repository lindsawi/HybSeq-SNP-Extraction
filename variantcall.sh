#!/bin/bash
set -eo pipefail

## Usage: bash variantcall.sh Sporobolus_cryptandrus_ref.fasta GUMOseq-0188
## Where .fasta is reference sequence + ' ' + samplename 

# Set variables
reference=../$1
prefix=$2
#read1fn="$prefix.R1.paired.fastq"
#read2fn="$prefix.R2.paired.fastq"
read1fn="$prefix"_1P.fastq
read2fn="$prefix"_2P.fastq

cd $prefix
##gatk CreateSequenceDictionary -R $reference 
##bwa index $reference
##samtools faidx $reference

#Align read files to reference sequence and map
bwa mem $reference $read1fn $read2fn | samtools view -bS - | samtools sort - -o "$prefix.sorted.bam"
gatk FastqToSam -F1 $read1fn -F2 $read2fn -O $prefix.unmapped.bam -SM $prefix.sorted.bam

#Replace read groups to mapped and unmapped bam files using library prep and sequencing information
gatk AddOrReplaceReadGroups -I  $prefix.sorted.bam -O $prefix.sorted-RG.bam -RGID 2 -RGLB lib1 -RGPL illumina -RGPU unit1 -RGSM $prefix
gatk AddOrReplaceReadGroups -I  $prefix.unmapped.bam -O $prefix.unmapped-RG.bam -RGID 2 -RGLB lib1 -RGPL illumina -RGPU unit1 -RGSM $prefix

#Combine mapped and unmapped BAM files
gatk MergeBamAlignment --ALIGNED_BAM $prefix.sorted-RG.bam --UNMAPPED_BAM $prefix.unmapped-RG.bam -O $prefix.merged.bam -R $reference

#Remove duplicate sequences
gatk MarkDuplicates -I $prefix.merged.bam -O $prefix.marked.bam -M $prefix.metrics.txt
samtools index $prefix.marked.bam

#Create GVCF 
gatk HaplotypeCaller -I $prefix.marked.bam -O $prefix-g.vcf -ERC GVCF -R $reference

#Remove intermediate files
rm $prefix.sorted.bam $prefix.unmapped.bam $prefix.merged.bam $prefix.unmapped-RG.bam $prefix.sorted-RG.bam
