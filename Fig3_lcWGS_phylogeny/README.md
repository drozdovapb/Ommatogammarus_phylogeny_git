This folder contains reproducible code and valuable intermediate results (including assemblies and annotation) analysis of mitochondrial genomes, nuclear rDNA loci, and 8 PGCs (the latter were not used in the manuscript)

#### 1. Mitogenomes

## Analysis of mitochondrial genomes

Mt genome assembly and annotation was performed for the three species using the same pipeline but is shown for _O. albinus_ as an example.

# Dependencies
  * MitoFinder
  * MITObim
  * MtGrasp

# Genome assembly

All calculations were performed on a laptop (12 Gb RAM).
Read trimming and filtering was performed with bbduk. Adapter sequences were taken from its resources as well.

```
curl https://raw.githubusercontent.com/BioInfoTools/BBMap/refs/heads/master/resources/adapters.fa
bbduk.sh -Xmx1G in=SSP_617_WGS_Oal-D2_L1_1.fq.gz in2=SSP_617_WGS_Oal-D2_L1_2.fq.gz out=Oal_D2_filt_1.fq.gz out2=Oal_D2_filt_2.fq.gz \
  ktrim=r k=23 mink=11 hdist=1 ref=adapters.fa
```

Then, reads corresponding to the reference genome of a related species _Eulimnogammarus cyaneus_ (NCBI GenBank accession `KX341964`) were filtered in order to reduce the computational load. 
According to our previous benchmarks, it does not have negative impact on the quality of the assembly.

```
java -ea -Xmx2g -Xms2g -cp /usr/share/java/bbmap.jar jgi.BBDuk \
  in=../../data/Oal_D2_filt_1.fq.gz in2=../../data/Oal_D2_filt_2.fq.gz \
  ref=../../refs/KX341964_Ecy_mt_complete_genome.fa \
  outm=Oal_D2_filt_Ecym_1.fq.gz outm2=Oal_D2_filt_Ecym_2.fq.gz k=17
  rcomp=t qhdist=0 -Xmx2g
```
Run MitoFinder:
```
conda activate mitofinder
mitofinder -j Oal_2Ecy_mf -1 Oal_D2_filt_Ecym_1.fq.gz -2 Oal_D2_filt_Ecym_2.fq.gz -o 5 -r ../../refs/KX341964_Ecy_mt_complete_genome.gb
```

MitoFinder results:
    ```
    MitoFinder found a single mitochondrial contig
    Checking resulting contig for circularization...
    Evidences of circularization could not be found, but everyother step was successful
    <...>
    15 genes were found in mtDNA_contig
    ```
So, the coding part of the mitocchondrial genome was assembled, but the assembly could not be circularized. 
Presumably, the control region failed to assemble, which makes total sense since it is the most diverse region and hard-to-assemble regions in mt genomes. 
This was overcome with MitoBIM, which uses a totally different principle (iterative mapping instead of de novo assembly):

Interleaving reads (necessary for MitoBIM; output should be `.fastq.gz` and not `.fq.gz`):

`bbduk.sh -Xmx1G in=Oal_D2_filt_1.fq.gz in2=Oal_D2_filt_2.fq.gz out=Oal_D2_filt_interleaved.fastq.gz`

Required for mira: `export LC_ALL=C`

Running MitoBIM:
```
MITObim.pl -start 1 -end 30 -sample Oal_D2 -ref Oal_D2_mf -readpool ../../data/Oal_D2_filt_interleaved.fastq.gz --kbait 31 --quick ../01_Oal_2Ecy/Oal_2Ecy_mf/Oal_2Ecy_mf_MitoFinder_megahit_mitfi_Final_Results/Oal_2Ecy_mf_mtDNA_contig.fasta
```
Returning to MitoFinder for annotation:
```
(mitofinder) mitofinder -a iteration11/Oal_D2-Oal_D2_mf-it11_noIUPAC.fasta -r ../../refs/KX341964_Ecy_mt_complete_genome.gb -o 5 -j Oal_D2_mf_mb
```

Now circular!
    ```
    Evidences of circularization were found!
    Sequence is going to be trimmed according to circularization position. 
    <...>
    Note: 
    15 genes were found in mtDNA_contig
    ```

But we need to set the starting point straight!
!!! Standardize (starting from tRNA-Phe)
```
(mtgrasp) drozdovapb@server:~/mtgrasp_standardize$ mtgrasp_standardize.py -i Oal_D2_mf_mb_mtDNA_contig.fasta -o Oal_D2_mf_mb -c 5 -mp mitos_python_scripts/ -p OalD2_mf_mb_mtg_mtDNA_contig.fasta
Start standardization for Oal_D2_mf_mb_mtDNA_contig.fasta
Start standardizing the start site of the mitochondrial genome
The mitochondrial genetic code is: 5
Output: missing:rrnL OL
duplicated:2x rrnS 4x OH
tRNA-Phe Gene Found!
```
(note to self: had to copy mitos_python_scripts here & manually correct first lines in two of them to get the whole thing to work)

Returning to MitoFinder for annotation:
```
(mitofinder) mitofinder -a OalD2_mf_mb_mtg_mtDNA_contig.fasta.final-mtgrasp_v1.1.8-assembly.fa -r ../../NCBI/KX341964_Ecy_mt_complete_genome.gb -o 5 -j Oal_D2_mf_mb_mtg
```
15 genes found.

This was an example for Oal; the other two species were processed in the exact same manner.



## Trees

```
ls ./0_assemblies/NCBI/

ls ./0_assemblies/new/

cd ./1_annotation/

## decided not to use, too distantmitofinder -j Gla_MK354235 -a ../0_assemblies/NCBI/MK354235_Gammarus_lacustris_mitochondrion.fasta \
##        -r ../0_assemblies/NCBI/KX341962_Acanthogammarus_victorii_mitochondrion.gb -o 5

## decided not to use, too distant
#mitofinder -j Gla_MZ029704 -a ../0_assemblies/NCBI/MZ029704_Gammarus_lacustris_CNGBdb.fasta \
#        -r ../0_assemblies/NCBI/KX341962_Acanthogammarus_victorii_mitochondrion.gb -o 5

mitofinder -j EveW_KF690638 -a ../0_assemblies/NCBI/KF690638_Eve_mt_complete_genome.fasta \
        -r ../0_assemblies/NCBI/KX341962_Acanthogammarus_victorii_mitochondrion.gb -o 5

mitofinder -j EveS_PB2 -a ../0_assemblies/new/EvePB_2_filt_metaspades_mtDNA_contigs.fasta \
        -r ../0_assemblies/NCBI/KX341962_Acanthogammarus_victorii_mitochondrion.gb -o 5

mitofinder -j EveE_20181 -a ../0_assemblies/new/EveUB_2018_1_filt_metaspades_mtDNA_contig.fasta \
        -r ../0_assemblies/NCBI/KX341962_Acanthogammarus_victorii_mitochondrion.gb -o 5

mitofinder -j Ecy_KX341964 -a ../0_assemblies/NCBI/KX341964_Ecy_mt_complete_genome.fasta \
        -r ../0_assemblies/NCBI/KX341962_Acanthogammarus_victorii_mitochondrion.gb -o 5

mitofinder -j Oal_D2 -a ../0_assemblies/new/Oal_D2_mf_mb_mtDNA_contig.fasta \
        -r ../0_assemblies/NCBI/KX341962_Acanthogammarus_victorii_mitochondrion.gb -o 5

mitofinder -j Ofl_D2 -a ../0_assemblies/new/Ofl_D2_mb_by_mf_mtDNA_contig.fasta \
        -r ../0_assemblies/NCBI/KX341962_Acanthogammarus_victorii_mitochondrion.gb -o 5

mitofinder -j Ome_D2 -a ../0_assemblies/new/Ocm_D2_mb_by_mf_mtDNA_contig.fasta \
        -r ../0_assemblies/NCBI/KX341962_Acanthogammarus_victorii_mitochondrion.gb -o 5

mitofinder -j Avi_KX341962 -a ../0_assemblies/NCBI/KX341962_Acanthogammarus_victorii_mitochondrion.fa \
        -r ../0_assemblies/NCBI/KX341962_Acanthogammarus_victorii_mitochondrion.gb -o 5

mitofinder -j Bgr_KP161875 -a ../0_assemblies/NCBI/KP161875_Brachyuropus_grewinkii_mitochondrion.fa \
        -r ../0_assemblies/NCBI/KX341962_Acanthogammarus_victorii_mitochondrion.gb -o 5

cd ./1_annotation/
cat */*Final_Results/*final_genes_NT.fasta >all_NT.fasta
grep \> all_NT.fasta

grep -A 1 ATP6 all_NT.fasta | grep -v -e "--" >ATP6.fasta
grep -A 1 ATP8 all_NT.fasta | grep -v -e "--" >ATP8.fasta
grep -A 1 COX1 all_NT.fasta | grep -v -e "--" >COX1.fasta
grep -A 1 COX2 all_NT.fasta | grep -v -e "--" >COX2.fasta
grep -A 1 COX3 all_NT.fasta | grep -v -e "--" >COX3.fasta
grep -A 1 CYTB all_NT.fasta | grep -v -e "--" >CYTB.fasta
grep -A 1 ND1 all_NT.fasta | grep -v -e "--" >ND1.fasta
grep -A 1 ND2 all_NT.fasta | grep -v -e "--" >ND2.fasta
grep -A 1 ND3 all_NT.fasta | grep -v -e "--" >ND3.fasta
grep -A 1 ND4$ all_NT.fasta | grep -v -e "--" >ND4.fasta
grep -A 1 ND4L all_NT.fasta | grep -v -e "--" >ND4L.fasta
grep -A 1 ND5 all_NT.fasta | grep -v -e "--" >ND5.fasta
grep -A 1 ND6 all_NT.fasta | grep -v -e "--" >ND6.fasta
grep -A 1 rrnL all_NT.fasta | grep -v -e "--" >ND6.fasta
grep -A 1 ND6 all_NT.fasta | grep -v -e "--" >ND6.fasta
grep -A 1 rrnL all_NT.fasta | grep -v -e "--" >rrnL.fasta
grep -A 1 rrnS all_NT.fasta | grep -v -e "--" >rrnS.fasta

grep -c \> *fasta

cd ../

ls

mv ./1_annotation/*fasta ./2_seq_by_gene/

mv ./2_seq_by_gene/all_NT.fasta ./1_annotation/

for fasta in ./2_seq_by_gene/*fasta; do prank -d=$fasta -o=$fasta.prank.aln -codon; done

for fasta in ./2_seq_by_gene/rrn*fasta; do prank -d=$fasta -o=$fasta.prank.aln +F; done

mkdir 3_algns/
ls

mv ./2_seq_by_gene/*best.fas ./3_algns/

for file in ./3_algns/*fas; do sed -e 's/\@.*//' $file>$file.renamed.fa; done

mkdir 4_prank_algns_renamed/
mv ./3_algns/*renamed.fa 4_prank_algns_renamed/

grep \> ./4_prank_algns_renamed/*

iqtree3 -p ./4_prank_algns_renamed/ -alrt 1000 -abayes -bb 1000 -pre untrimmed_prank_9sp

cat ./untrimmed_prank_9sp.iqtree

## removed B. grewingkii, it doesn't really help
(manually)
(probably update the code if it was not included in analysis from the beginning)


redo with mafft?
### 

for file in *fasta; do mafft --auto $file >$file.aln; done
drozdovapb@drozdovapb-HP-17-by1xxx:Ommx3_Evex3_Ecy_Avi_Gla$ for file in *aln; do trimal -in $file -out $file.trim.aln -automated1; done

iqtree3 -p trimmed/ -m TEST+MERGE -mset JC,HKY,TN93,GTR -bb 1000 -alrt 1000 -abayes -pre 9spwGla_mafft_trimmed
```



#### 45S rDNA

Analysis goal: assemble 45S rDNA loci from genomic data

Used GetOrganelle 1.7.4.1

(note to self: tried 18S P. lagowskii as a reference, didn't work out quite well)

```  
#installed config
/media/secondary/apps/GetOrganelle-1.7.4.1/Utilities/get_organelle_config.py -a fungus_nr
## this is the reference from the recently published Gammarus nekkensis genome sequence. from 18S to 28S
nano Gnek_scaf23_rDNA.fasta
/media/secondary/apps/GetOrganelle-1.7.4.1/get_organelle_from_reads.py -1 /media/main/genome/DNBSeq2023_proj617/result/SSP_617_WGS_Oal-D2/SSP_617_WGS_Oal-D2_trim_filt_1.fq.gz -2 /media/main/genome/DNBSeq2023_proj617/result/SSP_617_WGS_Oal-D2/SSP_617_WGS_Oal-D2_trim_filt_2.fq.gz -s Gnek_scaf23_rDNA.fasta -o Oal_Gnek -F fungus_nr
/media/secondary/apps/GetOrganelle-1.7.4.1/get_organelle_from_reads.py -1 /media/main/genome/DNBSeq2023_proj617/result/SSP_617_WGS_Ofl-D2/SSP_617_WGS_Ofl-D2_trim_filt_1.fq.gz -2 /media/main/genome/DNBSeq2023_proj617/result/SSP_617_WGS_Ofl-D2/SSP_617_WGS_Ofl-D2_trim_filt_2.fq.gz -s Gnek_scaf23_rDNA.fasta -o Ofl_Gnek -F fungus_nr
/media/secondary/apps/GetOrganelle-1.7.4.1/get_organelle_from_reads.py -1 /media/main/genome/DNBSeq2023_proj617/result/SSP_617_WGS_Ocm-D2/SSP_617_WGS_Ocm-D2_trim_filt_1.fq.gz -2 /media/main/genome/DNBSeq2023_proj617/result/SSP_617_WGS_Ocm-D2/SSP_617_WGS_Ocm-D2_trim_filt_2.fq.gz -s Gnek_scaf23_rDNA.fasta -o Ome_Gnek -F fungus_nr

ln -s /media/main/genome/Romanova_Sherbakov_HiSeq/Avict2.fq_1.gz Avict2_1.fq
ln -s /media/main/genome/Romanova_Sherbakov_HiSeq/Avict2.fq_2.gz Avict2_2.fq
/media/secondary/apps/GetOrganelle-1.7.4.1/get_organelle_from_reads.py -1 Avict2_1.fq -2 Avict2_2.fq -s Gnek_scaf23_rDNA.fasta -o Avi_Gnek -F fungus_nr
  543  head /media/main/genome/Romanova_Sherbakov_HiSeq/Evi.fq_1.gz 
  544  ln -s /media/main/genome/Romanova_Sherbakov_HiSeq/Evi.fq_1.gz Evi_1.fq
  545  ln -s /media/main/genome/Romanova_Sherbakov_HiSeq/Evi.fq_2.gz Evi_2.fq
  546  /media/secondary/apps/GetOrganelle-1.7.4.1/get_organelle_from_reads.py -1 Evi_1.fq -2 Evi_2.fq -s Gnek_scaf23_rDNA.fasta -o Evi_Gnek -F fungus_nr --overwrite
```
Then annotated with barrnap in Usegalaxy.eu; used 18S, 5.8S, and 28S. Extracted ITSs manually.
