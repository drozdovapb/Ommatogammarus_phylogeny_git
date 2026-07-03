library(ggplot2)
library(ggtree)
library(treeio)


## A mt tree
beast_tree <- read.beast("./final_trees/9spwGla_mafft_trimmed1-COX1.tree")
beast_tree@data$MRCAtextcolor <- ifelse(beast_tree@data$height > 1, "NA", "black")
ggtree(beast_tree) + geom_text(aes(label=node), col = "red") + geom_tiplab() + expand_limits(x=15)
tree1 <- ggtree(beast_tree) + theme_tree2()
tree1 <- revts(tree1)
#bigbayes <- ifelse(round(beast_tree@data$posterior, 1) == 1, "black", "#00000000")
beast_tree@data$posterior
## all posterior values = 1

mt_tree <- 
  tree1 + 
  geom_range("CAheight_0.95_HPD", color="darkgrey", size=4, alpha=.5) +  ## purple was #8b8ef8
#  geom_text2(aes(label=round(as.numeric(posterior), 5), 
#                 subset=as.numeric(posterior)> 0.7, 
#                 x=branch), vjust=0, hjust = 0, color = "red", size=10) + 
  scale_x_continuous(labels = abs, breaks = seq(-26, 0, 2)) + 
  expand_limits(x=6) + 
  scale_color_manual(values = c("NA", "black"), guide = 'none')  + 
  geom_text(aes(label = round(height, 1), color = MRCAtextcolor), nudge_x = -1, nudge_y = .15) + 
  geom_nodepoint(aes(fill = posterior > 0.9), group=1, pch=21, size=3) +
  geom_tiplab(align=FALSE, linetype='dashed', linesize=.3, size=4.45, fontface = "italic") + 
  theme(axis.text.x = element_text(size=12)) + xlab("mya")
mt_tree


### B rDNA as 5 fragments, bayesian

beast_tree <- read.beast("./final_trees/5sp_5genes_calibr28S_TRUE-28S.tree")
beast_tree@data$MRCAtextcolor <- ifelse(beast_tree@data$height > 1, "NA", "black")
ggtree(beast_tree) + geom_text(aes(label=node), col = "red") + geom_tiplab() + expand_limits(x=15)

posteriosrs <- beast_tree@data$posterior
#bigbayes <- ifelse(round(beast_tree@data$posterior, 1) == 1, "black", "#00000000")
beast_tree@data$posterior
#beast_tree@data$bigbayes <- beast_tree@data$posterior > .9
## we need to collapse node 7
library(ape)
di2multi(beast_tree, posterior = 0.9)
beast_tree_collapsed <- as.polytomy(as.phylo(beast_tree), 
                                    feature='posterior', fun=function(x) as.numeric(x) < 0.9)
tree1 <- ggtree(beast_tree) + theme_tree2()
tree1 <- revts(tree1)

rdna_tree <- 
  tree1 + 
  geom_range("CAheight_0.95_HPD", color="darkgrey", size=4, alpha=.5) +  ## purple was #8b8ef8
  scale_x_continuous(labels = abs, breaks = seq(-26, 0, 2)) + 
  expand_limits(x=2) + 
  scale_color_manual(values = c("NA", "black"), guide = 'none')  + 
  geom_nodepoint(aes(fill = posterior > 0.9), group=1, pch=21, size=3) +
  scale_fill_manual(values = c("white", "red4")) + 
  geom_text(aes(label = round(height, 1), color = MRCAtextcolor), nudge_x = -.5, nudge_y = .15) + 
  geom_tiplab(align=FALSE, linetype='dashed', linesize=.3, size=4.45, fontface = "italic") + 
  theme(axis.text.x = element_text(size=12)) + xlab("mya") + 
  theme(legend.position = "inside", legend.position.inside = c(.2, .8))
rdna_tree

svg("mrca_tree_4seqs.svg", width=12, height=6)
mrca_tree
dev.off()                    


## And ML trees as well
## C ML tree mt genomes

ml_tree <- read.tree("./final_trees/9spwGla_mafft_trimmed.treefile")

#label <- ml_tree$node.label
#alrt <- as.numeric(sapply(label, FUN = function(x) {unlist(strsplit(x, split="/"))[1]}))
#abayes <- as.numeric(sapply(label, FUN = function(x) unlist(strsplit(x, split="/"))[2]))
#bb <- as.numeric(sapply(label, FUN = function(x) unlist(strsplit(x, split="/"))[3]))
#supported_nodes <- alrt > 95 & abayes > .9 & bb > 95
#ml_tree$node.label <- supported_nodes

ggtree(ml_tree) + 
  geom_tiplab() + 
  expand_limits(x=.9) + 
  geom_treescale(width = .1, x = .75, y=8) + 
  geom_nodelab() -> ml_tree_mt
ml_tree_mt

## AND D, nr tree ML
ml_tree <- read.tree("./final_trees/5sp_rDNA.treefile")

ggtree(ml_tree) + 
  geom_tiplab() + 
#  expand_limits(x=.3) + 
  geom_treescale(x = .001, y=5, width=0.01, offset = .1) + 
  geom_nodelab() -> ml_tree_nr
ml_tree_nr

library(ggpubr)
ggarrange(mt_tree, rdna_tree, ml_tree_mt, ml_tree_nr, widths = c(2, 1, 2, 1),
          labels=LETTERS[1:4], )
ggsave("trees.svg", device=svg, width = 12, height=8)
