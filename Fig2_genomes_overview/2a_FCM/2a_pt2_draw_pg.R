## This script plots the table obtained in the previous analysis
library(ggplot2)
library(ggpubr)

res2 <- read.csv("Ommatogammarus_2025.csv")

# in case some did not contain standard by mistake
res2$pg <- res2$b_mean / res2$a_mean * res2$StdSize

res2 <- res2[complete.cases(res2$pg), ]

res2$Species <- NA
res2$Species[grep("Oa", res2$X)] <- "al"
res2$Species[grep("Of", res2$X)] <- "fl"
res2$Species[grep("Ocm", res2$X)] <- "me"


res_filtered <- res2[res2$a_CV < 0.1 & res2$b_CV < 0.1 & res2$RCS < 4, ]
res_filtered <- res_filtered[complete.cases(res_filtered$Species), ]

ggplot(res_filtered, aes(Species, pg)) + 
  geom_boxplot(outlier.alpha = 0) + 
  geom_jitter(width = 0.1) + 
  expand_limits(y=c(0, 8)) + 
  theme_bw(base_size = 16) + 
  ylab("Genome size, pg") + 
  theme(axis.text.x = element_text(face = "italic")) + 
  ggpubr::geom_pwc(method="wilcox_test", # p.adjust.method = "none", for comparison
                   label="p.adj")

ggsave(filename = "FCM_Ommatogammarus.png", device=png, width=5, height=6)
ggsave(filename = "FCM_Ommatogammarus.svg", device=svg, width=5, height=6)

pairwise.wilcox.test(res_filtered$pg, res_filtered$Species)

median(res_filtered[res_filtered$Species == "al", "pg"])
median(res_filtered[res_filtered$Species == "fl", "pg"])
median(res_filtered[res_filtered$Species == "me", "pg"])
