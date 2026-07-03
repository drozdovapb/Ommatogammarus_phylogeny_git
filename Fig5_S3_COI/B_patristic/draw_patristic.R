## Packages used
# ## for networks (first row of panels)
# library(phangorn) ## required for tanggle to read networks
# library(tanggle) ## plot networks
# library(dplyr) ## for table rearrangement
# #library(ggpubr) ## to combine plots
# library(cowplot) ## kinda works better to combine plots
# library(ggrastr) ## to rasterize points and reduce svg size!
## for diversity metrics (second row of panels)
library(reshape2) ## for melt
library(matrixcalc) #triangular matrix for lower.triangle
library(ggplot2)

  ## read matrix and make it triangular
  table <- read.csv("omm.patristic.ed.csv", row.names = 1)
  table <- lower.triangle(as.matrix(table))
  print(max(table))
  ## put  back zeroes
  table[is.na(table)] <- 0
  table <- as.matrix(table)
  ## print max value for information
  print(max(table))
  ## melt to long format
  table_long <- melt(table)
  ## retain only meaningful values (no self-comparisons)
  table_long <- table_long[table_long$value > 0, ]
  ## get first and second letters
  table_long$first <- unlist(sapply(strsplit(x = as.character(table_long$Var1), split = "_"), FUN = function(x) {x[3]}))
  table_long$second <- unlist(sapply(strsplit(x = as.character(table_long$Var2), split = "_"), FUN = function(x) {x[3]}))
  print(head(table_long$first))
  ## group = biological species
  ## assembl labels for the x axis (two-line and SW == WS etc)
  table_long$group <- paste(substr(table_long$first, 1, 2), substr(table_long$second, 1, 2), sep = "\n")
  
  table_long$group[table_long$group == "fl\nal"] <- "al\nfl"
  table_long$group[table_long$group == "am\nal"] <- "al\nam"
  table_long$group[table_long$group == "me\nal"] <- "al\nme"
  table_long$group[table_long$group == "am\nfl"] <- "fl\nam"
  table_long$group[table_long$group == "me\nfl"] <- "fl\nme"
  table_long$group[table_long$group == "me\nam"] <- "am\nme"
  
  ## let's make sure we don't run the same comparisons twice
  print(paste("number of comparisons", nrow(table_long))) 
  ## get statistics
  message("min values")
  print(tapply(table_long$value, table_long$group, min))
  message("median values")
  print(tapply(table_long$value, table_long$group, median))
  message("max values")
  print(tapply(table_long$value, table_long$group, max))
  
  ## now to plotting
  ggplot(table_long, aes(x=group, y=value)) +
    #stat_summary(fun=median, geom="crossbar", linewidth=.25, color="blue") + 
    #geom_jitter(size=0.5, alpha=0.1, width=.25) + ## optinal: points
    ## decided on violins
    ## area proportional to # of observations and width to make larger
    geom_violin(fill = "grey", scale = "width") + ##maybe #, scale = "count") + 
    #geom_boxplot(box.color = "transparent", outlier.alpha = 0) + ## also boxplots possible
    expand_limits(y=c(0, 0.26)) + ## enforce equal limits
    #scale_x_discrete(limits = rev) + ## reverse x scales (W, S, E, C)
    scale_y_continuous(n.breaks=6) + ## enforce y axis ticks
    xlab("") + ylab("") + ## get rid of useless axis labels
    theme_bw(base_size = 14) + ## bigger fonts
    #theme(plot.title = element_text(hjust=0.5, size=14))  + ## center title
    geom_hline(yintercept = 0.16, linetype = "dashed", col="darkred") +
    theme(axis.text.x = element_text(face = "italic"))


## if using points might need to rasterize to get adequate file size
#myplot <- rasterize(myplot, layer = c("Jitter"), dpi=300)


ggsave("patrdist.svg", width=5, height=4, device=svg)

