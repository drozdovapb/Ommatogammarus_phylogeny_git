library(openxlsx)
library(ggfortify)
library(ggplot2)
library(ggbeeswarm)
library(ggeasy)
#install.packages("see")
library(see)

Oc <- read.xlsx("Morphometry.xlsx", sheet = "S2. Morphometry")
## hyacinthinus is not from here
Oc <- Oc[Oc$ID != "Ohy_25", ]

## Calculate coefficients
Oc$eye_narrow <- Oc$Eye.width / Oc$Eye.height
Oc$eye_relat_size <- Oc$Eye.S / Oc$Head.S
Oc$ant_to_body <- Oc$Antenna.1.length / Oc$Body.length
Oc$ant_ratio <- Oc$Antenna.1.length / Oc$Antenna.2.length
#Oc$eye_shape_geom <-  Oc$`Lower.eye.half.area,.px` / Oc$`Upper.eye.half.area,.px`
Oc$eye_shape_ant <- Oc$`sub-antennal.eye.half.area,.px` / Oc$`super-antennae.eye.half.area,.px`

## a small function to plot morphological variables


morphoPlot <- function(coefficient, ylab="YLAB HERE", ggtitle="GGTITLE HERE") {
  ggplot(Oc, aes(y={{coefficient}}, x=1)) +
#    geom_violin() + 
    see::geom_violinhalf(color="grey90", fill="grey90") + 
#    geom_beeswarm(cex=4, aes(color=Collection)) + 
    xlab("") + ylab(ylab) + ggtitle(ggtitle) + 
    theme_bw(base_size = 14) + 
    theme(plot.title = element_text(hjust = 0.5)) + 
    easy_remove_y_axis() + 
    coord_flip()
}

dotsize <- 4

## eye size
pEyeSize <- 
  morphoPlot(eye_relat_size, ylab="Eye area / head area", ggtitle="Relative eye size") + 
  geom_beeswarm(cex=5, aes(color=Collection), side=1, size=dotsize, method = "compactswarm") + 
  scale_color_manual(values = c("purple4", "pink3", "grey50", "purple", "pink"))
pEyeSize

### length of body and antennae

pAnt2Body <- 
  morphoPlot(ant_to_body, ylab="Antenna I / body", ggtitle="Relative antenna I length") +
  geom_beeswarm(cex=5, aes(color=Collection, shape=Collection), side=1, size=dotsize, method = "compactswarm") + 
  scale_shape_manual(values=c(18, 18, 16, 16, 16, 16)) + 
  scale_color_manual(values = c("purple", "pink", "grey50", "purple", "pink")) + 
  geom_hline(yintercept = c(0.33, 0.5, 1), linetype = "dotted")
pAnt2Body

pAntRatio <- 
  morphoPlot(ant_ratio, ylab="Antenna I / Antenna II", ggtitle="Relative antennae length") +
  geom_beeswarm(cex=5, aes(color=Collection, shape=Collection), side=1, size=dotsize, method = "compactswarm") + 
  scale_color_manual(values = c("purple", "pink", "grey50", "purple", "pink")) + 
  scale_shape_manual(values=c(18, 18, 16, 16, 16, 16)) + 
  geom_hline(yintercept = c(2), linetype = "dotted")
pAntRatio

pSetaeLength <- 
  morphoPlot(Length.of.setae.on.antenna.2.med, ylab="Median length, mm", ggtitle="Antenna II setae") + 
  geom_beeswarm(cex=6, aes(color=Collection), side=1, size=dotsize, method = "compactswarm") + 
  scale_color_manual(values = c("purple4", "pink3", "grey50", "purple", "pink")) 
pSetaeLength

Oc$ExR <- 1.4*Oc$R - Oc$G
pEyeColor <- 
  morphoPlot(ExR, ylab="Excess red index", ggtitle="Eye color") +
  geom_beeswarm(cex=6, method = "compactswarm", aes(col=Eye.color), side=1, size=dotsize) +  
  scale_color_identity() 
pEyeColor

pEyeShape <- 
  morphoPlot(eye_shape_ant, ylab = "Subantennal/superantennal area ratio", ggtitle = "Eye shape") + 
  geom_beeswarm(cex=6, method = "compactswarm", aes(col=Eye.color), side=1, size=dotsize) + 
  scale_color_identity()
pEyeShape

library(ggpubr)
#p.empty <- ggplot() + theme_minimal() ## didn't need it finally

ggarrange(pEyeColor, pEyeShape, pEyeSize, #first row = eyes
          pAnt2Body, pAntRatio, pSetaeLength, #second row = antennae
          common.legend=TRUE, legend = "bottom", labels = c("A", "B", "C", "D", "E", "F"))
ggsave("Fig_traits.png", device=png, width=12, height=8, bg = "white")
ggsave("Fig_traits.svg", device=svg, width=12, height=8, bg = "white")

library(ggrepel)
Oc_eg <- Oc[Oc$ID %in% c("Ocsp_23_6", "Ocsp_23_7"), ]
pEyeColor + geom_text(data = Oc_eg, aes(label=ID))
pSetaeLength + geom_text(data = Oc_eg, aes(label=ID))
pEyeShape + geom_text(data = Oc_eg, aes(label=ID))


## for labelling
View(Oc[,c("ID", "ExR", "eye_shape_ant", "eye_relat_size", 
           "ant_ratio", "ant_to_body", "Length.of.setae.on.antenna.2.med")])

#######################
# autoplot(pca_res, data=Oc_complete, color="Morphospecies", label=TRUE)

# ggplot(Oc, aes(x=group, y=ant_to_body)) + 
#   geom_beeswarm(cex=2) + 
#   expand_limits(y=c(0, 1)) + 
#   geom_hline(yintercept = c(0.33, 0.5, 1), linetype = "dotted") + 
#   #geom_beeswarm(data=Oc_T, cex=2, aes(color=Morphospecies)) + 
#   #scale_color_manual(values = c("purple", "pink")) + 
#   ylab("Antenna I / body") + 
#   theme_bw(base_size = 14) + 
#   easy_remove_x_axis() + 
#   theme(legend.position = "bottom")
# 
# ggplot(Oc, aes(x=group, y=ant_ratio)) + 
#   geom_beeswarm(cex=2) + 
#   geom_hline(yintercept = c(2), linetype = "dotted") + 
#   #geom_beeswarm(data=Oc_T, cex=2, aes(color=Morphospecies)) + 
#   #scale_color_manual(values = c("purple", "pink")) + 
#   ylab("Antenna I / antenna II") + 
#   theme_bw(base_size = 14) + 
#   easy_remove_x_axis() + 
#   theme(legend.position = "bottom")
# 
# 
# ggplot(Oc, aes(x=group, y=Length.of.setae.on.antenna.2.med)) + 
#   geom_beeswarm(cex=2.5) + 
#   geom_beeswarm(data=Oc_T, cex=2, aes(color=Morphospecies)) + 
#   expand_limits(y=c(0, 0.5)) + 
#   scale_color_manual(values = c("purple", "pink")) + 
#   ylab("Median seta length \n on antenna II, mm") + 
#   theme_bw(base_size = 14) + 
#   easy_remove_x_axis() + 
#   theme(legend.position = "bottom")
# 
# 
# 
# ggplot(Oc, aes(x=COI, y=log(`R*mean(G,B)`), col=Eye.color)) + 
#   geom_beeswarm(cex=2) +
#   ylab("log(2*R/(G+B)") + 
#   theme_bw(base_size = 14) + 
#   scale_color_identity() + 
#   theme(legend.position = "bottom")
# 
# ggplot(Oc, aes(x=group, y=eye_relat_size, col=COI)) + 
#   geom_beeswarm(cex=3) + 
#   scale_color_manual(values = c("violetred", "orange")) + 
#   ylab("Relative eye size") + 
#   theme_bw(base_size = 14) + 
#   easy_remove_x_axis() + 
#   theme(legend.position = "bottom")
# 
# ggplot(Oc, aes(x=group, y=ant_to_body, col=COI)) + 
#   geom_beeswarm(cex=3) + 
#   scale_color_manual(values = c("violetred", "orange")) + 
#   ylab("Antenna I / Body") + 
#   theme_bw(base_size = 14) + 
#   easy_remove_x_axis() + 
#   theme(legend.position = "bottom")
# 
# 
# ggplot(Oc, aes(x=group, y=ant_ratio, col=COI)) + 
#   geom_beeswarm(cex=3) + 
#   scale_color_manual(values = c("violetred", "orange")) + 
#   ylab("Antenna I / Antenna II lengths") + 
#   theme_bw(base_size = 14) + 
#   easy_remove_x_axis() + 
#   theme(legend.position = "bottom")
# 
# ggplot(Oc, aes(x=group, y=Length.of.setae.on.antenna.2.med, col=COI)) + 
#   geom_beeswarm(cex=3) + 
#   expand_limits(y=c(0, 0.5)) + 
#   scale_color_manual(values = c("violetred", "grey", "orange")) + 
#   ylab("Median seta length \n on antenna II, mm") + 
#   theme_bw(base_size = 14) + 
#   easy_remove_x_axis() + 
#   theme(legend.position = "bottom")
################


##PCA ##TODO FINISH

names(Oc)
Oc_n <- Oc[, c("ExR", "eye_relat_size", "eye_shape_ant", "ant_to_body", "ant_ratio"), ]
Oc_complete <- Oc[complete.cases(Oc_n), ]
Oc_n <- Oc_n[complete.cases(Oc_n), ]
pca_res <- prcomp(Oc_n, scale. = TRUE)
row.names(Oc_complete) <- Oc_complete$ID
autoplot(pca_res, data=Oc_complete, color="COI", label=TRUE)


# names(Oc)
# Oc_n <- Oc[, c("ExR", "eye_shape_ant"), ]
# Oc_complete <- Oc[complete.cases(Oc_n), ]
# Oc_n <- Oc_n[complete.cases(Oc_n), ]
# pca_res <- prcomp(Oc_n, scale. = TRUE)
# row.names(Oc_complete) <- Oc_complete$ID
# autoplot(pca_res, data=Oc_complete, color="COI", label=TRUE)

### NOW AFTER CYTOCHROME OXIDASE SUBUNIT I SEQUENCING

## let's start anew and return hyacinthinus!
Oc <- read.xlsx("Morphology of Ommatogammarus.xlsx", sheet = "Morphometry")
## Calculate coefficients
Oc$ExR <- 1.4*Oc$R - Oc$G
Oc$eye_shape_ant <- Oc$`sub-antennal.eye.half.area,.px` / Oc$`super-antennae.eye.half.area,.px`
Oc$eye_narrow <- Oc$Eye.width / Oc$Eye.height
Oc$eye_relat_size <- Oc$Eye.S / Oc$Head.S
Oc$ant_to_body <- Oc$Antenna.1.length / Oc$Body.length
Oc$ant_ratio <- Oc$Antenna.1.length / Oc$Antenna.2.length
#Oc$eye_shape_geom <-  Oc$`Lower.eye.half.area,.px` / Oc$`Upper.eye.half.area,.px`
Oc$eye_shape_ant <- Oc$`sub-antennal.eye.half.area,.px` / Oc$`super-antennae.eye.half.area,.px`


Oc <- Oc[complete.cases(Oc$COI),]

## eye size
pEyeSizeAfter <- 
  morphoPlot(eye_relat_size, ylab="Eye area / head area", ggtitle="Relative eye size") + 
  geom_beeswarm(cex=5, aes(color=COI), side=1, size=dotsize, method = "compactswarm") + 
  scale_color_manual(values = c("violetred", "#FF6600", "grey"))
pEyeSizeAfter

### length of body and antennae
pAnt2BodyAFter <- 
  morphoPlot(ant_to_body, ylab="Antenna I / body", ggtitle="Relative antenna I length") +
  geom_beeswarm(cex=5, aes(color=COI), side=1, size=dotsize, method = "compactswarm") + 
  scale_color_manual(values = c("violetred", "#FF6600", "grey")) +
  geom_hline(yintercept = c(0.33, 0.5, 1), linetype = "dotted")
pAnt2BodyAFter

pAntRatioAfter <- 
  morphoPlot(ant_ratio, ylab="Antenna I / Antenna II", ggtitle="Relative antennae length") +
  geom_beeswarm(cex=5, aes(color=COI), side=1, size=dotsize, method = "compactswarm") + 
  scale_color_manual(values = c("violetred", "#FF6600", "grey")) +
  geom_hline(yintercept = c(2), linetype = "dotted")
pAntRatioAfter

pSetaeLengthAfter <- 
  morphoPlot(Length.of.setae.on.antenna.2.med, ylab="Median length, mm", ggtitle="Antenna II setae") + 
  geom_beeswarm(cex=5, aes(color=COI), side=1, size=dotsize, method = "compactswarm") + 
  scale_color_manual(values = c("violetred", "#FF6600", "grey"))
pSetaeLengthAfter

pEyeColorAfter <- 
  morphoPlot(ExR, ylab="Excess red index", ggtitle="Eye color") +
  geom_beeswarm(cex=5, aes(color=COI), side=1, size=dotsize, method = "compactswarm") + 
  scale_color_manual(values = c("violetred", "#FF6600", "grey"))
pEyeColorAfter

pEyeShapeAfter <- 
  morphoPlot(eye_shape_ant, ylab = "Subantennal/superantennal area ratio", ggtitle = "Eye shape") + 
  geom_beeswarm(cex=5, aes(color=COI), side=1, size=dotsize, method = "compactswarm") + 
  scale_color_manual(values = c("violetred", "#FF6600", "grey"))
pEyeShapeAfter


ggarrange(pEyeColorAfter, pEyeShapeAfter, pEyeSizeAfter, #first row = eyes
          pAnt2BodyAFter, pAntRatioAfter, pSetaeLengthAfter, #second row = antennae
          common.legend=TRUE, legend = "bottom", labels = c("A", "B", "C", "D", "E", "F"))
ggsave("Fig_traits_updCOI.png", device=png, width=12, height=8, bg="white")
ggsave("Fig_traits_updCOI.svg", device=svg, width=12, height=8, bg="white")



# ## PCA / after
# 
# names(Oc)
# Oc_n <- Oc[, c("ExR", "eye_relat_size", "eye_shape_ant", "ant_to_body", "ant_ratio"), ]
# Oc_complete <- Oc[complete.cases(Oc_n), ]
# Oc_n <- Oc_n[complete.cases(Oc_n), ]
# pca_res <- prcomp(Oc_n, scale. = TRUE)
# row.names(Oc_complete) <- Oc_complete$ID
# autoplot(pca_res, data=Oc_complete, color="COI", label=TRUE)
# 
# names(Oc)
# Oc_n <- Oc[, c("ExR", "eye_shape_ant"), ]
# Oc_complete <- Oc[complete.cases(Oc_n), ]
# Oc_n <- Oc_n[complete.cases(Oc_n), ]
# pca_res <- prcomp(Oc_n, scale. = TRUE)
# row.names(Oc_complete) <- Oc_complete$ID
# autoplot(pca_res, data=Oc_complete, color="COI", label=TRUE)
# 


ggplot(Oc, aes(x=ExR, y=eye_shape_ant)) + 
  geom_point(aes(color=COI)) + 
  scale_color_manual(values = c("violetred", "#FF6600", "grey")) +
  ylab("Eye shape") + xlab("Eye color") + 
  theme_bw(base_size = 14) + 
  theme(legend.position =  "inside", legend.position.inside = c(.9, .8))
ggsave("eyes_upd_COI.svg", width=4, height=4, device=svg)  

