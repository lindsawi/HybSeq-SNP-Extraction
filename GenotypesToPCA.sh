##End of Select Varitants for GATK4
#Make samples list 
*/*-g.vcf > samples.list
reference=Ppyriforme-3728.supercontigs.fasta
prefix=Physcomitrium-pyriforme
gatk CombineGVCFs -R $reference --variant samples.list --output "$prefix".cohort.g.vcf
gatk GenotypeGVCFs -R $reference -V "$prefix".cohort.g.vcf -O "$prefix".cohort.unfiltered.vcf
time gatk SelectVariants -V "$prefix".cohort.unfiltered.vcf -R $reference -select-type-to-include SNP -O "$prefix".SNPall.vcf
time gatk VariantFiltration -R $reference -V "$prefix".SNPall.vcf --filter-name "hardfilter" -O "$prefix".snp.filtered.vcf --filter-expression "QD < 5.0 || FS > 60.0 || MQ < 40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0"
gatk SelectVariants -V "$prefix".snp.filtered.vcf -O "$prefix".snp.filtered.nocall.vcf --set-filtered-gt-to-nocall


## plink commands

## Need to edit VCF to not have a dot 
bcftools annotate --set-id +"%CHROM:%POS" > "$prefix".snp.filtered.nocall.vcf > "$prefix".snp.filtered.nodot.vcf
plink --vcf-filter --vcf "$prefix".snp.filtered.nodot.vcf --allow-extra-chr --recode  --make-bed --geno --const-fid --out Ppyriforme
plink --indep 50 5 2 --file "$prefix" --allow-extra-chr --out "$prefix"
plink --extract "$prefix".prune.in --out "$prefix"_pruned --file "$prefix" --make-bed --allow-extra-chr --recode
plink --pca 20 --file "$prefix"_pruned --allow-extra-chr --out "$prefix"

