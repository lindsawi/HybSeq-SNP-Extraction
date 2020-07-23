#!/bin/bash
##End of Select Varitants for GATK4

set -eo pipefail
reference=$1 #Ppyriforme-3728.supercontigs.fasta
prefix=$2 #Physcomitrium-pyriforme
#Make Samples list
ls */*-g.vcf > samples.list
# Combine and Jointly call GVCFs
gatk CombineGVCFs -R $reference --variant samples.list --output "$prefix".cohort.g.vcf
gatk GenotypeGVCFs -R $reference -V "$prefix".cohort.g.vcf -O "$prefix".cohort.unfiltered.vcf
# Keep only SNPs passing a hard filter
time gatk SelectVariants -V "$prefix".cohort.unfiltered.vcf -R $reference -select-type-to-include SNP -O "$prefix".SNPall.vcf
time gatk VariantFiltration -R $reference -V "$prefix".SNPall.vcf --filter-name "hardfilter" -O "$prefix".snp.filtered.vcf --filter-expression "QD < 5.0 || FS > 60.0 || MQ < 40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0"
gatk SelectVariants -V "$prefix".snp.filtered.vcf -O "$prefix".snp.filtered.nocall.vcf --set-filtered-gt-to-nocall

