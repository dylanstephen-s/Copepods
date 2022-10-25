####################################################################
################## 100x AND 400X VOLUME AND BIOMASS#################
####################################################################

### Uses data files raw100_final and raw400_final separately to calculate
# volume and biomass. 

### Also includes a separate data frame that excludes
#  zero count organisms
library(tidyverse)
library(writexl)

### Load the volume and biomass functions
source("scripts/01_function_volume.R")
source("scripts/01_function_biomass.R")

################ FOR 100X ################
### Load the raw counts data
load("data/raw100_final.Rdata")
### Run the volume function
# Also, add a column that calculates the volume per organism,
# and rename the volume column to include units of micrograms cubed.
vol100 <- rowwise(raw100_final) %>% 
  mutate(volume = vol_func(diameter = sa, height = la, width = wi, 
                           shape = shp, counts = counts)) %>% 
  mutate(vol_per_org_um3 = volume/counts)
### Save the file as an R data file
save(vol100, file = "data/vol100.Rdata")
write_xlsx(vol100, "results/vol100.xlsx")

### Create a data frame that eliminates the zero count organisms
vol100_no0 <- vol100 %>% 
  rowwise() %>% 
  filter(counts != 0)

save(vol100_no0, file = "data/vol100_no0.Rdata")
write_xlsx(vol100_no0, "results/vol100_no0.xlsx")

### 10/17/22 Test to see if total obs. will change if I filter out the
##   rows where the volume is 0
vol100_test_no0_vol <- vol100 %>% 
  rowwise() %>% 
  filter(volume != 0) 

### Run the biomass function using the volume data file, vol100.
bio100 <- rowwise(vol100) %>% 
  mutate(biomass = biomass_func(volume = volume, Group = Group))
### Save the file as an R data file
save(bio100, file = "data/bio100.Rdata")
  
################ FOR 400X ################
### Load the raw counts data

load("data/raw400_final.Rdata")
## Run the volume function
# Also, dd a column that calculates the volume per organism,
# and rename the volume column to include units of micrograms cubed.
vol400 <- rowwise(raw400_final) %>% 
  mutate(volume = vol_func(diameter = sa, height = la, width = wi, 
                           shape = shp, counts = counts)) %>% 
  mutate(vol_per_org_um3 = volume/counts)
### Save the file as an R data file
save(vol400, file = "data/vol400.Rdata")
write_xlsx(vol400, "results/vol400.xlsx")

### Create a data frame that eliminates the zero count organisms
load("data/vol400.Rdata")
vol400_no0 <- vol400 %>% 
  rowwise() %>% 
  filter(counts != 0)
save(vol400_no0, file = "data/vol400_no0.Rdata")
write_xlsx(vol400_no0, "results/vol400_no0.xlsx")

### 10/17/22 Test to see if total obs. will change if I filter out the
##   rows where the volume is 0
vol400_test_no0_vol <- vol400 %>% 
  rowwise() %>% 
  filter(volume != 0) 

### Run the biomass function using the volume data file, vol400.
bio400 <- rowwise(vol400) %>% 
  mutate(biomass = biomass_func(volume = volume, Group = Group))

####################### JOIN 100X WITH 400X ########################
