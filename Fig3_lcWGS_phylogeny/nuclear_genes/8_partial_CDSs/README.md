8 nuclear genes
(not used in the final phylogeny at Fig. 3)

G. nekkensis genes from Hou et al. 2022 paper => alignment of raw reads from Ommatogammarus & A. victorii to them

Example code and result:

```{bash}
bowtie2 -x Gne_seqs -1 /media/main/genome/DNBSeq2023_proj617/result/SSP_617_WGS_Oal-D2/SSP_617_WGS_Oal-D2_trim_filt_1.fq.gz -2 /media/main/genome/DNBSeq2023_proj617/result/SSP_617_WGS_Oal-D2/SSP_617_WGS_Oal-D2_trim_filt_2.fq.gz -p 6 -S Oal_2_8Gne.sam

37963036 reads; of these:
  37963036 (100.00%) were paired; of these:
	37962714 (100.00%) aligned concordantly 0 times
	322 (0.00%) aligned concordantly exactly 1 time
	0 (0.00%) aligned concordantly >1 times
	----
	37962714 pairs aligned concordantly 0 times; of these:
	  10 (0.00%) aligned discordantly 1 time
	----
	37962704 pairs aligned 0 times concordantly or discordantly; of these:
	  75925408 mates make up the pairs; of these:
		75925204 (100.00%) aligned 0 times
		204 (0.00%) aligned exactly 1 time
		0 (0.00%) aligned >1 times
0.00% overall alignment rate

```

322 read pairs x 300 nt ~ 90,000 bases
reference <5000 bases 
that's even >3x

=> bam => sorted bam with `samtools view` => UGENE to take a look and export coverage & consensus.

Basically, H3 worked out great because it's multicopy (see the 'coverage' folder). The others were less covered (1-2-3x), as completely expected. 
H3 was 100% identical in the three _Ommatogammarus_ species, so it was not used in the final phylogeny.