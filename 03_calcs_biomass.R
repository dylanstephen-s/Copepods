####################################################################
##################### 100x AND 400X BIOMASS ########################
####################################################################

library(tidyverse)
library(writexl)

### Load the biomass function
source("scripts/01_function_biomass.R")

################ FOR 100X ################
### Load the vol100, which is the data file with the volume calculations
load("data/vol100.Rdata")
### Run the biomass function 
volbio100 <- rowwise(vol100) %>% 
  mutate(biomass = biomass_func(volume = volume, Group = Group))
### Save the file as an R data file
save(volbio100, file = "data/volbio100.Rdata")
write_xlsx(volbio100, "results/volbio100.xlsx")

### NO ZEROS 100x

### Load the vol100_no0, which is the data file with the volume calculations
##  vol100_no0 was created in the script 03_calcs_volume.R
load("data/vol100_no0.Rdata")
### Run the biomass function 
volbio100_no0 <- rowwise(vol100_no0) %>% 
  mutate(biomass = biomass_func(volume = volume, Group = Group))
### Save the file as an R data file
save(volbio100_no0, file = "data/volbio100_no0.Rdata")
write_xlsx(volbio100_no0, "results/volbio100_no0.xlsx")



################ FOR 400X ################
### Load the vol400, which is the data file with the volume calculations
load("data/vol400.Rdata")
### Run the biomass function 
volbio400 <- rowwise(vol400) %>% 
  mutate(biomass = biomass_func(volume = volume, Group = Group))
### Save the file as an R data file
save(volbio400, file = "data/volbio400.Rdata")
write_xlsx(volbio400, "results/volbio400.xlsx")

### NO ZEROS 400x 

### Load the vol400_no0, which is the data file with the volume calculations
load("data/vol400_no0.Rdata")
### Run the biomass function 
volbio400_no0 <- rowwise(vol400_no0) %>% 
  mutate(biomass = biomass_func(volume = volume, Group = Group))
### Save the file as an R data file
save(volbio400_no0, file = "data/volbio400_no0.Rdata")
write_xlsx(volbio400_no0, "results/volbio400_no0.xlsx")
