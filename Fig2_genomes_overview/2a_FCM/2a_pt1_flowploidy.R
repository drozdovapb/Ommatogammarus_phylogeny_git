library(flowPloidy)
#library(flowPloidyData)
library(flowCore)
library(ggplot2)
library(ggpubr)

## let's try with our example data
ex_filenames <- list.files(path="./0_raw_data/", full.names = TRUE)
viewFlowChannels(ex_filenames[1], truncate_max_range = FALSE)

#browseFlowHist(batch2)
# read data AND set size standard simultaneously
batch2 <- batchFlowHist(ex_filenames, channel = "BL2.H", truncate_max_range = FALSE, standards = 1.18) 

batch2 <- browseFlowHist(batch2)


res2 <- tabulateFlowHist(batch2)
write.csv(res2, "Ommatogammarus_2025.csv", row.names = TRUE)
