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
Then annotated with barrnap in Usegalaxy.eu (thanks!!!)
