library(pegas)

al <- read.dna('al_753.fa', format = 'fasta')
nuc.div(al)
hap.div(al)

fl <- read.dna('fl_753.fa', format='fasta')
nuc.div(fl)
hap.div(fl)

me <- read.dna('me_753.fa', format='fasta')
nuc.div(me)
hap.div(me)

am <- read.dna('am_753.fa', format='fasta')
nuc.div(am)
hap.div(me)
