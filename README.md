# HybSeq-SNP-Extraction

# Software
HybPiper (produces supercontigs): https://github.com/mossmatters/HybPiper <br/>
GATK4: https://github.com/broadinstitute/gatk/releases <br/>
Plink: https://zzz.bwh.harvard.edu/plink/download.shtml <br/>
Samtools: https://github.com/samtools/samtools <br/>
BWA: https://github.com/lh3/bwa <br/>

## Additional Software For Analyses
Haplonerate: https://github.com/mossmatters/phyloscripts/tree/master/haplonerate <br/>
WhatsHap: http://whatshap.readthedocs.io <br/>
BioPython package: https://biopython.org/ <br/>
Python 3.0: https://www.python.org/download/releases/3.0/ <br/>
GNU Parallel: https://www.gnu.org/software/parallel/ <br/>
bcftools: https://samtools.github.io/bcftools/ <br/>


# Prerequisites
From HybPiper, first run  the scripts ```reads_first.py``` followed by ```intronerate.py``` to produce supercontigs for each recovered gene. These supercontigs will be used as a 
"reference sequence" for the sample. If you have several different species, you will need to run the scripts for each individually.

Concatenate all supercontigs into one single (reference) file: <br/>
``` prefix/*/prefix/sequences/intron/*_supercontig.fasta > prefix.supercontigs.fasta ```

Note: "prefix.supercontigs.fasta" will be used as an input on command line along with ```samplename```
<br/>

# Workflow

<a data-flickr-embed="true" href="https://www.flickr.com/photos/189441425@N04/50145016761/in/dateposted-public/" title="dataworkflow"><img src="https://live.staticflickr.com/65535/50145016761_931f464b89_c.jpg" width="800" height="450" alt="dataworkflow"></a>

# <b> variantcall.sh </b>
This script will:
1. Uses ```bwa mem``` to map paired-end reads to supercontigs
2. Replaces read groups for mapped and unmapped bam files
2. Removes duplicate reads 
3. Identifies variant sites using gatk HaplotypeCaller <b>(NOTE: GVCF is produced) </b>
4. Removes intermediate BAM files

Command line: ```bash variantcall.sh prefix.supercontigs.fasta samplename```

Output: Contains many intermediate BAM files and GVCF file

<br/>

# <b> GenotypesToPCA.sh </b> 
This script will:
1. Create samples.list from GVCF files (Use samples.list as variant in step 2)
2. Combine GVCF files into a cohort and genotype 
3. Filter SNP's to remove indels using hard filter <br/>
```"QD < 5.0 || FS > 60.0 || MQ < 40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0" ```
4. Select SNP variants from hard filtering parameters

Command line: ```bash GenotypesToPCA.sh prefix.supercontigs.fasta species```

Potentially useful outputs: ```"$prefix".SNPall.vcf``` (contains all SNPs and indels), ```"$prefix".snp.filtered.vcf``` (only SNPs, removes indels), 
```"$prefix".snp.filtered.nocall.vcf``` (ONLY SNPs that pass a hard filter)

<br/>

# <b> plink_stats.sh </b> 
## Additional dependencies: 
bcftools: https://samtools.github.io/bcftools/ <br/>
Plink: https://zzz.bwh.harvard.edu/plink/download.shtml <br/>

This script will:
1. Set ID name for each SNP (for filtering)
2. Filter SNPs that didn't pass the filter or have missing data
3. Generate eigenvalues and loadings for PCA axes (default set to 20)
4. Generate basic statistics (heterozygosity, inbreeding coefficient, allele frequencies)

Command line: ``` bash plink_stats.sh  "$prefix" ```

<br/> 

# <b> extract_phase_subgenomes.sh </b>
<b> NOTE: DO NOT RUN HAPLOTYPECALLER IN GVCF MODE </b>

This workflow has been modified from Kates et al paper for allodiploid genomes <br/>
Link to Kates et al paper: https://pubmed.ncbi.nlm.nih.gov/29729187/ 

## Additional Dependencies:
Haplonerate: https://github.com/mossmatters/phyloscripts/tree/master/haplonerate <br/>
WhatsHap: http://whatshap.readthedocs.io <br/>
BioPython package: https://biopython.org/ <br/>
Python 3.0: https://www.python.org/download/releases/3.0/ <br/>
GNU Parallel: https://www.gnu.org/software/parallel/ <br/>

This script will:
1. Replace the FASTA headers
2. Run WhatsHap to generate phased VCF using pipe characters
3. Extract two FASTA sequences for each gene, corresponding to two alleles

Command line: ``` bash extract_phase_subgenomes.sh "$prefix" ``` <br/>
Output: One file containing two FASTA format subgenome sequences per individual per gene to be used in phylogenetic analysis
