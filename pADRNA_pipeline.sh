#!/bin/bash

#############
# VARIABLES #
#############

#project name
    name=$1
#working directory (no slash at the end)
    outdir=${2}
#(this script accommodates up to 8 samples) names for S1-S8 (i.e. PC1,PC2,PK1, etc.) in order
    seed1=$3
    seed2=$4
    seed3=$5
    seed4=$6
    seed5=$7
    seed6=$8
    seed7=$9
    seed8=$10

    mappingpbs=${name}_mapping.pbs
    bamtoolspbs=${name}_bam.pbs
    cufflinkspbs=${name}_cuff.pbs
    cuffmergepbs=${name}_cm.pbs
    htseqpbs=${name}_htseq.pbs

	
	
if [ ! -d $outdir ]; then mkdir $outdir; fi

#############
# RAW READS #
#############

#1) Make .txt file per sample that lists each fastq (both line-separated and comma-separated are created here, comma-sep used for mapping)

    if [ ! -d $outdir/fastq/txtfiles ]; then mkdir $outdir/fastq/txtfiles; fi

    echo S1 > $outdir/fastq/txtfiles/S1_linesep.txt
    ls $outdir/fastq/*_S1_*.fastq.gz >> $outdir/fastq/txtfiles/S1_linesep.txt
    sed -i -e '1d' $outdir/fastq/txtfiles/S1_linesep.txt
    paste -d, -s $outdir/fastq/txtfiles/S1_linesep.txt > $outdir/fastq/txtfiles/S1.txt

    echo S2 > $outdir/fastq/txtfiles/S2_linesep.txt
    ls $outdir/fastq/*_S2_*.fastq.gz >> $outdir/fastq/txtfiles/S2_linesep.txt
    sed -i -e '1d' $outdir/fastq/txtfiles/S2_linesep.txt
    paste -d, -s $outdir/fastq/txtfiles/S2_linesep.txt > $outdir/fastq/txtfiles/S2.txt

    echo S3 > $outdir/fastq/txtfiles/S3_linesep.txt
    ls $outdir/fastq/*_S3_*.fastq.gz >> $outdir/fastq/txtfiles/S3_linesep.txt
    sed -i -e '1d' $outdir/fastq/txtfiles/S3_linesep.txt
    paste -d, -s $outdir/fastq/txtfiles/S3_linesep.txt > $outdir/fastq/txtfiles/S3.txt

    echo S4 > $outdir/fastq/txtfiles/S4_linesep.txt
    ls $outdir/fastq/*_S4_*.fastq.gz >> $outdir/fastq/txtfiles/S4_linesep.txt
    sed -i -e '1d' $outdir/fastq/txtfiles/S4_linesep.txt
    paste -d, -s $outdir/fastq/txtfiles/S4_linesep.txt > $outdir/fastq/txtfiles/S4.txt

    echo S5 > $outdir/fastq/txtfiles/S5_linesep.txt
    ls $outdir/fastq/*_S5_*.fastq.gz >> $outdir/fastq/txtfiles/S5_linesep.txt
    sed -i -e '1d' $outdir/fastq/txtfiles/S5_linesep.txt
    paste -d, -s $outdir/fastq/txtfiles/S5_linesep.txt > $outdir/fastq/txtfiles/S5.txt

    echo S6 > $outdir/fastq/txtfiles/S6_linesep.txt
    ls $outdir/fastq/*_S6_*.fastq.gz >> $outdir/fastq/txtfiles/S6_linesep.txt
    sed -i -e '1d' $outdir/fastq/txtfiles/S6_linesep.txt
    paste -d, -s $outdir/fastq/txtfiles/S6_linesep.txt > $outdir/fastq/txtfiles/S6.txt

    echo S7 > $outdir/fastq/txtfiles/S7_linesep.txt
    ls $outdir/fastq/*_S7_*.fastq.gz >> $outdir/fastq/txtfiles/S7_linesep.txt
    sed -i -e '1d' $outdir/fastq/txtfiles/S7_linesep.txt
    paste -d, -s $outdir/fastq/txtfiles/S7_linesep.txt > $outdir/fastq/txtfiles/S7.txt

    echo S8 > $outdir/fastq/txtfiles/S8_linesep.txt
    ls $outdir/fastq/*_S8_*.fastq.gz >> $outdir/fastq/txtfiles/S8_linesep.txt
    sed -i -e '1d' $outdir/fastq/txtfiles/S8_linesep.txt
    paste -d, -s $outdir/fastq/txtfiles/S8_linesep.txt > $outdir/fastq/txtfiles/S8.txt


###########
# MAPPING #
###########

#1) outdir
	if [ ! -d $outdir/Mapping ]; then mkdir $outdir/Mapping; fi
    if [ ! -d $outdir/Mapping/$seed1 ]; then mkdir $outdir/Mapping/$seed1; fi
    if [ ! -d $outdir/Mapping/$seed2 ]; then mkdir $outdir/Mapping/$seed2; fi
    if [ ! -d $outdir/Mapping/$seed3 ]; then mkdir $outdir/Mapping/$seed3; fi
    if [ ! -d $outdir/Mapping/$seed4 ]; then mkdir $outdir/Mapping/$seed4; fi
    if [ ! -d $outdir/Mapping/$seed5 ]; then mkdir $outdir/Mapping/$seed5; fi
    if [ ! -d $outdir/Mapping/$seed6 ]; then mkdir $outdir/Mapping/$seed6; fi
    if [ ! -d $outdir/Mapping/$seed7 ]; then mkdir $outdir/Mapping/$seed7; fi
    if [ ! -d $outdir/Mapping/$seed8 ]; then mkdir $outdir/Mapping/$seed8; fi

#1.5) new variables
    S1fastqs=$(</$outdir/fastq/txtfiles/S1.txt)
    S2fastqs=$(</$outdir/fastq/txtfiles/S2.txt)
    S3fastqs=$(</$outdir/fastq/txtfiles/S3.txt)
    S4fastqs=$(</$outdir/fastq/txtfiles/S4.txt)
    S5fastqs=$(</$outdir/fastq/txtfiles/S5.txt)
    S6fastqs=$(</$outdir/fastq/txtfiles/S6.txt)
    S7fastqs=$(</$outdir/fastq/txtfiles/S7.txt)
    S8fastqs=$(</$outdir/fastq/txtfiles/S8.txt)

#2) Resource Manager Directives to .pbs File
	echo '#!/bin/bash' > $outdir/Mapping/$mappingpbs
	echo '#PBS -N Mapping' >> $outdir/Mapping/$mappingpbs
	echo '#PBS -S /bin/bash' >> $outdir/Mapping/$mappingpbs
	echo '#PBS -l walltime=24:00:00' >> $outdir/Mapping/$mappingpbs
	echo '#PBS -l nodes=1:ppn=16' >> $outdir/Mapping/$mappingpbs
	echo '#PBS -l mem=512gb' >> $outdir/Mapping/$mappingpbs
	echo '#PBS -o '$outdir'/Mapping/info' >> $outdir/Mapping/$mappingpbs
	echo '#PBS -e '$outdir'/Mapping/info' >> $outdir/Mapping/$mappingpbs

#3) Commands
	echo '############' >> $outdir/Mapping/$mappingpbs
	echo '# COMMANDS #' >> $outdir/Mapping/$mappingpbs
	echo '############' >> $outdir/Mapping/$mappingpbs

	echo 'module load gcc/6.2.0' >> $outdir/Mapping/$mappingpbs
	echo 'module load tophat/2.1.1' >> $outdir/Mapping/$mappingpbs
	echo 'module load bowtie2/2.1.0' >> $outdir/Mapping/$mappingpbs

    echo 'tophat -p 16 -o '$outdir'/Mapping/'$seed1' -G /group/referenceFiles/Mus_musculus/UCSC/mm10/Annotation/Genes/genes.gtf /group/referenceFiles/Mus_musculus/UCSC/mm10/Sequence/IlluminaBowtie2Index/genome '$S1fastqs'' >> $outdir/Mapping/$mappingpbs
	echo 'cp '$outdir'/Mapping/'$seed1'/accepted_hits.bam '$outdir'/Mapping/'$seed1'/'$seed1'_accepted_hits.bam' >> $outdir/Mapping/$mappingpbs
	echo 'rm '$outdir'/Mapping/'$seed1'/accepted_hits.bam' >> $outdir/Mapping/$mappingpbs
	
	echo 'module load samtools/1.5' >> $outdir/Mapping/$mappingpbs
	echo 'samtools index '$outdir'/Mapping/'$seed1'/'$seed1'_accepted_hits.bam' >> $outdir/Mapping/$mappingpbs


    echo 'tophat -p 16 -o '$outdir'/Mapping/'$seed2' -G /group/referenceFiles/Mus_musculus/UCSC/mm10/Annotation/Genes/genes.gtf /group/referenceFiles/Mus_musculus/UCSC/mm10/Sequence/IlluminaBowtie2Index/genome '$S2fastqs'' >> $outdir/Mapping/$mappingpbs
    echo 'cp '$outdir'/Mapping/'$seed2'/accepted_hits.bam '$outdir'/Mapping/'$seed2'/'$seed2'_accepted_hits.bam' >> $outdir/Mapping/$mappingpbs
    echo 'rm '$outdir'/Mapping/'$seed2'/accepted_hits.bam' >> $outdir/Mapping/$mappingpbs

    echo 'module load samtools/1.5' >> $outdir/Mapping/$mappingpbs
    echo 'samtools index '$outdir'/Mapping/'$seed2'/'$seed2'_accepted_hits.bam' >> $outdir/Mapping/$mappingpbs


    echo 'tophat -p 16 -o '$outdir'/Mapping/'$seed3' -G /group/referenceFiles/Mus_musculus/UCSC/mm10/Annotation/Genes/genes.gtf /group/referenceFiles/Mus_musculus/UCSC/mm10/Sequence/IlluminaBowtie2Index/genome '$S3fastqs'' >> $outdir/Mapping/$mappingpbs
    echo 'cp '$outdir'/Mapping/'$seed3'/accepted_hits.bam '$outdir'/Mapping/'$seed3'/'$seed3'_accepted_hits.bam' >> $outdir/Mapping/$mappingpbs
    echo 'rm '$outdir'/Mapping/'$seed3'/accepted_hits.bam' >> $outdir/Mapping/$mappingpbs

    echo 'module load samtools/1.5' >> $outdir/Mapping/$mappingpbs
    echo 'samtools index '$outdir'/Mapping/'$seed3'/'$seed3'_accepted_hits.bam' >> $outdir/Mapping/$mappingpbs


    echo 'tophat -p 16 -o '$outdir'/Mapping/'$seed4' -G /group/referenceFiles/Mus_musculus/UCSC/mm10/Annotation/Genes/genes.gtf /group/referenceFiles/Mus_musculus/UCSC/mm10/Sequence/IlluminaBowtie2Index/genome '$S4fastqs'' >> $outdir/Mapping/$mappingpbs
    echo 'cp '$outdir'/Mapping/'$seed4'/accepted_hits.bam '$outdir'/Mapping/'$seed4'/'$seed4'_accepted_hits.bam' >> $outdir/Mapping/$mappingpbs
    echo 'rm '$outdir'/Mapping/'$seed4'/accepted_hits.bam' >> $outdir/Mapping/$mappingpbs

    echo 'module load samtools/1.5' >> $outdir/Mapping/$mappingpbs
    echo 'samtools index '$outdir'/Mapping/'$seed4'/'$seed4'_accepted_hits.bam' >> $outdir/Mapping/$mappingpbs


    echo 'tophat -p 16 -o '$outdir'/Mapping/'$seed5' -G /group/referenceFiles/Mus_musculus/UCSC/mm10/Annotation/Genes/genes.gtf /group/referenceFiles/Mus_musculus/UCSC/mm10/Sequence/IlluminaBowtie2Index/genome '$S5fastqs'' >> $outdir/Mapping/$mappingpbs
    echo 'cp '$outdir'/Mapping/'$seed5'/accepted_hits.bam '$outdir'/Mapping/'$seed5'/'$seed5'_accepted_hits.bam' >> $outdir/Mapping/$mappingpbs
    echo 'rm '$outdir'/Mapping/'$seed5'/accepted_hits.bam' >> $outdir/Mapping/$mappingpbs

    echo 'module load samtools/1.5' >> $outdir/Mapping/$mappingpbs
    echo 'samtools index '$outdir'/Mapping/'$seed5'/'$seed5'_accepted_hits.bam' >> $outdir/Mapping/$mappingpbs


    echo 'tophat -p 16 -o '$outdir'/Mapping/'$seed6' -G /group/referenceFiles/Mus_musculus/UCSC/mm10/Annotation/Genes/genes.gtf /group/referenceFiles/Mus_musculus/UCSC/mm10/Sequence/IlluminaBowtie2Index/genome '$S6fastqs'' >> $outdir/Mapping/$mappingpbs
    echo 'cp '$outdir'/Mapping/'$seed6'/accepted_hits.bam '$outdir'/Mapping/'$seed6'/'$seed6'_accepted_hits.bam' >> $outdir/Mapping/$mappingpbs
    echo 'rm '$outdir'/Mapping/'$seed6'/accepted_hits.bam' >> $outdir/Mapping/$mappingpbs

    echo 'module load samtools/1.5' >> $outdir/Mapping/$mappingpbs
    echo 'samtools index '$outdir'/Mapping/'$seed6'/'$seed6'_accepted_hits.bam' >> $outdir/Mapping/$mappingpbs


    echo 'tophat -p 16 -o '$outdir'/Mapping/'$seed7' -G /group/referenceFiles/Mus_musculus/UCSC/mm10/Annotation/Genes/genes.gtf /group/referenceFiles/Mus_musculus/UCSC/mm10/Sequence/IlluminaBowtie2Index/genome '$S7fastqs'' >> $outdir/Mapping/$mappingpbs
    echo 'cp '$outdir'/Mapping/'$seed7'/accepted_hits.bam '$outdir'/Mapping/'$seed7'/'$seed7'_accepted_hits.bam' >> $outdir/Mapping/$mappingpbs
    echo 'rm '$outdir'/Mapping/'$seed7'/accepted_hits.bam' >> $outdir/Mapping/$mappingpbs

    echo 'module load samtools/1.5' >> $outdir/Mapping/$mappingpbs
    echo 'samtools index '$outdir'/Mapping/'$seed7'/'$seed7'_accepted_hits.bam' >> $outdir/Mapping/$mappingpbs


    echo 'tophat -p 16 -o '$outdir'/Mapping/'$seed8' -G /group/referenceFiles/Mus_musculus/UCSC/mm10/Annotation/Genes/genes.gtf /group/referenceFiles/Mus_musculus/UCSC/mm10/Sequence/IlluminaBowtie2Index/genome '$S8fastqs'' >> $outdir/Mapping/$mappingpbs
    echo 'cp '$outdir'/Mapping/'$seed8'/accepted_hits.bam '$outdir'/Mapping/'$seed8'/'$seed8'_accepted_hits.bam' >> $outdir/Mapping/$mappingpbs
    echo 'rm '$outdir'/Mapping/'$seed8'/accepted_hits.bam' >> $outdir/Mapping/$mappingpbs

    echo 'module load samtools/1.5' >> $outdir/Mapping/$mappingpbs
    echo 'samtools index '$outdir'/Mapping/'$seed8'/'$seed8'_accepted_hits.bam' >> $outdir/Mapping/$mappingpbs

#4) Execute
	qsub $outdir/Mapping/$mappingpbs

############
# BAMTOOLS #
############

#1) outdir
	if [ ! -d $outdir/Bamtools ]; then mkdir $outdir/Bamtools; fi
	
#2) Resource Manager Directives to .pbs File
	echo '#!/bin/bash' > $outdir/Bamtools/$bamtoolspbs
	echo '#PBS -N Bamtools' >> $outdir/Bamtools/$bamtoolspbs
	echo '#PBS -S /bin/bash' >> $outdir/Bamtools/$bamtoolspbs
	echo '#PBS -l walltime=8:00:00' >> $outdir/Bamtools/$bamtoolspbs
	echo '#PBS -l nodes=1:ppn=1' >> $outdir/Bamtools/$bamtoolspbs
	echo '#PBS -l mem=120gb' >> $outdir/Bamtools/$bamtoolspbs
	echo '#PBS -o '$outdir'/Bamtools/info' >> $outdir/Bamtools/$bamtoolspbs	
	echo '#PBS -e '$outdir'/Bamtools/info' >> $outdir/Bamtools/$bamtoolspbs

#3) Commands
	echo '############' >> $outdir/Bamtools/$bamtoolspbs
	echo '# COMMANDS #' >> $outdir/Bamtools/$bamtoolspbs
	echo '############' >> $outdir/Bamtools/$bamtoolspbs
	
	echo 'module load gcc/6.2.0' >> $outdir/Bamtools/$bamtoolspbs
	echo 'module load bamtools/2.4.1' >> $outdir/Bamtools/$bamtoolspbs

    for seed in $outdir/Mapping/
    do
    $seed=seed

	echo 'bamtools filter -in '$outdir'/Mapping/'$seed'/'$seed'_accepted_hits.bam -out '$outdir'/Bamtools/'$seed'/chr1.bam -mapQuality ">10" -region chr1' >> $outdir/Bamtools/$bamtoolspbs
	echo 'bamtools filter -in '$outdir'/Mapping/'$seed'/'$seed'_accepted_hits.bam -out '$outdir'/Bamtools/'$seed'/chr2.bam -mapQuality ">10" -region chr2' >> $outdir/Bamtools/$bamtoolspbs
	echo 'bamtools filter -in '$outdir'/Mapping/'$seed'/'$seed'_accepted_hits.bam -out '$outdir'/Bamtools/'$seed'/chr3.bam -mapQuality ">10" -region chr3' >> $outdir/Bamtools/$bamtoolspbs
	echo 'bamtools filter -in '$outdir'/Mapping/'$seed'/'$seed'_accepted_hits.bam -out '$outdir'/Bamtools/'$seed'/chr4.bam -mapQuality ">10" -region chr4' >> $outdir/Bamtools/$bamtoolspbs
	echo 'bamtools filter -in '$outdir'/Mapping/'$seed'/'$seed'_accepted_hits.bam -out '$outdir'/Bamtools/'$seed'/chr5.bam -mapQuality ">10" -region chr5' >> $outdir/Bamtools/$bamtoolspbs
	echo 'bamtools filter -in '$outdir'/Mapping/'$seed'/'$seed'_accepted_hits.bam -out '$outdir'/Bamtools/'$seed'/chr6.bam -mapQuality ">10" -region chr6' >> $outdir/Bamtools/$bamtoolspbs
	echo 'bamtools filter -in '$outdir'/Mapping/'$seed'/'$seed'_accepted_hits.bam -out '$outdir'/Bamtools/'$seed'/chr7.bam -mapQuality ">10" -region chr7' >> $outdir/Bamtools/$bamtoolspbs
	echo 'bamtools filter -in '$outdir'/Mapping/'$seed'/'$seed'_accepted_hits.bam -out '$outdir'/Bamtools/'$seed'/chr8.bam -mapQuality ">10" -region chr8' >> $outdir/Bamtools/$bamtoolspbs
	echo 'bamtools filter -in '$outdir'/Mapping/'$seed'/'$seed'_accepted_hits.bam -out '$outdir'/Bamtools/'$seed'/chr9.bam -mapQuality ">10" -region chr9' >> $outdir/Bamtools/$bamtoolspbs
	echo 'bamtools filter -in '$outdir'/Mapping/'$seed'/'$seed'_accepted_hits.bam -out '$outdir'/Bamtools/'$seed'/chr10.bam -mapQuality ">10" -region chr10' >> $outdir/Bamtools/$bamtoolspbs
	echo 'bamtools filter -in '$outdir'/Mapping/'$seed'/'$seed'_accepted_hits.bam -out '$outdir'/Bamtools/'$seed'/chr11.bam -mapQuality ">10" -region chr11' >> $outdir/Bamtools/$bamtoolspbs
	echo 'bamtools filter -in '$outdir'/Mapping/'$seed'/'$seed'_accepted_hits.bam -out '$outdir'/Bamtools/'$seed'/chr12.bam -mapQuality ">10" -region chr12' >> $outdir/Bamtools/$bamtoolspbs
	echo 'bamtools filter -in '$outdir'/Mapping/'$seed'/'$seed'_accepted_hits.bam -out '$outdir'/Bamtools/'$seed'/chr13.bam -mapQuality ">10" -region chr13' >> $outdir/Bamtools/$bamtoolspbs
	echo 'bamtools filter -in '$outdir'/Mapping/'$seed'/'$seed'_accepted_hits.bam -out '$outdir'/Bamtools/'$seed'/chr14.bam -mapQuality ">10" -region chr14' >> $outdir/Bamtools/$bamtoolspbs
	echo 'bamtools filter -in '$outdir'/Mapping/'$seed'/'$seed'_accepted_hits.bam -out '$outdir'/Bamtools/'$seed'/chr15.bam -mapQuality ">10" -region chr15' >> $outdir/Bamtools/$bamtoolspbs
	echo 'bamtools filter -in '$outdir'/Mapping/'$seed'/'$seed'_accepted_hits.bam -out '$outdir'/Bamtools/'$seed'/chr16.bam -mapQuality ">10" -region chr16' >> $outdir/Bamtools/$bamtoolspbs
	echo 'bamtools filter -in '$outdir'/Mapping/'$seed'/'$seed'_accepted_hits.bam -out '$outdir'/Bamtools/'$seed'/chr17.bam -mapQuality ">10" -region chr17' >> $outdir/Bamtools/$bamtoolspbs
	echo 'bamtools filter -in '$outdir'/Mapping/'$seed'/'$seed'_accepted_hits.bam -out '$outdir'/Bamtools/'$seed'/chr18.bam -mapQuality ">10" -region chr18' >> $outdir/Bamtools/$bamtoolspbs
	echo 'bamtools filter -in '$outdir'/Mapping/'$seed'/'$seed'_accepted_hits.bam -out '$outdir'/Bamtools/'$seed'/chr19.bam -mapQuality ">10" -region chr19' >> $outdir/Bamtools/$bamtoolspbs
	echo 'bamtools filter -in '$outdir'/Mapping/'$seed'/'$seed'_accepted_hits.bam -out '$outdir'/Bamtools/'$seed'/chrX.bam -mapQuality ">10" -region chrX' >> $outdir/Bamtools/$bamtoolspbs
	
	echo 'echo list > '$outdir'/Bamtools/'$seed'/list.txt' >> $outdir/Bamtools/$bamtoolspbs
	echo 'ls '$outdir'/Bamtools/'$seed'/chr*.bam >> '$outdir'/Bamtools/'$seed'/list.txt' >> $outdir/Bamtools/$bamtoolspbs
    echo 'sed -i -e "1d" '$outdir'/Bamtools/'$seed'/list.txt' >> $outdir/Bamtools/$bamtoolspbs
	
		
	echo 'bamtools merge -list '$outdir'/Bamtools/'$seed'/list.txt -out '$outdir'/Bamtools/'$seed'/'$seed'_cleaned.bam' >> $outdir/Bamtools/$bamtoolspbs
	
	echo 'rm '$outdir'/Bamtools/'$seed'/chr*.bam' >> $outdir/Bamtools/$bamtoolspbs
	
	echo 'module load samtools/1.5' >> $outdir/Bamtools/$bamtoolspbs
	echo 'samtools index '$outdir'/Bamtools/'$seed'/'$seed'_cleaned.bam' >> $outdir/Bamtools/$bamtoolspbs
	echo 'samtools idxstats '$outdir'/Bamtools/'$seed'/'$seed'_cleaned.bam > '$outdir'/Bamtools/'$seed'/'$seed'_stats.txt' >> $outdir/Bamtools/$bamtoolspbs
	echo 'cut -f3 '$outdir'/Bamtools/'$seed'/'$seed'_stats.txt | paste -sd+ | bc >> '$outdir'/Bamtools/'$seed'/'$seed'_stats.txt' >> $outdir/Bamtools/$bamtoolspbs

    done

#4) Execute
    qsub $outdir/Bamtools/$bamtoolspbs





# the following is garbage

#############
# CUFFLINKS #
#############

#1) outdir
    if [ ! -d $outdir/Cufflinks ]; then mkdir $outdir/Cufflinks; fi

#2) Resource Manager Directives to .pbs File
    echo '#!/bin/bash' > $outdir/Cufflinks/$cufflinkspbs
    echo '#PBS -N '$seed'_Cufflinks' >> $outdir/Cufflinks/$cufflinkspbs
    echo '#PBS -S /bin/bash' >> $outdir/Cufflinks/$cufflinkspbs
    echo '#PBS -l walltime=12:00:00' >> $outdir/Cufflinks/$cufflinkspbs
    echo '#PBS -l nodes=1:ppn=16' >> $outdir/Cufflinks/$cufflinkspbs
    echo '#PBS -l mem=120gb' >> $outdir/Cufflinks/$cufflinkspbs
    echo '#PBS -o '$outdir'/Cufflinks/info' >> $outdir/Cufflinks/$cufflinkspbs
    echo '#PBS -e '$outdir'/Cufflinks/info' >> $outdir/Cufflinks/$cufflinkspbs

#3) Commands
    echo '############' >> $outdir/Cufflinks/$cufflinkspbs
    echo '# COMMANDS #' >> $outdir/Cufflinks/$cufflinkspbs
    echo '############' >> $outdir/Cufflinks/$cufflinkspbs

    echo 'module load gcc/6.2.0' >> $outdir/Cufflinks/$cufflinkspbs
    echo 'module load cufflinks/2.2.1' >> $outdir/Cufflinks/$cufflinkspbs

    echo 'cufflinks -p 16 -o '$outdir'/Cufflinks/'$seed' '$outdir'/Bamtools/'$seed'/'$seed'_cleaned.bam' >> $outdir/Cufflinks/$cufflinkspbs

#4) Execute
    qsub $outdir/Cufflinks/$cufflinkspbs

#############
# CUFFMERGE #
#############

#1) outdir
    if [ ! -d $outdir/Cuffmerge ]; then mkdir $outdir/Cuffmerge; fi

#2) Resource Manager Directives to .pbs File
    echo '#!/bin/bash' > $outdir/Cuffmerge/$cuffmergepbs
    echo '#PBS -N '$seed'' >> $outdir/Cuffmerge/$cuffmergepbs
    echo '#PBS -S /bin/bash' >> $outdir/Cuffmerge/$cuffmergepbs
    echo '#PBS -l walltime=8:00:00' >> $outdir/Cuffmerge/$cuffmergepbs
    echo '#PBS -l nodes=1:ppn=16' >> $outdir/Cuffmerge/$cuffmergepbs
    echo '#PBS -l mem=120gb' >> $outdir/Cuffmerge/$cuffmergepbs
    echo '#PBS -o '$outdir'/Cuffmerge/info' >> $outdir/Cuffmerge/$cuffmergepbs
    echo '#PBS -e '$outdir'/Cuffmerge/info' >> $outdir/Cuffmerge/$cuffmergepbs

#3) Commands
    echo '############' >> $outdir/Cuffmerge/$cuffmergepbs
    echo '# COMMANDS #' >> $outdir/Cuffmerge/$cuffmergepbs
    echo '############' >> $outdir/Cuffmerge/$cuffmergepbs

    echo 'module load gcc/6.2.0' >> $outdir/Cuffmerge/$cuffmergepbs
    echo 'module load cufflinks/2.2.1' >> $outdir/Cuffmerge/$cuffmergepbs

# CHECK
    echo 'echo list > '$outdir'/Cuffmerge/'$seed'/cuffmerge_input.txt' >> $outdir/Cuffmerge/$cuffmergepbs
    echo 'ls '$outdir'/Cufflinks/'$seed'/transcripts.gtf >> '$outdir'/Cuffmerge/'$seed'/cuffmerge_input.txt' >> $outdir/Cuffmerge/$cuffmergepbs
    echo 'sed -i -e "1d" '$outdir'/Cuffmerge/'$seed'/cuffmerge_input.txt' >> $outdir/Cuffmerge/$cuffmergepbs

    echo 'cuffmerge -p 16 -s /group/referenceFiles/Mus_musculus/UCSC/mm10/Sequence/WholeGenomeFasta/genome.fa -o '$outdir'/Cuffmerge/output '$outdir'/Cuffmerge/cuffmerge_input.txt' >> $outdir/Cuffmerge/$cuffmergepbs

#4) Execute
    qsub $outdir/Cuffmerge/$cuffmergepbs

#########
# HTSEQ #
#########

#1) outdir
    if [ ! -d $outdir/HTseq ]; then mkdir $outdir/HTseq; fi

#2) Resource Manager Directives to .pbs File
    echo '#!/bin/bash' > $outdir/HTseq/$htseqpbs
    echo '#PBS -N HTseq_'$seed'_cleaned.bam' >> $outdir/HTseq/$htseqpbs
    echo '#PBS -S /bin/bash' >> $outdir/HTseq/$htseqpbs
    echo '#PBS -l walltime=2:00:00' >> $outdir/HTseq/$htseqpbs
    echo '#PBS -l nodes=1:ppn=1' >> $outdir/HTseq/$htseqpbs
    echo '#PBS -l mem=20gb' >> $outdir/HTseq/$htseqpbs
    echo '#PBS -o '$outdir'/HTseq/logs/'$seed'_cleaned.bam_output
    echo '#PBS -e '$outdir'/HTseq/logs/'$seed'_cleaned.bam_error

#3) Commands
    echo '############' >> $outdir/HTseq/$htseqpbs
    echo '# COMMANDS #' >> $outdir/HTseq/$htseqpbs
    echo '############' >> $outdir/HTseq/$htseqpbs

    echo 'module load gcc/6.2.0' >> $outdir/HTseq/$htseqpbs
    echo 'module load python/2.7.13' >> $outdir/HTseq/$htseqpbs

    echo 'htseq-count -f bam -t exon -s no -r pos -i gene_id '$outdir'/Bamtools/'$seed'_cleaned.bam '$outdir'/Cuffmerge/output/merged.gtf > '$outdir'/HTseq/'$seed'_cleaned.bam_counts.out' >> $outdir/HTseq/$htseqpbs

#4) Execute
    qsub $outdir/HTseq/$htseqpbs

##############
# DE TESTING #
##############

#1) outdir
    if [ ! -d $outdir/DE ]; then mkdir $outdir/DE; fi

#2) Resource Manager Directives to .pbs File
    echo '#!/bin/bash' > $outdir/DE/$depbs
    echo '#PBS -N DE_testing' >> $outdir/DE/$depbs
    echo '#PBS -S /bin/bash' >> $outdir/DE/$depbs
    echo '#PBS -l walltime=8:00:00' >> $outdir/DE/$depbs
    echo '#PBS -l nodes=1:ppn=1' >> $outdir/DE/$depbs
    echo '#PBS -l mem=120gb' >> $outdir/DE/$depbs
    echo '#PBS -o '$outdir'/DE' >> $outdir/DE/$depbs
    echo '#PBS -e '$outdir'/DE' >> $outdir/DE/$depbs

#3) Commands
    echo '############' >> $outdir/DE/$depbs
    echo '# COMMANDS #' >> $outdir/DE/$depbs
    echo '############' >> $outdir/DE/$depbs

    echo 'module load gcc/6.2.0' >> $outdir/DE/$depbs
    echo 'module load R/3.3.2' >> $outdir/DE/$depbs
    echo 'module load bedtools/2.26.0' >> $outdir/DE/$depbs
    echo 'module load bedops/2.4.26' >> $outdir/DE/$depbs

    echo 'Rscript '$outdir'/DE/DE_testing.R' >> $outdir/DE/$depbs

#4) Execute
    qsub $outdir/DE/$depbs



exit;

