#!/bin/bash
set -eo pipefail
#Script for generating statistics from the VCF output of 
prefix=$1

#Set an ID for each SNP so they can be filtered by name
bcftools annotate --set-id +"%CHROM:%POS" "$prefix".snp.filtered.nocall.vcf > "$prefix".snp.filtered.nodot.vcf
# Filter out SNPs that didn't pass the filter
#plink --vcf-filter --vcf "$prefix".snp.filtered.nodot.vcf --allow-extra-chr --recode  --make-bed --geno --const-fid --out "$prefix"
#Alternate for deleting all SNPs with missing data: 
plink --vcf-filter --vcf "$prefix".snp.filtered.nodot.vcf --allow-extra-chr --recode  --make-bed --geno 0 --const-fid --out "$prefix"
plink --indep 50 5 2 --file "$prefix" --allow-extra-chr --out "$prefix"
plink --extract "$prefix".prune.in --out "$prefix"_pruned --file "$prefix" --make-bed --allow-extra-chr --recode
# Generate eigenvalues and loadings for 20 PCA axes
plink --pca 20 --file "$prefix"_pruned --allow-extra-chr --out "$prefix"
# Generate basic stats (heterozygosity, inbreeding coefficient, allele frequencies)
plink --freq --het 'small-sample' --ibc --file "$prefix"_pruned --allow-extra-chr -out "$prefix"_pruned
