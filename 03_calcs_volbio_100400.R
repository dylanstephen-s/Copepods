####################################################################
############# JOIN 100x AND 400X VOLUME AND BIOMASS#################
####################################################################

### This file has the volume and biomass calculations for all the
#  sampling events and includes all the organisms, including the ones
#  that have zero counts in sampling events other than the ones I
#  counted them in.
### To be used as a base data file for other calculations

### Below the main calculations are the same but with a data file
# that excludes the zero counts.

###

library(tidyverse)
library(writexl)
### Load the 100x and 400x volume/biomass data files. They were created in
##   03_calcs_biomass.R
load("data/volbio100.Rdata")
load("data/volbio400.Rdata")
### Join the two datasets by the sample column
volbio_all <- rbind(volbio100, volbio400)

names(volbio_all)
### Rename volume and biomass columns to include units
### Add a column that calculates biomass per volume:
# total biomass in pgC divided by volume, which is preservative factor,
# times volume of sample settled: tot_biomass_pgC/(pres_fact*vol_set_ml)
# and then rename it
### Convert pgC per mL to ugC per L
### Add a column that calculates counts per milliliter

volbio_all <- rename(volbio_all, tot_vol_um3 = volume, 
                     tot_biomass_pgC = biomass) %>% 
mutate(bio_per_vol = tot_biomass_pgC/(pres_fact*vol_set_ml)) %>% 
  rename(bio_per_vol_pgc_ml = bio_per_vol) %>% 
  mutate(bio_per_vol_ugl = bio_per_vol_pgc_ml/1000) %>% 
  mutate(counts_per_ml = counts/(pres_fact*vol_set_ml))

save(volbio_all, file = "data/volbio_all.Rdata")

################ NO ZEROS ###################
volbio_all_no0 <- rbind(volbio100_no0, volbio400_no0)

### Rename volume and biomass columns to include units
### Add a column that calculates biomass per volume:
# total biomass in pgC divided by volume, which is preservative factor,
# times volume of sample settled: tot_biomass_pgC/(pres_fact*vol_set_ml)
# and then rename it
### Convert pgC per mL to ugC per L
### Add a column that calculates counts per milliliter

volbio_all_no0 <- rename(volbio_all_no0, tot_vol_um3 = volume, 
                     tot_biomass_pgC = biomass) %>% 
  mutate(bio_per_vol = tot_biomass_pgC/(pres_fact*vol_set_ml)) %>% 
  rename(bio_per_vol_pgc_ml = bio_per_vol) %>% 
  mutate(bio_per_vol_ugl = bio_per_vol_pgc_ml/1000) %>% 
  mutate(counts_per_ml = counts/(pres_fact*vol_set_ml))

save(volbio_all_no0, file = "data/volbio_all_no0.Rdata")


