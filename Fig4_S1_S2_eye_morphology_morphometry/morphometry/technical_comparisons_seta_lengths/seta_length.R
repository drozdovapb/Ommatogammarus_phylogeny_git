library(ggplot2)
library(openxlsx)
library(ggbeeswarm)

Ocmdat <- read.xlsx("Seta_length.xlsx")
Ocmdat$Body.part <- factor(Ocmdat$Body.part)
Ocmdat$Method <- factor(Ocmdat$Method)
Ocmdat$Magnification <- factor(Ocmdat$Magnification)
summary(Ocmdat)

## antennae II only data set
Ocmdat_a <- Ocmdat[Ocmdat$Body.part == "antenna II", ]

## compare devices
methods.tbl <- table(Ocmdat_a$Animal, Ocmdat_a$Method)
animals.tocompare <- row.names(methods.tbl[rowSums(methods.tbl > 0) > 1, ])

ggplot(data = Ocmdat_a[Ocmdat_a$Animal %in% animals.tocompare, ], 
       mapping = aes(x=Animal, y=`Length,.mm`, color=Method)) + 
  geom_boxplot(outlier.alpha = 0) + 
  geom_jitter(position = position_jitterdodge(), aes(shape=Magnification)) + 
  theme_bw() + 
  scale_shape_discrete(na.value = 3) + 
  ggtitle("Compare different microscopes / cameras by antenna II seta lengths")
ggsave("compare_microscopes.png", width=20, height=10, device=png, units = "cm")
  

## compare body parts
bodyparts.tbl <- table(Ocmdat$Animal, Ocmdat$Body.part)
animals.tocompare <- row.names(bodyparts.tbl[rowSums(bodyparts.tbl > 0) > 1, ])

ggplot(data = Ocmdat[Ocmdat$Animal %in% animals.tocompare, ], 
       mapping = aes(x=Animal, y=`Length,.mm`, color=Body.part)) + 
  geom_boxplot(outlier.alpha = 0) + 
  geom_jitter(position = position_jitterdodge()) + 
  theme_bw() + 
  ggtitle("Compare different body parts")
ggsave("compare_body_parts.png", width=20, height=10, device=png, units = "cm")


## and main figure with antenna II 
ggplot(data = Ocmdat_a, mapping = aes(x=Animal, y=`Length,.mm`)) + 
#  geom_violin() + 
  geom_boxplot() + 
  geom_jitter(position = position_jitterdodge(), aes(color=`Species.(Takhteev)`)) + 
  theme_bw() + 
  theme(axis.text.x = element_text(angle = 90))
  ggtitle("Antenna II seta lengths")
ggsave("antenna.png", width=20, height=10, device=png, units = "cm")


Ocmdat_a$Species <- NA
Ocmdat_a$Species[Ocmdat_a$`Species.(Takhteev)`=="Occ"] <- "ca_T"
Ocmdat_a$Species[Ocmdat_a$`Species.(Takhteev)`=="Oca"] <- "am_T"
# no O. albinus
Ocmdat_a <- Ocmdat_a[!(Ocmdat_a$Animal %in% "23_8"), ]
# melanophthalmus
#Ocmdat_a[Ocmdat_a$Animal %in% 
#        c("21_8", "23_3", "23_4", "23_10", "23_11", "23_14"), "Species"] <-  "me"


ggplot(data = Ocmdat_a, mapping = aes(x=Animal, y=`Length,.mm`)) + 
  #  geom_violin() + 
  geom_boxplot() + 
  geom_jitter(position = position_jitterdodge(), aes(color=Species), size=1) + 
  theme_bw(base_size = 14) + 
  theme(axis.text.x = element_text(angle = 90)) + 
  scale_color_manual(values = c("purple", "pink", "brown")) + 
  ggtitle("Antenna II seta lengths") + 
  theme(legend.position = "bottom")
ggsave("antenna_wsp.png", width=20, height=12, device=png, units = "cm")


boxplot(Ocmdat_a$`Length,.mm` ~ Ocmdat$Animal)
