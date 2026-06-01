## Analysis of mitochondrial genomes

Mt genome assembly (??and annotation??) was performed for the three species using the same pipeline but is shown for _O. albinus_ as an example.

# Dependencies
  * bbtools v...
  * MitoFinder
  * MitoBIM

# Genome assembly

All calculations were performed on a laptop (...CHARACTERISTICS...).

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
mitofinder -a iteration11/Oal_D2-Oal_D2_mf-it11_noIUPAC.fasta -r ../../refs/KX341964_Ecy_mt_complete_genome.gb -o 5 -j Oal_D2_mf_mb
```

Now circular!
    ```
    Evidences of circularization were found!
    Sequence is going to be trimmed according to circularization position. 
    <...>
    Note: 
    15 genes were found in mtDNA_contig
    ```

Note: now the sequence is trimmed, and if annotation is run one more time, MitoFinder does not find evidence of circularization.
