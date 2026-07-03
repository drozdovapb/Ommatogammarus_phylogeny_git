library(ggtree)
library(ggplot2)

tree <- read.tree("al_fl_am_me_BK_trim753_woutgroups.fa.treefile")


label <- tree$node.label
alrt <- as.numeric(sapply(label, FUN = function(x) {unlist(strsplit(x, split="/"))[1]}))
abayes <- as.numeric(sapply(label, FUN = function(x) unlist(strsplit(x, split="/"))[2]))
tree$bb <- as.numeric(sapply(label, FUN = function(x) unlist(strsplit(x, split="/"))[3]))
bb <- as.numeric(sapply(label, FUN = function(x) unlist(strsplit(x, split="/"))[3]))
tree$supported_nodes <- alrt > 70 & abayes > .7 & bb > 70
tree$unsupported_nodes <- alrt < 70 & abayes < .7 & bb < 70


#ggtree(tree) + 
#  geom_tiplab(size=1) +
#  geom_nodelab(size=2, nudge_x = -.01, nudge_y = 1, color="red4") + 
#  geom_treescale(x = 0, y=50, fontsize = 3)

#tree$node.label

#tree_collapsed <- as.polytomy(tree, feature='bb', fun=function(x) {x < 70})

#ggtree(tree_collapsed) + 
#  geom_tiplab(size=1) +
#  geom_nodelab(size=2, nudge_x = -.01, nudge_y = 1, color="red4") + 
#  geom_treescale(x = 0, y=50, fontsize = 3)

## do not draw unsupported nodes
tree$node.label[which(tree$unsupported_nodes)] <- NA

tree$node.color <- rep("grey50", length(tree$tip.label))
tree$node.color[grep("albinus", tree$tip.label)] <- "beige"
tree$node.color[grep("flavus", tree$tip.label)] <- "#FFA500"
tree$node.color[grep("amethystinus", tree$tip.label)] <- "violetred"
tree$node.color[grep("melanophthalmus", tree$tip.label)] <- "#FF6600"


ggtree(tree) + 
  geom_tiplab(size=2.5) +
  geom_nodelab(size=1.5, nudge_x = -.01, nudge_y = 1, color="red4") + 
  geom_tippoint(fill=tree$node.color, shape=21, size=2) + 
  geom_treescale(x = 0, y=50, fontsize = 3) + 
  expand_limits(x=.6) + 
  annotate(geom = "point", x = 0, y=90, fill="beige", shape=21, size=2) + 
  annotate(geom = "text", x = 0.03, y=90, label="albinus", fontface="italic", hjust=0) +
  annotate(geom = "point", x = 0, y=88, fill="#FFA500", shape=21, size=2) + 
  annotate(geom = "text", x = 0.03, y=88, label="flavus", fontface="italic", hjust=0) +
  annotate(geom = "point", x = 0, y=86, fill="violetred", shape=21, size=2) + 
  annotate(geom = "text", x = 0.03, y=86, label="amethystinus", fontface="italic", hjust=0) +
  annotate(geom = "point", x = 0, y=84, fill="#FF6600", shape=21, size=2) + 
  annotate(geom = "text", x = 0.03, y=84, label="melanophthalmus", fontface="italic", hjust=0) + 
  annotate(geom = "point", x = 0, y=82, fill="grey50", shape=21, size=2) + 
  annotate(geom = "text", x = 0.03, y=82, label="Outgroups", hjust=0)

  

#ggsave(filename = "COI_tree.svg", width=20, height=20, units="cm", device=svg)
ggsave(filename = "FigS3_COI_tree.png", width=20, height=25, units="cm", device=png)
