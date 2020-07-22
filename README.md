# HybSeq-SNP-Extraction

# Software
HybPiper (produces supercontigs): https://github.com/mossmatters/HybPiper <br/>
GATK4: https://github.com/broadinstitute/gatk/releases 


# Prerequisites
From HybPiper, first run  the scripts ```reads_first.py``` followed by ```intronerate.py``` to produce supercontigs for each recovered gene. These supercontigs will be used as a 
"reference sequence" for the sample. If you have several different species, you will need to run the scripts for each individually.

Concatenate all supercontigs into one single (reference) file: <br/>
``` prefix/*/prefix/sequences/intron/*_supercontig.fasta > prefix.supercontigs.fasta ```

Note: "prefix.supercontigs.fasta" will be used as an input on command line along with ```samplename```
<br/>

# <b> variantcall.sh </b>
This script:
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

# <b> extract_phase_subgenomes.sh </b>
let's talk about it together???
This script will:
1. Replace the FASTA headers
2. Run WhatsHap to generate phased VCF
3. Extract two fasta sequences for each gene, corresponding to two alleles

Command line: ``` bash extract_phase_subgenomes.sh "$prefix" ```
Output: Phased sequences for alleles