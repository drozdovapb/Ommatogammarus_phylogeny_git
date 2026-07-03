## fig s4: let's compare lengths

library(openxlsx)
library(ggplot2)
library(ggpubr)

body_lengths <- read.xlsx("Body_lengths.xlsx")

ggplot(body_lengths, aes(x=Species, y=Body.length)) + 
  geom_violin() + 
  geom_jitter() + 
  theme_bw() + 
  geom_pwc()

ggsave("body_lengths.png")