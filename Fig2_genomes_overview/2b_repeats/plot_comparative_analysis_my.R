read_counts = "./COMPARATIVE_ANALYSIS_COUNTS_Omm.csv"
#cluster_annotation = "./CLUSTER_TABLE_Omm_annot_more5000.csv"
#cluster_annotation = "./CLUSTER_TABLE_Omm_annot.csv"
cluster_annotation = "./CLUSTER_TABLE_Omm_annot_more1500.csv"

#output = "./just_testing_script.pdf"
output = "./just_testing_script.svg"
GS = read.table("./GS_Omm.txt", header=FALSE, as.is=TRUE, row.names = 1)
nuclear_only = T

  ## read_counts : correspond to COMPARATIVE_ANALYSIS_COUNTS.csv
  ## cluster annotation : CLUSTER_TABLE.csv
  counts = read.table(read_counts,header=TRUE,as.is=TRUE)
  names(counts) <- c("Cluster", "Supercluster", "me", "al", "fl")
    
  input_read_counts = unlist(read.table(read_counts, nrows = 1, comment.char = "",sep="\t")[-(1:2)])
  
  counts_file_valid = ncol(counts) == (length(input_read_counts) + 2) & all(colnames(input_read_counts)[1:2]==c("cluster", "supercluster"))
  ## find which line is header
  header_line = grep(".*Cluster.*Supercluster.*Size", readLines(cluster_annotation))
  annot = read.table(cluster_annotation, sep="\t",header=TRUE,as.is=TRUE, skip = header_line - 1)
  ## validate
  all(colnames(annot)==c("Cluster","Supercluster","Size","Size_adjusted","Automatic_annotation","TAREAN_annotation","Final_annotation"))

  #counts$me <- counts$me#/5e5*100 #5.1e9
  #counts$al <- counts$al#/5e5*100 #5.4e9
  #counts$fl <- counts$fl#/5e5*100 #6.2e9
  
  #sum(counts$al)*5.4/0.5
  #sum(counts$fl)*6.2
  #sum(counts$me)*5.1
  
  mergedcounts <- merge(counts, annot)  

  library(dplyr)  
  library(reshape2)

  merged.counts.melt <- melt(mergedcounts[, c("Cluster", "al", "fl", "me", "Final_annotation")],
                             id.vars = c("Cluster", "Final_annotation"),
                             variable.name = "Species", value.name="Number of reads")    
  merged.counts.melt$Percent.reads <- merged.counts.melt$`Number of reads`/5e5*100

  library(ggplot2)  
  #ggplot(merged.counts.melt, aes(x=factor(Cluster), y=n, fill=Final_annotation, col=Species)) +
  #  geom_bar(stat = "identity", position = "dodge")

  
#  palette.colors(n=36, palette="Polychrome36")
# "#5A5156" "#E4E1E3" "#F6222E" "#FE00FA" "#16FF32" "#3283FE" "#FEAF16" "#B00068" "#1CFFCE" "#90AD1C" "#2ED9FF" "#DEA0FD"
# "#AA0DFE" "#F8A19F" "#325A9B" "#C4451C" "#1C8356" "#85660D" "#B10DA1" "#FBE426" "#1CBE4F" "#FA0087" "#FC1CBF" "#F7E1A0"
# "#C075A6" "#782AB6" "#AAF400" "#BDCDFF" "#822E1C" "#B5EFB5" "#7ED7D1" "#1C7F93" "#D85FF7" "#683B79" "#66B0FF" "#3B00FB"
  
  ggplot(merged.counts.melt, aes(x=Species, y=Percent.reads, fill=Final_annotation)) +
    geom_bar(stat = "identity", position = position_stack(reverse=TRUE), col="grey10", linewidth = .1) +
    scale_fill_manual(values = c("#CC79A7", # pink for rDNA
                                 "#56B4E9", "#3283FE", "#325A9B", "#3B00FB", #blues for Class I
                                 "#C4451C", # red for satellites
                                 "#FEAF16")) +  # and orange for other
    theme_bw(base_size=14) + 
    theme(axis.text.x = element_text(face = "italic"))


  ggsave("repeats_draft.svg", width=7, height=6, device=svg)  
  