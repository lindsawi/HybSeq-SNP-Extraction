# HybSeq-SNP-Extraction

# Software
HybPiper (generates supercontigs): https://github.com/mossmatters/HybPiper
GATK4: https://github.com/broadinstitute/gatk/releases 


# Prerequisites
From HybPiper, first run ``` reads_first.py ``` followed by ```intronerate.py``` scripts to produce supercontigs for each recovered gene. These supercontigs will be used as a 
"reference sequence" for the sample. If you have several different species, you will need to run the scripts for each species individually.