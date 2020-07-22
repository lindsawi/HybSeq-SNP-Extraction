# HybSeq-SNP-Extraction

# Software
HybPiper (generates supercontigs): https://github.com/mossmatters/HybPiper <br/>
GATK4: https://github.com/broadinstitute/gatk/releases 


# Prerequisites
From HybPiper, first run ``` reads_first.py ``` followed by ```intronerate.py``` scripts to produce supercontigs for each recovered gene. These supercontigs will be used as a 
"reference sequence" for the sample. If you have several different species, you will need to run the scripts for each individually.

Concatenate all supercontigs into one single (reference) file: 
``` prefix/*/prefix/sequences/intron/*_supercontig.fasta > prefix.supercontigs.fasta ```

Note: "prefix.supercontigs.fasta" will be used as an input on command line along with ```prefix```

 