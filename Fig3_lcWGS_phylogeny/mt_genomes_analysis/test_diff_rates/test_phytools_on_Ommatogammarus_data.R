## https://blog.phytools.org/2024/02/testing-for-difference-in-rate-of.html

library(phytools)
packageVersion("phytools")

## salamander data as example, I just did not change the name
salamanders <- read.tree("../5_iqtree/9spwGla_mafft_trimmed.treefile")

plotTree(salamanders,direction="upwards",ftype="i")
nodelabels(frame="circle",cex=0.6)

## hypothesis for testing: rate of evolution in Eulimnogammarus #12 higher than in background
#mrca <- findMRCA(salamanders,c("Ecy_KX341964", "EveE_20181", "EveS_PB2", "EveW_KF690638"))
## or only Eve?
#mrca <- findMRCA(salamanders,c("EveE_20181", "EveS_PB2", "EveW_KF690638"))
## or the other way round, Omm vs everyone else?
mrca <- findMRCA(salamanders,c("Oal_D2", "Ofl_D2"))

x <- fastBM(salamanders)


## To fit a model in which the edge leading to node 37 is permitted to evolve 
## with a different rate than all the other edges of the tree, 
## we need to paint just that edge with a separate “regime.” 
## This is done most easily using the phytools function paintBranches as follows.

regime_tree<-paintBranches(salamanders, edge=mrca,
                           state="fast",anc.state="slow")
regime_tree

## did we get it right? yes
cols<-setNames(c("lightblue","darkred"),c("slow","fast"))
plot(regime_tree,cols,lwd=3,direction="upwards",ftype="i",
     split.vertical=TRUE)
nodelabels(frame="circle",cex=0.6)
legend("topright",names(cols),lwd=3,col=cols,bty="n")

## let's compare regimes!
brownie.lite(regime_tree,x)

## Eve vs. others: 0.03*
## in all other cases the same!
