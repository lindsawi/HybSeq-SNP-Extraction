# HybSeq-SNP-Extraction

# Software
HybPiper (produces supercontigs): https://github.com/mossmatters/HybPiper <br/>
GATK4: https://github.com/broadinstitute/gatk/releases 


# Prerequisites
From HybPiper, first run  the scripts ``` reads_first.py ``` followed by ```intronerate.py``` to produce supercontigs for each recovered gene. These supercontigs will be used as a 
"reference sequence" for the sample. If you have several different species, you will need to run the scripts for each individually.

Concatenate all supercontigs into one single (reference) file: 
``` prefix/*/prefix/sequences/intron/*_supercontig.fasta > prefix.supercontigs.fasta ```

Note: "prefix.supercontigs.fasta" will be used as an input on command line along with ```samplename```

# <b> variantcall.sh </b>
This script:
1. Uses ```bwa mem``` to map paired-end reads to supercontigs
2. Replaces read groups for mapped and unmapped bam files
2. Removes duplicate reads 
3. Identifies variant sites using gatk HaplotypeCaller <b>(NOTE: GVCF is produced) </b>
4. Removes intermediate BAM files

command line: bash variantcall.sh prefix.supercontigs.fasta samplename

Output: Contains many intermediate BAM files and GVCF file

# <b> GenotypesToPCA.sh </b> 

# <b> plink_stats.sh </b>

